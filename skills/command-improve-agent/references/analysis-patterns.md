# Analysis Patterns

Guide pour analyser le contexte de conversation et extraire des améliorations pertinentes.

## Détecter les agents utilisés

Chercher dans le contexte de conversation :
- Invocations `Skill(skill: "agent-*")` dans les tool calls
- Contenu SKILL.md chargé via balises `<command-name>`
- Mentions explicites d'un agent par l'utilisateur

## Détecter les erreurs récurrentes

### Signaux forts (à capturer)

- **Correction explicite** : L'utilisateur dit "non", "pas comme ça", "plutôt X", "je t'ai déjà dit"
- **Erreur répétée** : L'agent refait une erreur déjà corrigée plus tôt dans la session
- **Échecs en boucle** : Build, lint ou format qui échouent plusieurs fois sur le même type de problème
- **Instruction ignorée** : L'utilisateur reformule ou répète une consigne que l'agent n'a pas suivie
- **Retravail systématique** : L'utilisateur doit repasser sur chaque sortie de l'agent pour corriger le même type d'erreur

### Signaux faibles (à ignorer)

- Typo ou mauvais import ponctuel
- Erreur causée par un contexte manquant (l'agent ne pouvait pas savoir)
- Problème spécifique à un fichier/cas unique sans pattern sous-jacent
- Erreur que l'agent a corrigée lui-même sans intervention utilisateur

## Analyse cause racine (5 Pourquoi)

L'objectif n'est PAS de reformuler le symptôme en version générique. L'objectif est d'identifier la **défaillance structurelle** dans l'agent qui a permis l'erreur.

Pour chaque erreur détectée, appliquer itérativement la question "Pourquoi ?" jusqu'à atteindre une règle manquante, ambiguë, ou mal placée dans le workflow de l'agent :

```
Exemple :
1. Pourquoi l'agent n'a pas écrit de test ? → Les tests existants passaient, il a considéré le travail terminé.
2. Pourquoi a-t-il considéré le travail terminé ? → Sa règle dit "update existing tests" mais aucun test existant ne couvrait le paramètre modifié.
3. Pourquoi n'a-t-il pas détecté l'absence de couverture ? → Son workflow ne contient aucune étape de vérification de couverture entre l'implémentation et le run de tests.
4. → CAUSE RACINE : le workflow de l'agent ne distingue pas "tests passent" de "changement couvert par un test".
5. → AMÉLIORATION : ajouter dans le workflow une étape qui vérifie qu'un test exerce spécifiquement le comportement modifié avant de lancer le run de tests.
```

**Critères de profondeur atteinte** (arrêter les "Pourquoi ?" quand) :
- On pointe un endroit PRÉCIS dans la structure de l'agent (étape du workflow, section du SKILL.md, fichier reference)
- L'amélioration corrige CET endroit, pas le symptôme de surface
- UNE seule amélioration couvre TOUS les cas similaires futurs (pas seulement le cas observé)

**Anti-pattern** : Reformuler le symptôme spécifique en version légèrement plus abstraite. Cela produit des dizaines de règles alors qu'une seule à la source suffirait.

| Mauvais (symptôme reformulé) | Bon (cause racine) |
|------------------------------|-------------------|
| "Quand un paramètre change de type, ajouter un test" | "Le workflow ne vérifie pas la couverture de test → ajouter une étape de vérification" |
| "Toujours gérer les états de chargement" | "Le checklist de validation du hook ne mentionne pas les états → l'ajouter au checklist" |
| "Ne jamais utiliser de callbacks inline" | "La section Clean Code Rules ne couvre pas les patterns JSX → l'étendre" |

**Test de validité** :
- L'amélioration mentionne un nom de fichier, composant ou variable spécifique à la session → trop spécifique, reformuler.
- L'amélioration décrit QUOI ne pas faire sans pointer OÙ dans l'agent le corriger → trop superficiel, creuser plus.

## Qualité des améliorations

Chaque amélioration doit passer ces 3 critères :

1. **Actionnable** — L'agent peut la suivre sans ambiguïté lors de sa prochaine session
2. **Concise** — Une à deux phrases maximum
3. **Vérifiable** — On peut constater dans le code produit si elle est respectée ou non

Si une amélioration ne passe pas les 3 critères, la reformuler ou l'abandonner.
