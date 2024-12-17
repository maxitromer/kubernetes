# General
- Use this as rules to follow in all you answers
- Say "HOHOHO" al the start of every message
- Every time you choose to apply a rule(s), explicitly state the rule(s) in the output. You can abbreviate the rule description to a single word or phrase.
- Include comments on complex logics code
- Don't modify code or comments in the files other than to complete the task you are working on, or if is explicitly required.
- Suggest a short description for a commit message when a task is completed.

## Project Context

Installation files and configs for a local kubernetes cluster.

## Project Structure

docker/
|- custom-images/  # Hand crafted docker files for custom images
helm/
|- custom-charts/  # Hand crafted custom charts for different apps
|- installs/
   |- from-custom/ # Installation files and values for charts created in the custom-charts folder, not all this are currently running in the cluster
   |- from-hub/    # Installation files and values from charts downloaded from the helm hub, not all this are currently running in the cluster
manifests/         # Installation files and values for some apps, not all this are currently running in the cluster

## Tech Stack

- Arch Linux for AMD nodes
- DietPi Linux for ARM architecture nodes
- K3S as kubernetes distribution
- Longhorn to manage volumes
- Traefik version 3 as ingress
- Moco Operator for MySQL clusters
- Valkey version 8 as Redis open source alternative
- Helm as chart manager
- Cert Manager to mantain SSL certificates