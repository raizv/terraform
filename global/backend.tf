terraform {
  backend "remote" {
    organization = "raizv"

    workspaces {
      name = "global"
    }
  }
}
