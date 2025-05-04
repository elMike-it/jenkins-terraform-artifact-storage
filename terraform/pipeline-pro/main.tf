# Elegir el provider google, así como la versión
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53.0, < 6.5.0"
    }

  }
}
#Indica que proveedor se usará así como la región, zona y proyecto a tratar
provider "google" {
  #credentials = var.credentials
  project = var.project_id
  #region        = "us-central1"
}
