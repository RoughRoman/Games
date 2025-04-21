provider "aws" {
    region = "af-south-1"
}

terraform {
    backend "s3" {
        bucket         = "my-terraform-state-bucket"
        key            = "terraform/state"
        region         = "af-south-1"
        encrypt        = true
    }
}