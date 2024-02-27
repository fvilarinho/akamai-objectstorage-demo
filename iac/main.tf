# Terraform definition.
terraform {
  # State management definition.
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "akamai-objectstorage-demo.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }

  # Required providers definition.
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}