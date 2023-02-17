

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 2.48.0, >= 3.40.0, >= 3.73.0, >= 4.20.0, >= 4.22.0, >= 4.53.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}