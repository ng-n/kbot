terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.52.0"
    }
  }

  backend "gcs" {
    bucket = "tf_code_storage"
    prefix = "terraform/state"
  }
}