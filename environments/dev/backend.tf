terraform {
  backend "s3" {
    bucket = "terraform-and-ci-states"
    key    = "dev"
    region = "eu-central-1"
  }
}
