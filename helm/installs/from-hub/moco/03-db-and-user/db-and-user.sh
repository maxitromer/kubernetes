#!/bin/bash

# Prompt for the namespace
read -p "Enter the database namespace: " NAMESPACE

# Prompt for the cluster name
read -p "Enter the cluster name: " CLUSTER_NAME

# Prompt for a unique value
read -p "Enter a unique value for user and database names: " UNIQUE_VALUE

# Generate a random password
PASSWORD=$(openssl rand -base64 12)

# Regenerate in base64 format 
PASSWORD_IN_BASE64=$(echo -n "$PASSWORD" | base64)

# Set variables using the unique value
USER_NAME="${UNIQUE_VALUE}_user"
DB_NAME="${UNIQUE_VALUE}_database"

# Create user with the generated password
kubectl moco -n "$NAMESPACE" mysql -u moco-writable "$CLUSTER_NAME" -- -e "CREATE USER '$USER_NAME'@'%' IDENTIFIED BY '$PASSWORD'"

# Create database
kubectl moco -n "$NAMESPACE" mysql -u moco-writable "$CLUSTER_NAME" -- -e "CREATE DATABASE $DB_NAME"

# Grant privileges
kubectl moco -n "$NAMESPACE" mysql -u moco-writable "$CLUSTER_NAME" -- -e "GRANT ALL ON $DB_NAME.* TO '$USER_NAME'@'%'"

# Display the generated user, database, and password
echo "Created user: $USER_NAME"
echo "Created database: $DB_NAME"
echo "Generated password: $PASSWORD"
echo "Generated password in base64 : $PASSWORD_IN_BASE64"
