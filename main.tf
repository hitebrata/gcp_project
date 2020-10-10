// Configure the Google Cloud provider
provider "google" {
}

// Create Dev VPC
resource "google_compute_network" "devvpc" {
 name                    = var.devvpc
 project                 = var.dev_project
 routing_mode            ="GLOBAL"
 auto_create_subnetworks = "false"
}
// Create Prod VPC
resource "google_compute_network" "prodvpc" {
 name                    = var.prodvpc
 project                 = var.prod_project
 routing_mode            ="GLOBAL"
 auto_create_subnetworks = "false"
}

// Create Dev Subnet
resource "google_compute_subnetwork" "dev_subnet" {
 name                    = var.devsubnet
 project = var.dev_project
 ip_cidr_range           = var.dev_subnet_cidr
 network                 = google_compute_network.devvpc.name
 depends_on              = [google_compute_network.devvpc]
 region                  = var.dev_region
}
// Create Prod Subnet
resource "google_compute_subnetwork" "prod_subnet" {
 name          = var.prodsubnet
 project = var.prod_project
 ip_cidr_range = var.prod_subnet_cidr
 network       = google_compute_network.prodvpc.name
 depends_on    = [google_compute_network.prodvpc]
 region      = var.prod_region
}



// Dev VPC firewall configuration
resource "google_compute_firewall" "dev_firewall" {
  name    = var.dev_firewall
  network = google_compute_network.devvpc.name
  project = var.dev_project

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "1000-2000","22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

//Prod  VPC firewall configuration
resource "google_compute_firewall" "prod_firewall" {
  name    = var.prod_firewall
  network = google_compute_network.prodvpc.name
  project = var.prod_project

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3306", "8080", "1000-2000","22"]
  }

  source_ranges = ["0.0.0.0/0"]
  }
  #  peering
  resource "google_compute_network_peering" "peering_dev_prod" {
    name         = "peering-test"
    network      = google_compute_network.devvpc.id
    peer_network = google_compute_network.prodvpc.id

  }
  resource "google_compute_network_peering" "peering_prod_vpc" {
    name         = "peering-test"
    network      = google_compute_network.prodvpc.id
    peer_network = google_compute_network.devvpc.id
  }
  # GKE cluster
  resource "google_container_cluster" "primary" {
    depends_on=[google_compute_network_peering.peering_prod_vpc]
    name     = "hbgke40"
    location = "us-central1-a"
    project = "dev84910345"
    initial_node_count = 3
    network    = google_compute_network.devvpc.name
    subnetwork = google_compute_subnetwork.dev_subnet.name
    master_auth {
      username = var.gke_username
      password = var.gke_password
      client_certificate_config {
        issue_client_certificate = false
      }
    }
    node_config {
      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
      metadata = {
            disable-legacy-endpoints = "true"
          }
      labels = {
            app = "joomla"
          }
      tags = ["website", "joomla"]
        }
      timeouts {
          create = "30m"
          update = "40m"
        }
  }

  resource "null_resource" "nullremote1"  {
depends_on=[google_container_cluster.primary]
provisioner "local-exec" {
            command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${google_container_cluster.primary.location}  --project ${google_container_cluster.primary.project}"
        }
}

# create My SQL database instance
resource "google_sql_database_instance" "my_sql" {
  depends_on=[google_container_cluster.primary]
  name                 = "emilimysql3"
  project              = var.prod_project
  region               = var.prod_region
  database_version     = var.db_version
  #network    = google_compute_network.prodvpc.name
  #subnetwork = google_compute_subnetwork.prod_subnet.name



  settings {
    tier = var.db_tier
    activation_policy           = var.db_activation_policy
    disk_autoresize             = var.db_disk_autoresize
    availability_type           = var.availability_type
    disk_size                   = var.db_disk_size
    disk_type                   = var.db_disk_type
    pricing_plan                = var.db_pricing_plan

    location_preference {
      zone = var.gcp_zone_1
    }

    maintenance_window {
      day  = "7"  # sunday
      hour = "3" # 3am
    }

    database_flags {
      name  = "log_bin_trust_function_creators"
      value = "on"
    }

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "00:00"
    }

    ip_configuration {
      ipv4_enabled = "true"
      #private_network = google_compute_network.prodvpc.self_link
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }
  }
}

# create database
resource "google_sql_database" "my_sql_db" {
  name      = var.db_name
  project   = var.prod_project
  instance  = google_sql_database_instance.my_sql.name
  charset   = var.db_charset
  collation = var.db_collation
}

# create user
resource "random_id" "user_password" {
  byte_length = 8
}

resource "google_sql_user" "my-sql" {
  name     = var.db_user_name
  project  = var.prod_project
  instance = google_sql_database_instance.my_sql.name
  host     = var.db_user_host
  password = var.db_user_password
}
