# PO Tools

Boîte à outils pour Product Owner — gain de temps sur la rédaction des User Stories et la recette.

## Structure

```
po-tools/
├── templates/
│   ├── user-stories/    # Templates de User Stories
│   └── recette/         # Templates de plans de recette
├── scripts/
│   └── azure-devops/    # Scripts d'automatisation Azure DevOps
├── skills/              # Skills Claude Code réutilisables
└── .claude/             # Configuration Claude Code
```

## Templates

### User Stories
- `us-standard.md` — Template d'US classique avec critères d'acceptance
- `us-gherkin.md` — Template d'US avec scénarios Gherkin (Given/When/Then)

### Recette
- `plan-recette.md` — Plan de recette complet (nominal, limites, erreurs)
- `checklist-recette.md` — Checklist rapide de validation

## Scripts Azure DevOps

Scripts pour interagir avec l'API Azure DevOps :
- Lecture/écriture de Work Items
- Export de backlog
- Synchronisation de statuts

## Skills

Skills Claude Code pour automatiser les tâches PO récurrentes.

## Setup

### Prérequis
- Git
- GitHub CLI (`gh`) pour la gestion du repo distant
- Azure CLI (`az`) ou un Personal Access Token Azure DevOps
