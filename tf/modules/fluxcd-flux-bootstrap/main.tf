provider "flux" {

    kubernetes = {
        #config_path = var.config_path
        config_path = module.gke_cluster.kubeconfig
        
    }

    git = {
        url = "https://github.com/${var.github_repository}.git"
        http = {
            username = "git"
            password = var.github_token
        }
    }
}