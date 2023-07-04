module "gke_cluster" {
  source         = "git::https://github.com/den-vasyliev/tf-google-gke-cluster.git"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}

module "github_repository" {
  source                   = "github.com/den-vasyliev/tf-github-repository"
  github_owner             = var.GITHUB_OWNER
  github_token             = var.GITHUB_TOKEN
  repository_name          = var.FLUX_GITHUB_REPO
  public_key_openssh       = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux0"
}

module "tls_private_key" {
  source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
}

module "flux_bootstrap" {
  source            = "github.com/den-vasyliev/tf-fluxcd-flux-bootstrap"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
  private_key       = module.tls_private_key.private_key_pem
  github_token      = var.GITHUB_TOKEN
  #config_host       = module.gke_cluster.config_host
  #config_token      = module.gke_cluster.config_token
  #config_ca         = module.gke_cluster.config_ca
}

module "kind_cluster" {
  source = "github.com/den-vasyliev/tf-kind-cluster"
}

module "gke-workload-identity" {
    source          = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
    use_existing_k8s_sa = true
    name            = "kustomize-controller"
    namespace       = "flux-system"
    project_id      = var.GOOGLE_PROJECT
    cluster_name    = "main"
    location        = var.GOOGLE_REGION
    annotate_k8s_sa = true
    roles           = ["roles/cloudkms.cryptoKeyEncrypterDecrypter"]
}

module "kms" {
    source          = "github.com/den-vasyliev/terraform-google-kms"
    project_id      = var.GOOGLE_PROJECT
    keyring         = "sops-flux"
    location        = "global"
    keys            = ["sops-key-flux"]
    prevent_destroy = false
}
terraform {
  required_providers {
    /*grafana = {
        source = "grafana/grafana"
        version = "1.42.0"
    }*/
    /*flux = {
      source = "fluxcd/flux"
      version = "1.0.0-rc.5"
    }*/
  }
  backend "gcs" {
    bucket = "tf_code_storage"
    prefix = "terraform/state"
  }
  
}