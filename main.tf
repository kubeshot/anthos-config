#SA for config_connector
resource "google_service_account" "cluster_service_account" {
  account_id   = "config-connector"
  display_name = "config connector SA"
  project      = var.project_id
}

resource "google_project_iam_member" "config-connector-sa-admin-role" {
project = var.project_id
role    = "roles/iam.serviceAccountAdmin"
member  = "serviceAccount:config-connector@${var.project_id}.iam.gserviceaccount.com"
  depends_on         = [google_service_account.cluster_service_account]
} 

resource "google_project_iam_member" "config-connector-compute-admin-role" {
project = var.project_id
role    = "roles/owner"
member  = "serviceAccount:config-connector@${var.project_id}.iam.gserviceaccount.com"
  depends_on         = [google_service_account.cluster_service_account]
}

#Iam binding for config_connector with cloud 
resource "google_service_account_iam_member" "iam_binding_for_config_connector" {
  service_account_id = google_service_account.cluster_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager-config]"
  depends_on         = [google_service_account.cluster_service_account]
}

#for namespace SA

resource "google_service_account" "project-a_service_account" {
  account_id   = "project-a"
  display_name = "config connector SA"
  project      = var.project_id
}

resource "google_project_iam_member" "project-a-owner-role" {
project = var.project_id
role    = "roles/owner"
member  = "serviceAccount:project-a@${var.project_id}.iam.gserviceaccount.com"
  depends_on         = [google_service_account.project-a_service_account]
}

resource "google_project_iam_member" "project-a-sa-metricWriter-role" {
project = var.project_id
role    = "roles/monitoring.metricWriter"
member  = "serviceAccount:project-a@${var.project_id}.iam.gserviceaccount.com"
depends_on         = [google_service_account.project-a_service_account]
} 

resource "google_service_account_iam_member" "iam_binding_for_config_connector" {
  service_account_id = google_service_account.project-a_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager-project-a]"
  depends_on         = [google_service_account.project-a_service_account]
}


#Joining the cluster in hub memebership 

 module "hub_membeship" {
  source        = "./hub-membership"
  project_id    = var.project_id
  membership_id = "config-cluster"
  cluster_name  = "anthos-config-cluster"
  location      ="us-central1-c"
 }
