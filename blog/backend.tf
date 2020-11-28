terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18"
    }
  }
  backend "s3"{
      bucket = "terraform-backend-918273645"
      region = "eu-central-1"
      key = "blog"
      profile = "blog"
  }
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}