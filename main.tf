terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "airflow_connection_pool_exhaustion_incident" {
  source    = "./modules/airflow_connection_pool_exhaustion_incident"

  providers = {
    shoreline = shoreline
  }
}