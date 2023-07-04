resource "helm_release" "flux" {
    name    = "flux"
    repository = "https://charts.fluxcd.io"
    chart       = "flux"
    version     = "1.3.0"
    namespace   = "flux-system"

    set {
      name = "git.url"
      value = "git@github.com:ng-n/flux-gitops.git"
    }

    set {
      name = "git.path"
      value = "/"
    }

    values = [file("${path.module}/secret-manifest.enc.yaml")]
}

# Install Flux
/*resource "null_resource" "install_flux" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -s https://fluxcd.io/install.sh | bash
      flux install
    EOT
  }
}

resource "null_resource" "create_source_git" {
  provisioner "local-exec" {
    command = "flux create source git flux-monitoring --interval=30m --url=https://github.com/fluxcd/flux2 --branch=main"
  }
}


resource "null_resource" "create_kustomizations" {
  depends_on = [
    null_resource.create_source_git
  ]

  provisioner "local-exec" {
    command = <<-EOT
      flux create kustomization kube-prometheus-stack \
        --interval=1h \
        --prune \
        --source=flux-monitoring \
        --path="./manifests/monitoring/kube-prometheus-stack" \
        --health-check-timeout=5m \
        --wait

      flux create kustomization monitoring-config \
        --depends-on=kube-prometheus-stack \
        --interval=1h \
        --prune=true \
        --source=flux-monitoring \
        --path="./manifests/monitoring/monitoring-config" \
        --health-check-timeout=1m \
        --wait
    EOT
  }
}*/
 /*
resource "null_resource" "port_forward" {
  provisioner "local-exec" {
    command = "kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3003:80"
  }
}
*/
