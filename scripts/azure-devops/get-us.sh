#!/bin/bash
# Récupère le détail complet d'un Work Item par son ID
# Usage: ./get-us.sh 48915

source "$(dirname "$0")/config.sh"

WI_ID="${1:?Usage: ./get-us.sh <WORK_ITEM_ID>}"

curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "${AZURE_DEVOPS_ORG}/_apis/wit/workitems/${WI_ID}?\$expand=all&api-version=7.0" \
  | python3 -c "
import sys, json, html, re

data = json.load(sys.stdin)
f = data.get('fields', {})

def strip_html(text):
    if not text:
        return ''
    text = re.sub(r'<br\s*/?>', '\n', text)
    text = re.sub(r'<[^>]+>', '', text)
    return html.unescape(text).strip()

print(f\"=== Work Item #{f.get('System.Id', 'N/A')} ===\")
print(f\"Type      : {f.get('System.WorkItemType', 'N/A')}\")
print(f\"Titre     : {f.get('System.Title', 'N/A')}\")
print(f\"Projet    : {f.get('System.TeamProject', 'N/A')}\")
print(f\"État      : {f.get('System.State', 'N/A')}\")
print(f\"Sprint    : {f.get('System.IterationPath', 'N/A')}\")
assigned = f.get('System.AssignedTo', {})
if isinstance(assigned, dict):
    print(f\"Assigné à : {assigned.get('displayName', 'Non assigné')}\")
print()
print('--- Description ---')
print(strip_html(f.get('System.Description', 'Pas de description')))
print()

ac = f.get('Microsoft.VSTS.Common.AcceptanceCriteria', '')
if ac:
    print('--- Critères d acceptance ---')
    print(strip_html(ac))
    print()

repro = f.get('Microsoft.VSTS.TCM.ReproSteps', '')
if repro:
    print('--- Repro Steps ---')
    print(strip_html(repro))
    print()

# Relations
rels = data.get('relations', [])
if rels:
    print('--- Relations ---')
    for r in rels:
        print(f\"  {r.get('attributes',{}).get('name','?')} → {r.get('url','')}\")
"
