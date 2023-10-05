

#!/bin/bash



# Set the path to the Apache Airflow configuration file

CONFIG_FILE=${PATH_TO_AIRFLOW_CONFIG}



# Set the desired pool size

POOL_SIZE=${DESIRED_POOL_SIZE}



# Update the connection pool size in the configuration file

sed -i "s/^parallelism = .*/parallelism = $POOL_SIZE/" $CONFIG_FILE



# Restart Apache Airflow

sudo systemctl restart airflow-webserver

sudo systemctl restart airflow-scheduler