module "gke_cluster" {
  source = "git::https://github.com/ng-n/kbot.git//tf/modules/gke_cluster"
  #source = "git::https://github.com/ng-n/kbot.git//tf/modules/kind_cluster"
}