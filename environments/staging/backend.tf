terraform {
  backend "s3" {
    bucket = "terraform-and-ci-states"
    key    = "staging"
    region = "eu-central-1"
  }
}
