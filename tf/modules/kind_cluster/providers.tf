provider "kind" {
    #provider    = "docker"
    kubeconfig  = pathexpand("${path.module}/kind-config")
}