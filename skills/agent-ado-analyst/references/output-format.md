# Format de sortie — Rapport d'analyse US

## Template

```markdown
# Analyse US : [Titre de la US]

## 1. Identification

| Champ | Valeur |
|-------|--------|
| **ID** | #[ID ADO ou "Manuel"] |
| **Rôle(s)** | [Rôles concernés + exclusions éventuelles] |
| **Nature** | [Création / Adaptation / Consultation / Listing / Action / Mixte] |
| **Contexte** | [Formulaire / Modal / Page / Onglet / Action simple] |
| **Scoring** | B: [X] / F: [X] (si disponible) |

## 2. Trigger / Point d'entrée

- **Source** : [D'où l'utilisateur déclenche l'action]
- **Forme** : [Bouton / Dropdown / Card cliquable / Icône / Lien]
- **Pattern existant** : [Oui/Non — si oui, référence : "comme c'est déjà le cas pour..."]
- **Points d'accès multiples** : [Lister si plusieurs chemins mènent à cette page/action]

## 3. Flags détectés

| Flag | Valeur | Détail |
|------|--------|--------|
| **HAS_FIGMA** | [Oui/Non] | [Nombre de liens Figma] |
| **HAS_BACKEND** | [Oui/Non] | [Repo backend si spécifié] |
| **Mode** | [ADO/Manuel] | |

## 4. Contenu structuré

> S'adapte au type de US détecté en section 1.

### Type Formulaire / Modal

#### [Nom du bloc]

| Champ | Type | Obligatoire | Cardinalité | Défaut | Limites | Notes |
|-------|------|-------------|-------------|--------|---------|-------|
| [Nom] | [Dropdown/Input/Switch...] | [Oui/Non] | [Single/Multi] | [Valeur ou "-"] | [Max chars...] | [readonly, conditionnel...] |

#### Boutons

| Bouton | Action | Condition | Redirection |
|--------|--------|-----------|-------------|
| [Nom] | [Action] | [Condition d'affichage] | [Vers où + lien Figma] |

### Type Page détail

#### [Nom du bloc d'informations]

| Info | Source | Fallback | Notes |
|------|--------|----------|-------|
| [Libellé] | [Source donnée] | [Si null] | [Dérivée, conditionnelle...] |

#### Actions conditionnelles

| Action | Rôle | Condition (statut) | Résultat |
|--------|------|--------------------|----------|
| [Bouton] | [Qui le voit] | [À quel statut] | [Ce qui se passe] |

### Type Listing / Dashboard

#### Section [Nom]
- **Type** : [Overview / Filtres / Tableau / Cards]
- **Contenu** : [Description]

#### Filtres

| Filtre | Type | Cible |
|--------|------|-------|
| [Nom] | [Search/DatePicker/Tabs/Dropdown] | [Ce qu'il filtre] |

#### Tableau / Cards

| Champ affiché | Notes |
|---------------|-------|
| [Nom] | [Conditionnel, dérivé...] |

- **Pagination** : [Oui/Non]
- **Cliquable** : [Oui/Non — redirige vers...]
- **Action par item** : [Bouton conditionnel si applicable]

### Type Action simple

| Étape | Détail |
|-------|--------|
| **Trigger** | [Action utilisateur + points d'accès] |
| **Confirmation** | [Modal : titre, message, boutons] |
| **Side effect** | [Impacts — côté admin ET/OU client] |
| **Feedback** | [Toast exact, redirection] |
| **Précondition** | [Statut requis, rôle requis] |

## 5. Divergences par rôle

> Présent uniquement si comportements différents par rôle.

| Élément | [Rôle 1] | [Rôle 2] |
|---------|----------|----------|
| [Champ/Action/Accès] | [Comportement] | [Comportement] |

## 6. Workflow / Navigation

> Reconstruction du flux utilisateur.

[Étape 1] → [Étape 2] → [Étape 3]
         ↘ [Branche alternative]

- Redirection 1 : [De → Vers (+ paramètres pré-remplis)]
- Redirection 2 : ...

## 7. Scope

### IN (à implémenter)
- [Élément 1]
- [Élément 2]

### OUT (hors scope)
- [Élément] — Raison : "[dans une autre US / ne pas dev / vu avec X]"

## 8. Règles métier

- [Règle 1]
- [Règle 2]

## 9. Liens Figma

| Contexte | URL | Notes pour l'agent Figma |
|----------|-----|--------------------------|
| [Modal principale] | [URL] | [Ce qu'il faut y chercher] |
| [Modal confirmation] | [URL] | [Bouton X redirige ici] |

## 10. Points d'attention

### Ambiguïtés / Zones grises
- [Point]

### Risques techniques
- [Point]

### Dépendances implicites
- [Point]

## 11. Indices Backend (si HAS_BACKEND = Oui)

> Section produite UNIQUEMENT si HAS_BACKEND = Oui.
> Objectif : fournir des indices exploitables par l'agent-backend-api-extract
> pour cibler les bons endpoints sans exploration manuelle.

| Champ | Valeur |
|-------|--------|
| **Entités métier identifiées** | [Ex: Site, Company, RestockDemand, Challenge] |
| **Opérations attendues** | [Ex: CREATE, UPDATE, LIST, DELETE, GET_BY_ID] |
| **Mots-clés recherche** | [Ex: restock, site, agency, challenge] |
| **Tags Swagger probables** | [Ex: DistributorRestockDemands, Sites, Companies] |
| **URLs probables** | [Ex: /distributor/restock-demands, /sites, /companies] |

### Détail par opération

| Opération | Entité | Contexte US | Filtre suggéré |
|-----------|--------|-------------|----------------|
| [LIST] | [RestockDemand] | [Listing des demandes restock] | `--keyword restock` |
| [CREATE] | [Site] | [Formulaire création site] | `--url /sites` |

### Notes pour l'agent backend
- [Ex: La US mentionne un filtre par statut → vérifier si l'endpoint GET supporte le query param "status"]
- [Ex: Deux flows distincts (constructor/distributor) → possiblement deux groupes d'endpoints]
```

## Règles du format

- Toutes les sections sont présentes, noter "Aucun" ou "N/A" si vide.
- La section 4 s'adapte au type de US détecté en section 1.
- Les liens Figma incluent toujours leur **contexte** (quel bouton/action mène à cette modal).
- Le scoring B/F est extrait tel quel de la US.
- **Images inline** : quand une image apparaît dans la US (ex: après la description d'un bouton trigger), l'analyse de l'image doit être intégrée **directement dans la section concernée** du rapport (ex: dans "Trigger / Point d'entrée", dans "Contenu structuré"), PAS dans une section séparée "Images à analyser". L'image est décrite en contexte, là où elle a du sens.
- **Section 11** : présente UNIQUEMENT si HAS_BACKEND = Oui. L'objectif est de fournir des indices suffisamment précis pour que l'agent-backend-api-extract puisse cibler les bons endpoints en une seule passe (via `--keyword`, `--tag`, ou `--url`).
