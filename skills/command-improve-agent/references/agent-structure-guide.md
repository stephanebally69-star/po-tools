# Agent Structure Guide

Guide pour comprendre, modifier et restructurer un agent custom.

## Discovery de l'agent cible

Avant toute modification :

1. Lire le `SKILL.md` de l'agent — comprendre son rôle, son workflow, sa langue (FR/EN)
2. Lister les fichiers dans `references/` — comprendre la partition existante (par couche ? par domaine ? par type de règle ?)
3. Identifier les conventions — format des titres, style des règles, structure markdown

## Décision d'emplacement

Choisir où écrire chaque amélioration selon sa nature :

| Nature de l'amélioration | Destination |
|--------------------------|-------------|
| Anti-pattern (ce que l'agent ne doit PAS faire) | `anti-patterns.md` s'il existe |
| Pattern technique lié à une couche (API, state, UI...) | `patterns-*.md` correspondant |
| Règle comportementale générale | `SKILL.md` (section règles/principes) |
| Nouvelle catégorie sans fichier existant | Nouveau fichier reference si > 3 règles de même nature, sinon au plus proche |

## Règles d'écriture

- **Respecter la langue** : Détecter FR ou EN dans l'agent cible. Ne jamais mélanger.
- **Respecter le format** : Reprendre la même structure markdown (titres, listes, tableaux) que le fichier existant
- **Pas de duplication** : Avant d'écrire, vérifier que la règle n'existe pas déjà (même reformulée)
- **Pas de contradiction** : Si la nouvelle règle contredit une règle existante, signaler à l'utilisateur au lieu d'écrire silencieusement
- **Insérer au bon endroit** : Ajouter la règle dans la section thématique pertinente, pas à la fin du fichier en vrac

## Restructuration

Déclencher une restructuration quand :
- `SKILL.md` dépasse ~300 lignes → extraire des sections vers de nouveaux fichiers `references/`
- Un fichier `references/` dépasse ~200 lignes → splitter par sous-thème
- Un fichier mélange des préoccupations distinctes → séparer

Règles :
- Max 1 extraction majeure (création de fichier) par invocation du skill
- Déplacer du contenu + ajouter un lien dans SKILL.md est acceptable (pas une suppression)
- Ne jamais supprimer de contenu existant — seulement ajouter, déplacer ou réorganiser
- Proposer les restructurations supplémentaires en follow-up à l'utilisateur
