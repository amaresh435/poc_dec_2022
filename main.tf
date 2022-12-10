terraform {
  required_version = "~> 1.3.5"
  required_providers {
    google = "~> 4.45.0"
  }
}

provider "google" {
#  access_key = "GOOGYQRHQD6UMEYNAW4KRUF4"
#  secret_key = "QSR4ZA8WcGpv12n4DRNra6utVOVNPq6Ss/8SJPl0"
  project = "internal-interview-candidates"
  region  = "us-central1"
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name = "amar-vpc-network"
}
