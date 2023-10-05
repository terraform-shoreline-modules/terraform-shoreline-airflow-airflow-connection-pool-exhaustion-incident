resource "shoreline_notebook" "airflow_connection_pool_exhaustion_incident" {
  name       = "airflow_connection_pool_exhaustion_incident"
  data       = file("${path.module}/data/airflow_connection_pool_exhaustion_incident.json")
  depends_on = [shoreline_action.invoke_connection_monitor,shoreline_action.invoke_update_pool_size]
}

resource "shoreline_file" "connection_monitor" {
  name             = "connection_monitor"
  input_file       = "${path.module}/data/connection_monitor.sh"
  md5              = filemd5("${path.module}/data/connection_monitor.sh")
  description      = "High traffic: A sudden surge in user traffic or an increase in the number of workflow tasks can put a strain on the connection pool and lead to exhaustion."
  destination_path = "/agent/scripts/connection_monitor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_pool_size" {
  name             = "update_pool_size"
  input_file       = "${path.module}/data/update_pool_size.sh"
  md5              = filemd5("${path.module}/data/update_pool_size.sh")
  description      = "Increase the connection pool size: One of the most common remediation strategies for connection pool exhaustion is to increase the pool size. This can be done by modifying the configuration settings of the Apache Airflow platform to allocate more resources to the connection pool."
  destination_path = "/agent/scripts/update_pool_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_connection_monitor" {
  name        = "invoke_connection_monitor"
  description = "High traffic: A sudden surge in user traffic or an increase in the number of workflow tasks can put a strain on the connection pool and lead to exhaustion."
  command     = "`chmod +x /agent/scripts/connection_monitor.sh && /agent/scripts/connection_monitor.sh`"
  params      = ["PATH_TO_AIRFLOW_LOG_FILE","EXPECTED_NUMBER_OF_CONNECTIONS","PATH_TO_AIRFLOW_HOME_DIRECTORY"]
  file_deps   = ["connection_monitor"]
  enabled     = true
  depends_on  = [shoreline_file.connection_monitor]
}

resource "shoreline_action" "invoke_update_pool_size" {
  name        = "invoke_update_pool_size"
  description = "Increase the connection pool size: One of the most common remediation strategies for connection pool exhaustion is to increase the pool size. This can be done by modifying the configuration settings of the Apache Airflow platform to allocate more resources to the connection pool."
  command     = "`chmod +x /agent/scripts/update_pool_size.sh && /agent/scripts/update_pool_size.sh`"
  params      = ["DESIRED_POOL_SIZE","PATH_TO_AIRFLOW_CONFIG"]
  file_deps   = ["update_pool_size"]
  enabled     = true
  depends_on  = [shoreline_file.update_pool_size]
}

