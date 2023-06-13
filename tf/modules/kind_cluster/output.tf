output "kubeconfig" {
    value       = "${path.module}/kind-config"
    description = "The path to the kubeconfig file"
}