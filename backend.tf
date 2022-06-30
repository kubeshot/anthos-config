terraform {
  required_version = "0.14.9"
  backend "gcs" {
    bucket = "tf-state-kubeshot-devops"
    prefix = "anthos-config/dev"
  }
}