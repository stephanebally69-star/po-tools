# Patterns d'analyse — Calibration agent

Patterns extraits de l'analyse manuelle de 6 User Stories réelles couvrant les principaux types de US frontend.

## Table des matières
1. [Méthode d'analyse](#méthode-danalyse)
2. [Patterns par catégorie](#patterns-par-catégorie)
3. [Adaptation par type de US](#adaptation-par-type-de-us)
4. [Exemples de référence condensés](#exemples-de-référence-condensés)

---

## Méthode d'analyse

Lire la US comme un contrat juridique. Chaque mot porte une intention d'implémentation.

### Séquence invariante

1. **Titre** → détermine la nature (création, adaptation, consultation, listing, action)
2. **Rôle** → "En tant que..." + exclusions éventuelles ("sauf les chefs de chantier")
3. **Objet/Intent** → ce que l'utilisateur veut faire → détermine le type de contexte (formulaire, page, onglet, action)
4. **Trigger** → d'où et comment l'action est déclenchée
5. **Contenu** → analyse adaptée au type (voir section adaptation)
6. **Workflow** → reconstruction du flux complet
7. **Scope** → frontières IN/OUT
8. **Points d'attention** → ambiguïtés, risques, dépendances

---

## Patterns par catégorie

### Identification (premier réflexe)

**P1 — Rôle et exclusions**
Toujours en première phrase. Chercher : "En tant que [rôle]", "sauf [exclusion]". Implications sur permissions, visibilité, accès.

**P11 — Contexte/Intent**
Au-delà du rôle, extraire l'objet de l'action. "Créer un site" → contexte formulaire. "Visualiser le détail" → contexte consultation. "Annuler une demande" → contexte action simple.

**P20 — Nature via le titre**
Le titre révèle s'il s'agit d'une création, adaptation, consultation, listing ou action. "Adapter la demande" → on part de l'existant. "Créer un site" → on crée from scratch.

### Trigger / Point d'entrée

**P2 — Localisation du trigger**
Toujours chercher D'OÙ l'utilisateur arrive. Bouton ? Dropdown ? Card cliquable ? Icône ? Identifier la page/composant source.

**P13 — Pattern existant ("comme c'est déjà le cas")**
Phrases clés : "comme c'est déjà le cas pour", "même que", "déjà développé", "déjà dev". → Il existe un pattern dans le code à réutiliser. TOUJOURS signaler dans le rapport.

**P35 — Points d'accès multiples**
Une même action/page peut être accessible depuis plusieurs endroits. "Depuis le listing via l'icône... depuis la page détail via le bouton..." → lister TOUS les points d'accès.

**P27 — Chaînes de triggers**
"Une fois que X est sélectionné → on affiche Y". "Quand l'admin confirme → cela ouvre Z". Mapper chaque paire trigger → résultat pour reconstruire le workflow.

### Contenu / Champs

**P3 — Triplet systématique pour chaque champ**
Pour chaque champ, extraire : Type (Dropdown/Input/Switch), Cardinalité (single/multi), Obligatoire (oui/non). Plus si disponible : défaut, limites de caractères, mode (editable/readonly).

**P19 — États conditionnels des champs**
Un même champ peut être editable pour un rôle et readonly pour un autre. "Par défaut en mode lecture" → readonly. Mapper : champ × rôle → état.

**P23 — Interdépendances entre champs**
"Ce champ est interdépendant avec les valeurs sélectionnées" → cascading dropdown, filtrage dynamique. Signaler la dépendance parent → enfant.

**P18 — Formulaires dynamiques**
"Ajouter un autre pays" / "Ajouter une autre adresse" → blocs de champs qui se dupliquent dynamiquement. Identifier quels champs sont dans le bloc répétable.

**P31 — Éclatement de valeurs**
"Modifier la valeur 'Bennes' par → Échange de benne(s) / Enlèvement de benne(s)" → une valeur devient deux, chacune avec son propre sous-formulaire.

**P32 — Sous-formulaires conditionnels par valeur**
"Si 2 bennes alors champ Catégorie benne 2" → champs qui apparaissent/disparaissent selon la valeur d'un autre champ.

**P37 — Informations ordonnées**
"Avec les infos suivantes dans cet ordre" → l'ordre d'affichage est spécifié. Le préserver dans le rapport.

**P39 — Valeurs dérivées**
"Type de flux : en fonction de la company" → valeur calculée depuis une autre entité, pas saisie par l'utilisateur.

**P40 — Valeurs de fallback**
"Date de validation si renseignée sinon '-'" → affichage par défaut quand donnée null.

**P44 — Compteurs/Agrégats**
"Pour chaque statut on affiche le nombre de demandes" → données agrégées à afficher.

**P46 — Cards vs Rows**
"Listing de cards" ≠ "tableau avec lignes". Distinction importante pour le composant.

### Scope / Règles

**P7 — Frontières de scope**
"Le reste est dans une autre US" / "Le détail de la fiche est géré dans une autre US" → OUT. "Gérer juste l'affichage du bouton" → IN limité.

**P25 — Contradictions / Overrides explicites**
"Ne pas dev le bouton X > Vu avec Clément, trop complexe" → exclusion explicite avec raison. Haute priorité dans le rapport. La maquette peut montrer l'élément mais la US dit de ne pas le faire.

**P49 — Exclusion de feature**
"On ne gère pas le 'Trier par'" → feature visible sur maquette mais hors scope.

**P15 — Chaque mot compte**
"uniquement", "seulement", "sauf", "par défaut", "tous les autres" → qualificatifs qui portent une logique d'implémentation.

**P17 — Règles métier transverses**
"Le code CAB-LOOP doit être créé automatiquement" → règle qui dépasse le UI, touche backend/intégration. Isoler dans section dédiée.

**P28 — Règles de persistance**
"Cela ne vient pas écraser en base, simplement ça enregistre pour la demande seulement" → scope de persistance des modifications.

**P38 — Actions conditionnelles rôle × statut**
Boutons visibles seulement si : rôle = admin ET statut = "En attente". Matrice bidimensionnelle.

**P47 — Action conditionnelle par item**
"Bouton 'Confirmer' uniquement pour statut 'En cours'" → action par item dans un listing.

**P54 — Préconditions de statut**
"Seules les demandes au statut X peuvent être annulées" → précondition pour qu'une action soit disponible.

### Visuel / Collaboration

**P4 — Images dans la US (inline)**
Quand "Image" apparaît seul ou qu'une image est inline, TOUJOURS l'analyser. C'est souvent un composant UI, une modal de confirmation, ou un élément visuel non décrit en texte. L'analyse de l'image doit être intégrée **directement dans la section concernée** du rapport (trigger, contenu, etc.), PAS dans une section séparée.

**P5 — Cross-référencement Figma**
Quand un bouton redirige vers un lien Figma, c'est une connexion entre deux écrans. Reporter le lien AVEC son contexte (quel bouton, quelle action).

**P6 — Marqueurs pour l'agent Figma**
L'output de cet agent doit contenir des marqueurs que l'agent Figma exploitera. Liens Figma + contexte de navigation.

**P26 — Disposition = Figma, Logique = US**
"Adapter la disposition comme sur la maquette" → le layout suit Figma, la logique suit la US. Dual sourcing.

**P29 — Image comme fallback maquette**
"Les maquettes n'étant pas à jour, X avait fait ça : Image" → l'image inline dans la US remplace la maquette officielle.

**P30 — Modifications de wording**
Changements de texte explicites → capturer le texte exact.

### Dynamique / Workflow

**P12 — Divergence multi-rôles**
Deux maquettes (Client/Admin) → deux implémentations. Tracker tout au long quel élément appartient à quel rôle.

**P14 — Reconstruction de workflow**
US complexe → reconstruire le flux complet :
- Admin : Étape 1 → Étape 2 → Redirect
- User : Directement Étape 2 → Redirect

**P22 — Branches conditionnelles**
"Si l'utilisateur choisit projet" → flux A. "Si agence" → flux B. Mapper chaque branche.

**P36 — Affichage conditionnel par statut**
Stepper, badges, dates qui changent visuellement selon l'état des données.

**P41 — Découpage sémantique de page**
Pages complexes découpées en blocs logiques. Analyser section par section.

**P42 — Création dans une page existante**
"Gérer la création de l'onglet" → ajout à une page existante, pas nouvelle page.

**P48 — Modal de confirmation**
"Êtes-vous sûr ? Cette action est irréversible" → pattern standard avec Annuler/Confirmer.

**P50 — Pattern action simple**
Trigger → Confirmation → Side effect → Feedback. Flux minimal.

**P52 — Side effects / impacts croisés**
"Supprime la card côté Admin ET client" → l'action impacte plusieurs vues/rôles.

**P53 — Pattern Toast/Feedback**
"Toast 'La demande a bien été annulée'" → message exact de feedback utilisateur.

### Backend / API (si HAS_BACKEND = Oui)

**P55 — Entités métier dans la US**
Identifier chaque nom d'entité métier mentionné dans la US : "demande", "site", "agence", "company", "pays", "challenge", "opération", "parc", "palette", etc. Ces noms correspondent aux domaines du backend (Features/).

**P56 — Opérations CRUD implicites**
Déduire les opérations backend depuis la nature de la US :
- "Créer un site" → CREATE (POST)
- "Modifier la demande" / "Adapter" → UPDATE (PUT)
- "Visualiser le détail" / "Consulter" → GET_BY_ID (GET /{id})
- "Listing des demandes" / "Afficher la liste" → LIST (GET)
- "Supprimer" / "Annuler" → DELETE ou action POST
- "Filtrer par statut" → LIST avec query params

**P57 — Mots-clés de recherche backend**
Transformer les entités métier en mots-clés de recherche pour le backend :
- "demande de collecte" → keyword: "demand"
- "demande de restock" → keyword: "restock"
- "site projet" / "site agence" → keyword: "site"
- "challenge" → keyword: "challenge"
- "gestion de parcs" → keyword: "park"
Convention : utiliser le nom anglais singulier en minuscules.

**P58 — Flow constructor vs distributor**
Si la US mentionne des rôles constructor OU distributor, cela implique des groupes d'endpoints séparés.
"constructeur" → URL probable : /constructor/... ou /demands/constructor
"distributeur" → URL probable : /distributor/... ou /demands/distributor
Toujours identifier le flow pour cibler le bon groupe d'endpoints.

**P59 — Scoring B > 0 = indicateur backend**
Si le scoring de la US indique B: X avec X > 0, cela confirme qu'il y a du travail backend associé.
Mentionner ce score dans la section 3 (Flags). La section 11 n'est produite que si `--backend` est passé en CLI.

---

## Adaptation par type de US

### Création (formulaire/modal)
- Analyser **champ par champ** avec le triplet complet
- Détecter les blocs dynamiques (ajout/suppression)
- Mapper les boutons et leurs redirections
- Profondeur : **maximale**

### Adaptation d'existant
- Identifier **le point de départ** (quel écran existant on modifie)
- Lister les **changements** vs ce qui reste identique
- Détecter les branches conditionnelles (si projet / si agence)
- Signaler les contradictions/overrides
- Profondeur : **maximale** (souvent plus complexe que la création)

### Consultation/Détail
- Analyser **bloc par bloc** (informations affichées)
- Mapper la matrice accès rôle × restrictions
- Actions conditionnelles par rôle × statut
- Profondeur : **moyenne** (moins de logique de saisie)

### Listing/Dashboard
- Découpage **section par section**
- Filtres, pagination, type d'affichage (cards/rows)
- Actions conditionnelles par item
- Profondeur : **moyenne à haute** selon la complexité des filtres/actions

### Action simple
- Flux minimal : trigger → confirmation → side effect → feedback
- Préconditions et impacts croisés
- Profondeur : **légère** (US concise = analyse concise)

---

## Exemples de référence condensés

### Ex.1 — Formulaire modal (B:6, F:6)
**US** : Admin assigne des pays à une company. Modal avec dropdowns (pays single, recycleur multi, contenants multi avec "Autre" par défaut non modifiable). Bouton "Ajouter un autre pays". Deux boutons de sortie dont un vers une modal de confirmation avec 3 boutons.
**Points clés** : Formulaire dynamique, valeur par défaut verrouillée, cross-ref Figma entre modales, scope limité ("gérer juste l'affichage du bouton").

### Ex.2 — Multi-étapes multi-rôles (B:12, F:12)
**US** : User (sauf chefs de chantier) crée un site projet. Modal Admin étape 1 + formulaire commun étape 2. Champs conditionnels par rôle (pays readonly pour certains). Bouton "Ajouter une autre adresse" (blocs dynamiques).
**Points clés** : Deux flux distincts (Admin vs User), "comme c'est déjà le cas pour" → pattern existant, champs readonly conditionnels, stepper admin uniquement.

### Ex.3 — Adaptation complexe (B:18, F:24)
**US** : Adapter la demande de collecte constructeur. Deux branches (projet/agence). Interdépendances champs, sous-formulaires conditionnels (échange/enlèvement de bennes), wording modifié, valeur éclatée.
**Points clés** : Multi-points numérotés, "même modal que déjà dev", "Ne pas dev le bouton > Vu avec X", image fallback quand maquette obsolète, modification ne modifie pas les données en base.

### Ex.4 — Page détail (consultation)
**US** : Visualiser détail demande restock. Stepper statut conditionnel (bleu/gris). Bloc infos ordonnées. Boutons admin conditionnels par statut (En attente → Annuler/Valider, Confirmée → Marquer livrée).
**Points clés** : Matrice accès rôle × restrictions, valeurs dérivées, fallback "-", images à analyser pour les boutons admin.

### Ex.5 — Listing/Dashboard + onglet
**US** : Créer onglet suivi des demandes. Vue globale (stepper + compteurs) + listing filtré (search, datepicker, tabs statut) + cards paginées cliquables.
**Points clés** : Création dans page existante, "On ne gère pas le Trier par", cards ≠ rows, bouton conditionnel par item par statut, modal confirmation irréversible.

### Ex.6 — Action simple (annulation)
**US** : Admin annule une demande. 2 points d'accès (icône listing + bouton détail). Modal confirmation. Toast feedback. Suppression côté admin ET client.
**Points clés** : Points d'accès multiples, précondition statut, side effects croisés, images à analyser pour localiser les triggers.
