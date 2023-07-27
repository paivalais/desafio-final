module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  project_id                 = "ces-igniteprogram"
  name                       = "lais-clustergke-df-teste"
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
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.1.0/28"
  istio                      = false
  cloudrun                   = false
  dns_cache                  = false
  remove_default_node_pool   = true
  depends_on = [google_compute_router_nat.nat]

  node_pools = [
    {
      name                      = "lais-node-pool-df"
      machine_type              = "n1-standard-2"
      node_locations            = "us-east1-b,us-east1-c"
      initial_node_count        = 1
      max_count                 = 4
      local_ssd_count           = 0
      spot                      = false
      local_ssd_ephemeral_count = 0
      disk_size_gb              = 30
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "sa-ignite-terraform-lais@ces-igniteprogram.iam.gserviceaccount.com"
      preemptible               = false
      
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}