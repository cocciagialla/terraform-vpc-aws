# tflint-ignore: terraform_unused_declarations
variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Env of the cluster"
  type        = string
  default     = ""
}

variable "cluster_repo" {
  description = "Git repo used to create the cluster"
  type        = string
  default     = ""
}

variable "cluster_repo_ver" {
  description = "Git repo version used to create the cluster"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR of cluster"
  type        = string
  default     = ""
}

variable "create_private_subnets" {
  description = "Controls if private subnets should be created"
  type        = bool
  default     = true
}
