terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.12.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.12.0"
    }

  }
}

provider "random" {}

provider "google-beta" {
  project = var.project
  region  = var.region
}

provider "google" {
  project = var.project
  region  = var.region
}

