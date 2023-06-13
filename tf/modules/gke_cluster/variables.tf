variable "GOOGLE_REGION" {
    type        = string
    default     = "us-central1-c"
    description = "GCP region"
}

variable "GKE_CLUSTER_NAME" {
    type        = string
    default     = "develop"
    description = "GKE cluster name"
}

variable "GKE_POOL_NAME" {
    type        = string
    default     = "develop_pool"
    description = "GKE pool name"
}

variable "GKE_NUM_NODES" {
    type        = number
    default     = 2
    description = "GKE cluster nodes number"
}

variable "GKE_MACHINE_TYPE" {
    type        = string
    default     = "g1-small"
    description = "GKE machine type"
}