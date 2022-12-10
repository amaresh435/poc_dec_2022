provider "google" {
#  access_key = "GOOGYQRHQD6UMEYNAW4KRUF4"
#  secret_key = "QSR4ZA8WcGpv12n4DRNra6utVOVNPq6Ss/8SJPl0"
  project = "internal-interview-candidates"

}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name = "amar-vpc-network"
}
