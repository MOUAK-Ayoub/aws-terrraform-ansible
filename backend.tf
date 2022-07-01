terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    profile = "default"
    region  = "us-east-1"
    bucket  = "terraformstatefile2022"
    key     = "terraformstatefile"

  }

}
