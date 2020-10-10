variable "dev_region" {
  default = "us-central1"
}
variable "prod_region" {
  default = "us-west1"
}
variable "dev_project" {
  default     = "dev84910345"
}
variable "prod_project" {
  default     = "prod84910345"
}
variable "dev_credentials" {
  default = "./dev.json"
}
variable "prod_credentials" {
  default = "./prod.json"
}
variable "devvpc" {
  default = "development"
}
variable "prodvpc" {
  default = "production"
}
variable "devsubnet" {
  default = "development"
}
variable "prodsubnet" {
  default = "prod1"
}
variable "dev_subnet_cidr" {
  default = "192.168.0.0/24"
}
variable "prod_subnet_cidr" {
  default = "172.16.0.0/24"
}
variable "dev_firewall" {
  default = "development"
}
variable "prod_firewall" {
  default = "production"
}
# Google Cloud connection & authentication and Application configuration | variables-auth.tf

variable "k8s_namespace" {
  default = "production"
}
variable "k8s_sa_name" {
  default = "prod"
}


# GCP authentication file
variable "gcp_auth_file" {
  default = "./dev.json"
  description = "GCP authentication file"
}
# define GCP region
variable "region" {
  type = string
  default = "us-central"
  description = "GCP region"
}

# define GCP zone
variable "zone" {
  type = string
  default = "us-central1-a"
  description = "GCP zone"
}

# define GCP project name
variable "app_project" {
  type = string
  default = "dev84910345"
  description = "GCP project name"
}
# define GCP project name
variable "project_id" {
  type = string
  default = "dev84910345"
  description = "GCP project name"
}
# define application name
variable "app_name" {
  type = string
  default = "joomlacontainer"
  description = "Application name"
}

# define application environment
variable "app_environment" {
  type = string
  default = "production"
  description = "Application environment"
}
variable "gke_username" {
  default     = "hbgkecluster"
  description = "gke username"
}

variable "gke_password" {
  default     = "Hb_g5c3p0_g5k8e3@0000"
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

# define GCP zone
variable "gcp_zone_1" {
  type = string
  default = "us-west1-a"
  description = "GCP zone"
}

variable "cluster_name" {
  description = "name of the cluster"
  default     = "mysql"
}
# database instance settings
variable "db_version" {
  description = "The version of of the database. For example, MYSQL_5_6 or MYSQL_5_7"
  default     = "MYSQL_5_7"
}

variable "db_tier" {
  description = "The machine tier (First Generation) or type (Second Generation). Reference: https://cloud.google.com/sql/pricing"
  default     = "db-f1-micro"
}

variable "db_activation_policy" {
  description = "Specifies when the instance should be active. Options are ALWAYS, NEVER or ON_DEMAND"
  default     = "ALWAYS"
}
variable "availability_type" {
  description = "Specifies when the instance should be active. Options are ALWAYS, NEVER or ON_DEMAND"
  default     = "ZONAL"
}

variable "db_disk_autoresize" {
  description = "Second Generation only. Configuration to increase storage size automatically."
  default     = true
}

variable "db_disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  default     = 10
}

variable "db_disk_type" {
  description = "Second generation only. The type of data disk: PD_SSD or PD_HDD"
  default     = "PD_SSD"
}

variable "db_pricing_plan" {
  description = "First generation only. Pricing plan for this instance, can be one of PER_USE or PACKAGE"
  default     = "PER_USE"
}

variable "db_instance_access_cidr" {
  description = "The IPv4 CIDR to provide access the database instance"
  default     = "0.0.0.0/0"
}

# database settings
variable "db_name" {
  description = "Name of the default database to create"
  default     = "joomla"
}

variable "db_charset" {
  description = "The charset for the default database"
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example for MySQL databases: 'utf8_general_ci'"
  default     = ""
}

# user settings
variable "db_user_name" {
  description = "The name of the default user"
  default     = "root"
}

variable "db_user_host" {
  description = "The host for the default user"
  default     = "%"
}

variable "db_user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = "root"
}
variable "image_name" {
  description = "The kind of VM this instance will become"
  default     = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190403"
}

variable "machine_size" {
  description = "The size that this instance will be."
  default     = "f1-micro"
}
