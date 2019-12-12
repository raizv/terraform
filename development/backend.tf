terraform {
  required_version = "=0.12.16"

  backend "remote" {
    organization = "raizv"

    workspaces {
      name = "development"
    }
  }
}
