output "kubeconfig" {
  #value       = "${path.module}/kubeconfig"
  value         = google_container_cluster.this.kubeconfig
  sensitive     = true
  description = "The path to the kubeconfig file"
}