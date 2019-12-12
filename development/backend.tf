terraform {
  required_version = ">=0.12.18"

  backend "remote" {
    organization = "raizv"

    workspaces {
      name = "development"
    }
  }
}
