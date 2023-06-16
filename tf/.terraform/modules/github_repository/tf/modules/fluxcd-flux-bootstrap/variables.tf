variable "config_path" {
    type        = string
    default     = "~/.kube/config"
    description = "The path to the kubeconfig file"
}

variable "github_repository" {
    type        = string
    description = "Github repository to store Flux manifests"
}

variable "github_token" {
    type        = string
    default     = ""
    description = "The token used to authenticate with the Git repository"
}

variable "target_path" {
    type        = string
    default     = "clusters"
    description = "Flux manifests subdirectory"
}

variable "private_key" {
  type        = string
  description = "The private key used to authenticate with the Git repository"
}