variable "project_id" {
}

variable "membership_id" {

}

variable "location" {
}

variable "cluster_name" {

}


variable "sync_repo" {
  type = string
  # default         = "git@github.com:khatiwadanaresh/anthos.git"
  default = "https://github.com/kubeshot/anthos-config.git"
}

variable "sync_branch" {
  type    = string
  default = "main"
}

variable "policy_directory" {
  type    = string
  default = "config-connector"
}

variable "source_format" {
  default = "unstructured"
}
