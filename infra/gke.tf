module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  project_id                 = "ces-igniteprogram"
  name                       = "lais-clustergke-df-1" ####
  kubernetes_version         = "1.26.5-gke.1700"
  region                     = "us-east1"
  zones                      = ["us-east1-b", "us-east1-c", "us-east1-d"]
  network                    = "lais-vpc-df"
  subnetwork                 = "lais-subpri-df"
  ip_range_pods              = "secondary-range-ip-pods"
  ip_range_services          = "secondary-range-ip-services"
  http_load_balancing        = true 
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = true
  #enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.1.0/28"
  #istio                      = false
  #cloudrun                   = false
  #dns_cache                  = false
  remove_default_node_pool   = true
  depends_on = [google_compute_router_nat.nat]

  node_pools = [
    {
      name                      = "lais-node-pool-df"
      machine_type              = "n1-standard-2"
      node_locations            = "us-east1-b,us-east1-c,us-east1-d" ###
      min_count                 = 1
      max_count                 = 8
      max_surge                 = 2 ##
      max_unavailable           = 1 ##
      local_ssd_count           = 0
      spot                      = false
      disk_size_gb              = 30
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      autoscaling               = true ###
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "sa-ignite-terraform-lais@ces-igniteprogram.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}