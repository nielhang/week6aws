# Define providers to be used
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57.1"
    }
  }

  #required_version = ">= 1.3.9"

  backend "s3" {
    bucket = "nielangweek6"
    key    = "project/terraform.tfstate"
    region = "eu-west-1"
  }
}

# Set AWS region to variable
provider "aws" {
  region = "eu-west-1"
}


