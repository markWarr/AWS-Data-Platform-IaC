# Core Infrastructure
provider "aws" {
  region = var.aws_region
}

# General
terraform {
  required_version = ">= 0.14.3"

  required_providers {
    aws    = {
      source  = "hashicorp/aws"
      version = "> 4.12.1"
    }
  }
  
  # need backend configuration. For now, state is stored locally.
#  backend "s3" {    
 # }
}