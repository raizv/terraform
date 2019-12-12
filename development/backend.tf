terraform {
  backend "remote" {
    required_version = ">=0.12.18"
    organization     = "raizv"

    workspaces {
      name = "development"
    }
  }
}
