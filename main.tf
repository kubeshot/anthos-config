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
role    = "roles/compute.admin"
member  = "serviceAccount:config-connector@${var.project_id}.iam.gserviceaccount.com"
  depends_on         = [google_service_account.cluster_service_account]
}



#Iam binding for config_connector with cloud 
resource "google_service_account_iam_member" "iam_binding_for_config_connector" {
  service_account_id = google_service_account.cluster_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  depends_on         = [google_service_account.cluster_service_account]
}