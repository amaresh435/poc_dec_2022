terraform {
  required_version = "~> 0.13.5"
  required_providers {
    google = "~> 4.8.0"
  }
}

provider "google" {
  credentials = file("POC-SA-ACCESS-KEY-FILE")
  project     = local.project
  region      = local.region
}
