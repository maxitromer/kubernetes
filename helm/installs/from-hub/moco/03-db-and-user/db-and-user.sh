#!/bin/bash

# Ask if user wants to use defaults values for cluster name and namespace
read -p "Do you want to use the default namespace (databases) and cluster name (mysql-cluster)? (y/n): " USE_DEFAULT_CLUSTER

if [[ $USE_DEFAULT_CLUSTER =~ ^[Yy]$ ]]; then
    NAMESPACE="databases"
    CLUSTER_NAME="mysql-cluster"
else
    read -p "Enter the cluster name: " CLUSTER_NAME
fi
# Prompt for a unique value
read -p "Enter a unique value for user and database names: " UNIQUE_VALUE

# Generate a random password
PASSWORD=$(openssl rand -base64 12)
# After getting the UNIQUE_VALUE, sanitize it
UNIQUE_VALUE=$(echo "$UNIQUE_VALUE" | tr '-' '_')

# Regenerate in base64 format 
PASSWORD_IN_BASE64=$(echo -n "$PASSWORD" | base64)

# Set variables using the sanitized unique value
USER_NAME="${UNIQUE_VALUE}_user"
DB_NAME="${UNIQUE_VALUE}_database"

# Create user with the generated password
kubectl moco -n "$NAMESPACE" mysql -u moco-writable "$CLUSTER_NAME" -- -e "CREATE USER '$USER_NAME'@'%' IDENTIFIED BY '$PASSWORD'"

# Create database
kubectl moco -n "$NAMESPACE" mysql -u moco-writable "$CLUSTER_NAME" -- -e "CREATE DATABASE $DB_NAME"

# Grant privileges
kubectl moco -n "$NAMESPACE" mysql -u moco-writable "$CLUSTER_NAME" -- -e "GRANT ALL ON $DB_NAME.* TO '$USER_NAME'@'%'"

# Display the generated user, database, and password
echo "dbName: $DB_NAME"
echo "username: $USER_NAME"
echo "secretPasswordKey: $PASSWORD_IN_BASE64 # base64 format"
echo "# actual password: $PASSWORD"
