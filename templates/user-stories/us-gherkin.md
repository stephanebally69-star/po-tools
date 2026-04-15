# User Story — [Titre]

## Informations
- **ID** : 
- **Epic / Feature** : 
- **Sprint** : 
- **Priorité** : 
- **Estimation** : 

## Description

**En tant que** [type d'utilisateur],
**je veux** [action / fonctionnalité],
**afin de** [bénéfice / valeur métier].

## Contexte

_Description du contexte métier et technique._

## Scénarios (Gherkin)

### Scénario 1 — Cas nominal : [titre]

```gherkin
Fonctionnalité: [Nom de la fonctionnalité]

  Scénario: [Description du cas nominal]
    Etant donné [contexte initial]
    Et [autre condition]
    Quand [action de l'utilisateur]
    Alors [résultat attendu]
    Et [autre vérification]
```

### Scénario 2 — Cas alternatif : [titre]

```gherkin
  Scénario: [Description du cas alternatif]
    Etant donné [contexte initial]
    Quand [action différente]
    Alors [résultat attendu]
```

### Scénario 3 — Cas d'erreur : [titre]

```gherkin
  Scénario: [Description du cas d'erreur]
    Etant donné [contexte invalide]
    Quand [action de l'utilisateur]
    Alors [message d'erreur attendu]
    Et [état du système après erreur]
```

### Scénario Outline — Jeux de données

```gherkin
  Plan du scénario: [Description paramétrique]
    Etant donné [contexte avec <paramètre>]
    Quand [action avec <valeur>]
    Alors [résultat avec <attendu>]

    Exemples:
      | paramètre | valeur | attendu |
      | valeur1   | x      | ok      |
      | valeur2   | y      | ko      |
```

## Maquettes / Wireframes

_Liens vers les maquettes._

## Dépendances

- [ ] US liées
- [ ] API / services externes

## Definition of Done

- [ ] Code développé et revu
- [ ] Tests BDD implémentés et passants
- [ ] Recette PO validée
