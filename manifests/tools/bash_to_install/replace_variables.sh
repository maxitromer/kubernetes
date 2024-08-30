#!/bin/bash

# Leer el archivo values.txt línea por línea
while IFS='=' read -r key value; do
  # Reemplazar todas las instancias de "{{key}}" con el valor correspondiente en el archivo YAML
  sed -i "s/{{${key}}}/${value}/g" deployment.yaml
done < variables.txt
