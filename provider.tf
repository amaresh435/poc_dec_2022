terraform {
  required_version = "~> 1.3.5"
  required_providers {
    google = "4.45.0"
  }
}

provider "google" {
  credentials = "jsonkey.json"
  project     = local.project
  region      = local.region
}
