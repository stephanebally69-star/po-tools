#!/bin/bash
# Configuration Azure DevOps — PO Tools
# Source ce fichier avant d'utiliser les scripts : source config.sh

export AZURE_DEVOPS_ORG="https://dev.azure.com/nexans-crm"
export AZURE_DEVOPS_PAT="${AZURE_DEVOPS_PAT:-}"

# Projets disponibles
export ADO_PROJECT_E3="Digital Factory - E3"
export ADO_PROJECT_RECYCLING="Recycling Cables"

# Alias pour les requêtes curl
ado_api() {
  local path="$1"
  shift
  curl -s -u ":${AZURE_DEVOPS_PAT}" \
    -H "Content-Type: application/json" \
    "$@" \
    "${AZURE_DEVOPS_ORG}/${path}"
}
