# local environment setting
locals {
  project = "internal-interview-candidates"
  region  = "us-central1"
}

# VPC Module CDIR, subnet & routes
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "6.0.0"

  project_id   = local.project
  network_name = "amar-vpc11"
  routing_mode = "REGIONAL"

  delete_default_internet_gateway_routes = "true"

  subnets = [
    {
      subnet_name           = "public"
      subnet_ip             = "10.0.0.0/25"
      subnet_region         = "us-central1"
      subnet_private_access = "false"
      subnet_flow_logs      = "false"
    },
    {
      subnet_name           = "private"
      subnet_ip             = "10.0.1.0/25"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    }
  ]
  
  routes = [
    {
      name              = "egress-internet"
      description       = "Default route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    }
  ]
}

# Cloud router 
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "4.0.0"

  name    = "amar-router1"
  project = local.project
  region  = local.region
  network = module.vpc.network_name
  nats = [{
    name                               = "nat"
    nat_ip_allocate_option             = "AUTO_ONLY"
    #source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    #subnetworks = [{
    #  name                    = "private"
    #  source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    #}]
  }]
}

#Auto scaler 
resource "google_compute_autoscaler" "foobar" {
  name   = "amar-my-autoscaler1"
  zone   = "us-central1-f"
  target = google_compute_instance_group_manager.foobar.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

#Compute Instance Template used for autoscaling
resource "google_compute_instance_template" "foobar" {
  name           = "amar-my-instance-template1"
  machine_type   = "e2-medium"
  can_ip_forward = false

  tags = ["foo", "bar"]

  disk {
    source_image = data.google_compute_image.debian_9.id
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "foobar" {
  name = "my-target-pool1"
}
  
#Manages Instance Group(MIG) used for autoscaling
resource "google_compute_instance_group_manager" "foobar" {
  name = "amar-my-igm1"
  zone = "us-central1-f"
  
  version {
    instance_template  = google_compute_instance_template.foobar.id
    name               = "primary"
  }

  target_pools       = [google_compute_target_pool.foobar.id]
  base_instance_name = "foobar"
}

#Setting Linux Debian cloud image version
data "google_compute_image" "debian_9" {
  family  = "debian-11"
  project = "debian-cloud"
}

#Manages Instance Group(MIG) used for autoscaling
resource "google_compute_instance" "vm_instance" {
  name = "amar-vm-instance1"
  machine_type = "f1-micro"
  zone = "us-central1-c"
  tags = ["default", "amar-vpc2"]
  boot_disk {
     initialize_params {
     image = "debian-cloud/debian-11"
     }
  }
    network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }
  #apache2.sh is used to change default port 80 to 8080
  metadata_startup_script = file("./apache2.sh")
}

#Firewall exposing port 8080 for webserver
resource "google_compute_firewall" "default" {
  name    = "amar-test-firewall01"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "amar-vpc31"
}

#Load Balancer this will create its dependecy like google_compute_firewall.default-lb-fw, google_compute_forwarding_rule, load_balancer.google_compute_http_health_check & load_balancer.google_compute_target_pool
module "load_balancer" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "~> 2.0.0"
  region       = local.region
  name         = "load-balancer-01"
  service_port = 8080
  target_tags  = ["allow-lb-service"]
  network      = "amar-vpc31"
}
