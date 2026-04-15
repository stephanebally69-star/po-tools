---
name: command-improve-agent
description: |
  Commande manuelle pour améliorer les agents custom après une session de travail.
  Analyse le contexte de conversation pour identifier les erreurs récurrentes commises
  par un ou plusieurs agents, propose des améliorations génériques et actionnables,
  puis modifie intelligemment la structure de l'agent pour éviter ces erreurs à l'avenir.
  Peut restructurer un agent si ses fichiers deviennent trop volumineux.

  PAS de déclenchement automatique — invocation explicite uniquement via "/improve-agent".

  DÉCLENCHEURS : "improve agent", "améliore agent", "améliorer l'agent",
  "/improve-agent", ou appel explicite par l'utilisateur après une session avec un agent.

  CIBLES : Uniquement les agents custom `agent-*` dans `~/.claude/skills/`.
---

# Improve Agent

Commande post-session pour améliorer les agents custom à partir des erreurs rencontrées dans la conversation en cours.

## Prérequis

Ce skill s'invoque **dans la même conversation** où un ou plusieurs agents `agent-*` ont été utilisés et ont fait des erreurs corrigées avec l'utilisateur.

## Workflow

4 phases séquentielles : DETECT → RECAP → APPLY → VERIFY

### Phase 1 — DETECT

Analyser le contexte de conversation pour identifier :

1. **Quels agents** — Chercher les invocations `Skill(skill: "agent-*")` et le contenu SKILL.md chargé
2. **Quelles erreurs** — Lire `references/analysis-patterns.md` pour les heuristiques de détection
3. **Quelle cause racine** — Pour chaque erreur, appliquer la méthode des 5 Pourquoi (voir `references/analysis-patterns.md` § Analyse cause racine) pour remonter du symptôme observé à la défaillance structurelle de l'agent (règle manquante, ambiguë, ou mal placée dans son workflow). L'amélioration DOIT cibler cette défaillance structurelle, JAMAIS le symptôme.

**Sorties possibles :**
- Aucun agent `agent-*` détecté → Informer l'utilisateur et **stopper**
- Agent(s) détecté(s) mais aucune erreur généralisable → Informer et **stopper**
- Agent(s) + améliorations identifiées → Passer en Phase 2

### Phase 2 — RECAP

Présenter un récap à l'utilisateur pour validation. Format :

```
Agent ciblé : agent-frontend-kikos

| Problème identifié | Amélioration proposée |
|--------------------|----------------------|
| Description générique | Règle actionnable pour l'agent |

Confirmes-tu ces améliorations ?
```

Si multi-agents : un tableau par agent dans le même message, une confirmation globale à la fin.

L'utilisateur peut :
- Valider tel quel
- Retirer/modifier des lignes
- Retirer un agent entier

**Attendre la validation avant de continuer.**

### Phase 3 — APPLY

Pour chaque agent validé :

1. Lire la structure complète de l'agent (SKILL.md + `references/`)
2. Consulter `references/agent-structure-guide.md` pour les règles d'emplacement et d'écriture
3. Décider où écrire chaque amélioration
4. Appliquer les modifications
5. Restructurer si un fichier dépasse les seuils de taille (max 1 extraction par invocation)

### Phase 4 — VERIFY

1. Relire chaque fichier modifié
2. Vérifier : pas de duplication, pas de contradiction, seuils de taille respectés
3. Afficher un résumé :

```
Modifications effectuées :
- agent-frontend-kikos/references/anti-patterns.md : +2 règles ajoutées
- agent-frontend-kikos/references/patterns-ui.md : +1 pattern ajouté
```

## Idempotence

Si invoqué plusieurs fois dans la même conversation :
- Analyser uniquement les erreurs survenues **après** la dernière invocation
- Si les améliorations précédentes couvrent déjà les problèmes → informer et stopper

## Règles absolues

- JAMAIS de code spécifique à la session dans les améliorations
- JAMAIS de suppression de contenu existant dans l'agent
- JAMAIS d'opérations git (pas de commit, push, etc.)
- TOUJOURS respecter la langue de l'agent cible (FR/EN)
- TOUJOURS vérifier qu'une règle n'existe pas déjà avant d'écrire
