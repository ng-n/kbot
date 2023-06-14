module "gke_cluster" {
  source = "git::https://github.com/ng-n/kbot.git//tf/modules/gke_cluster"
}

#module "kind_cluster" {
#  source = "git::https://github.com/ng-n/kbot.git//tf/modules/kind_cluster"
#}

module "github-repository" {
  source    = "git::https://github.com/ng-n/kbot.git//tf/modules/github-repository"
  github_owner      = var.GITHUB_OWNER
  github_token      = var.GITHUB_TOKEN
  repository_name   = var.FLUX_GITHUB_REPO
  public_key_openssh    = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux0"    
}

module "fluxcd-flux-bootstrap" {
  source = "git::https://github.com/ng-n/kbot.git//tf/modules/fluxcd-flux-bootstrap"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
  #private_key       = module.tls_private_key.private_key_pem
  config_path       = module.gke_cluster.kubeconfig
}

module "tls_private_key" {
  source    = "git::https://github.com/ng-n/kbot.git//tf/modules/hashicorp-tls-keys"
  algorithm = "RSA"
}