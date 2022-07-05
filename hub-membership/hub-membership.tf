

resource "google_gke_hub_membership" "membership" {
  project       = var.project_id
  provider      = google-beta
  membership_id = var.membership_id
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/projects/${var.project_id}/locations/${var.location}/clusters/${var.cluster_name}"
    }
  }

  authority {
    issuer = "https://container.googleapis.com/v1/projects/${var.project_id}/locations/${var.location}/clusters/${var.cluster_name}"
  }
}




resource "google_gke_hub_feature_membership" "feature_member" {
  provider   = google-beta
  project    = var.project_id
  location   = "global"
  feature    = "configmanagement"
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.10.1"
    config_sync {
      source_format = var.source_format
      git {
        sync_repo   = var.sync_repo
        sync_branch = var.sync_branch
        sync_wait_secs  = 30
        policy_dir = var.policy_directory
        secret_type = "ssh"
        #secret_type = "token"
      }
    }
    policy_controller {
      enabled                    = true
      template_library_installed = true
      referential_rules_enabled  = true
      exemptable_namespaces      = []
    }


  }

}