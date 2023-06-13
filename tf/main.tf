module "gke_cluster" {
    source      = "github.com/ng-n/kbot/tree/main/tf/modules/gke_cluster"
    GOOGLE_REGION = var.GOOGLE_REGION
    GOOGLE_PROJECT = var.GOOGLE_PROJECT
}