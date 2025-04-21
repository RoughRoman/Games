provider "aws" {
    region = "af-south-1"
}

terraform {
    backend "s3" {
        bucket         = "games-terraform-state-bucket"
        key            = "terraform/state"
        region         = "af-south-1"
        encrypt        = false
    }
}

resource "aws_s3_bucket" "testbucket" {
    bucket = "testbucket-1234567890-mattysgames"
}