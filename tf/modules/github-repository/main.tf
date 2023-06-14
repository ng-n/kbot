terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
  }
}

provider "github" {
    owner = var.github_owner
    token = var.github_token
}
