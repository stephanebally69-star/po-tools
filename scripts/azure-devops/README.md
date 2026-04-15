# Scripts Azure DevOps

Scripts pour automatiser les interactions avec Azure DevOps.

## Prérequis

- Un **Personal Access Token (PAT)** Azure DevOps avec les scopes :
  - `Work Items (Read & Write)`
  - `Project and Team (Read)`
- Le token doit être stocké dans une variable d'environnement `AZURE_DEVOPS_PAT`
- L'organisation et le projet doivent être configurés :
  - `AZURE_DEVOPS_ORG` — URL de l'organisation (ex: https://dev.azure.com/mon-org)
  - `AZURE_DEVOPS_PROJECT` — Nom du projet

## Configuration

```bash
export AZURE_DEVOPS_PAT="votre-token"
export AZURE_DEVOPS_ORG="https://dev.azure.com/votre-org"
export AZURE_DEVOPS_PROJECT="votre-projet"
```
