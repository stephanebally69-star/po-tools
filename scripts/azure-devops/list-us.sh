#!/bin/bash
# Liste les User Stories actives d'un projet Azure DevOps
# Usage: ./list-us.sh "Digital Factory - E3"
#        ./list-us.sh "Recycling Cables"

source "$(dirname "$0")/config.sh"

PROJECT="${1:-$ADO_PROJECT_E3}"
PROJECT_ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$PROJECT'))")

echo "=== User Stories actives — $PROJECT ==="
echo ""

# Récupérer les IDs
IDS=$(curl -s -u ":${AZURE_DEVOPS_PAT}" \
  -H "Content-Type: application/json" \
  -X POST "${AZURE_DEVOPS_ORG}/${PROJECT_ENCODED}/_apis/wit/wiql?api-version=7.0" \
  -d "{\"query\": \"SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = '${PROJECT}' AND [System.WorkItemType] = 'User Story' AND [System.State] <> 'Closed' ORDER BY [System.ChangedDate] DESC\"}" \
  | python3 -c "import sys,json; data=json.load(sys.stdin); print(','.join(str(w['id']) for w in data.get('workItems',[])))")

if [ -z "$IDS" ]; then
  echo "Aucune User Story active trouvée."
  exit 0
fi

# Récupérer les détails
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "${AZURE_DEVOPS_ORG}/_apis/wit/workitems?ids=${IDS}&fields=System.Id,System.Title,System.State,System.WorkItemType,System.AssignedTo&api-version=7.0" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('value', []):
    f = item['fields']
    assigned = f.get('System.AssignedTo', {}).get('displayName', 'Non assigné') if isinstance(f.get('System.AssignedTo'), dict) else 'Non assigné'
    print(f\"#{f['System.Id']} | {f['System.State']:<12} | {assigned:<25} | {f['System.Title']}\")
"
