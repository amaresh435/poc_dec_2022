terraform {
  required_version = "~> 1.3.6"
  required_providers {
    google = "~> 4.8.0"
  }
}

provider "google" {
  credentials = file("POC-SA-ACCESS-KEY-FILE")
  project     = local.project
  region      = local.region
}
