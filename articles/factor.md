# factor

``` r

library(cleanser)
```

Cleanser permet de détecter et de recoder automatiquement les variables
factor qui ont une modalité spécifique (par ex oui/non, homme/femme,
etc.). Cette stratégie est plus efficiente qu’une stratégie de recodage
directe des variables sans vérification des modalités préalable. Elle
permet notamment d’éviter la génération de NA pour les cellules qui ont
des typo ou des erreurs de case pour une variable donnée. Il est alors
possible de repérer automatiquement les variables qui montrent ce type
de problème, et même d’extraire les cellules qui n’ont pas les modalités
attendues.

Pour autant, lorsque les données ne sont pas issues d’une DB, on est
souvent confronté à des problèmes de typo -comme c’est le cas par
exemple pour un fichier saisi manuellement dans excel. L’application
stricte de la fonction de détection des variables factor pour une
modalité donnée et sa comparaison aux autres variables de type character
qui étaient attendues avec cette modalité permet la détection de ces
problèmes d’erreur de typo (voir ex ci-dessous). Pour autant, le
recodage n’est pas direct: il faut corriger le fichier source avant de
relancer la procédure, ce qui est fastidieux.

On peut résoudre le problème, en utilisant des drop-down menu dans les
fichier excel: cela contraint les modalités dans une colonne donnée à
celles qui ont été définies dans le drop-down menu. Attention toutefois,
malgré la contrainte excel n’arrive pas à contraindre les problèmes de
case dans une colonne donnée. Par exemple, même si un drop-down menu a
été défini avec les modalités “Oui” et “Non”, on peut retrouver des
modalités “oui”, “non” ou tout autre variation de case. R étant case
sensitive, la variable en question ne sera alors pas considérée comme
une variable factor “Oui”/“Non”, et donc pas recodée.

En fait, il pourrait être intéressant d’extraire les colonnes et les
observations qui sont problématiques…

## Fonction de détection de modalités spécifiques dans un vecteur

L’élément de base de la partie du package dédiée au factor est la
fonction `clr_detect_levels` qui détecte un jeu de modalités données
dans un vecteur. Cette fonction passe par des regex pour généraliser la
recherche aux éventuels problèmes de case. A titre d’exemple, nous
utilisons le vecteur ci-dessous, pour une recherche de modalités
spécifiques `c("non", "oui")`:

``` r

lvl <- c("non", "oui")
vec <- c("Oui", "oui", "Non", "non", "NON", "ouistiti", NA_character_)
vec
#> [1] "Oui"      "oui"      "Non"      "non"      "NON"      "ouistiti" NA
```

### Recherche stricte des modalités (default)

Seules les modalités du vecteur qui sont strictement identiques aux
modalités attendues sont reconnues.

- les éventuelles NA, restent des NA
- les typos “ouistiti” ne sont pas considérées comme répondant à la
  modalité recherchée
- les variation de case (“Oui”, “Non”, “NON”) ne sont pas non-plus
  considérées

C’est bien le comportement souhaité.

``` r

## Default: ignore_case = FALSE
clr_detect_levels(vec, levels =  lvl)
#> [1] FALSE  TRUE FALSE  TRUE FALSE FALSE    NA
```

### Inversion du résultat de la recherche

Les modalités du vecteur ne répondant pas au critère de recherche
peuvent être identifiées en inversant le résultat de la recherche:
argument `negate = TRUE`.

``` r

## negate = TRUE
clr_detect_levels(vec, levels =  lvl, negate = TRUE)
#> [1]  TRUE FALSE  TRUE FALSE  TRUE  TRUE    NA
```

### Prise en compte des problèmes de case

La recherche peut être rendue case insensitive avec l’argument
`ignore_case = TRUE`:

``` r

## ignore_case = TRUE
clr_detect_levels(vec, levels =  lvl, ignore_case = TRUE)
#> [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE    NA
```

### Prise en compte des character spéciaux regex

Le passage par les regex plutôt que la comparaison directe de chaines de
character, introduit une complexité supplémentaire pour la gestion des
character spéciaux dans les regex. La fonction `clr_detect_levels`
échappe les character spéciaux avant de construire la regex…

``` r

## Default: ignore_case = FALSE pour +/-
vec <- c("+", "-", "Non", "non", "NON", "ouistiti", NA_character_)
vec
#> [1] "+"        "-"        "Non"      "non"      "NON"      "ouistiti" NA
clr_detect_levels(vec, levels =  c("-", "+"))
#> [1]  TRUE  TRUE FALSE FALSE FALSE FALSE    NA
```

## Application à la préparation d’un jeu de données

La fonction
[`clr_detect_levels()`](https://acidybee.github.io/cleanser/reference/clr_detect_levels.md)
est ensuite utilisée dans les outils du package pour la détection et le
recodage au sein d’un jeu de données.

### Example dataset

Afin de définir les différents cas de figure que l’on peut rencontrer
pour la préparation des variables factor, nous utilisons le jeu de
données suivant:

``` r

factor_dataset <- data.frame(
  id = 1:4,
  dummy = c(0, 0, 1, 1),
  DB = c("oui", "non", "non", "oui"),
  typo = c("oui", "non", "non", "pui"),
  case = c("OUI", "Non", "non", "oui"),
  sexe = c("F", "H", "F", "H"),
  regex_spec = c("+", "-", "-", "+"),
  DB_w_na = c("oui", "non", "non", NA_character_),
  na_only = rep(NA_character_, times = 4)
)
factor_dataset
#>   id dummy  DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0 oui  oui  OUI    F          +     oui    <NA>
#> 2  2     0 non  non  Non    H          -     non    <NA>
#> 3  3     1 non  non  non    F          -     non    <NA>
#> 4  4     1 oui  pui  oui    H          +    <NA>    <NA>
```

Ce jeu de données permet d’illustrer les solutions du package proposées
pour les problèmes de typo, de case, de changement de libellés, de
modalités correspondant à des character regex spéciaux, ainsi que la
gestion des valeurs manquantes. Le vecteur de modalités recherchées est
`c("non", "oui")`, sauf pour le cas des character spéciaux regex ou le
jeu de modalités recherchées est `c("-", "+")`.

## Check

Dans le cadre de la vérification des données, on veut pouvoir extraire à
la fois les variables qui répondent à la contrainte, mais aussi celles
qui n’y répondent pas. Cette fonction est définie par le préfixe de la
fonction: `keep_` ou `discard`. Pour répondre aux critère tidy, la
fonction prend en entrée un dataset, est retourne en sortie un dataset
avec les colonnes répondant au critère (keep), ou n’y répondant pas
(discard).

### Automated detection of variables with specific levels

Lorsque les données à préparer sont issues d’une DB, la fonction
`keep_col_w_levels` détecte les variables attendues. Sont éliminées les
colonnes pour lesquelles il y a des typo, ou des problèmes de case.

``` r

factor_dataset %>%
  # keep_col_dummy()
  keep_col_w_levels(levels = c("non", "oui"))
#>    DB DB_w_na
#> 1 oui     oui
#> 2 non     non
#> 3 non     non
#> 4 oui    <NA>
```

### Inverted selection

La sélection peut être inversée en utilisant `discard_col_w_levels`, qui
élimine du jeu de données les variables qui répondent au critère, plutôt
que de les conserver.

``` r

factor_dataset %>%
  discard_col_w_levels(levels = c("non", "oui"))
#>   id dummy typo case sexe regex_spec
#> 1  1     0  oui  OUI    F          +
#> 2  2     0  non  Non    H          -
#> 3  3     1  non  non    F          -
#> 4  4     1  pui  oui    H          +
```

En soit l’inversion de la sélection n’est pas directement utile en
pratique pour la préparation des données. On peut l’améliorer en
extrayant les colonnes qui ne répondent pas au critère de `levels` et
sont aussi des character, en utilisant le pipe suivant:

``` r

factor_dataset %>%
  dplyr::select(dplyr::where(is.character)) %>%
  discard_col_w_levels(levels = c("non", "oui"))
#>   typo case sexe regex_spec
#> 1  oui  OUI    F          +
#> 2  non  Non    H          -
#> 3  non  non    F          -
#> 4  pui  oui    H          +
```

Cette méthode reste suboptimale: on préférerait identifier directement
les colonnes susceptibles de contenir des typo ou des problèmes de case,
et même extraire les lignes qui ont ces problèmes…

### Résolution du problème de case

La détection des modalités recherchées peut être rendue case_insensitive
à l’aide de l’argument `ignore_case = TRUE`. La colonne avec des
problèmes de case est alors identifiée en plus de celles qui ont une
case correcte.

``` r

factor_dataset %>%
  keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)
#>    DB case DB_w_na
#> 1 oui  OUI     oui
#> 2 non  Non     non
#> 3 non  non     non
#> 4 oui  oui    <NA>
```

Les colonnes avec problèmes de case peuvent alors être identifiées en
cumulant les étapes `discard_col_w_levels(levels = c("non", "oui"))` et
`keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)`

``` r

factor_dataset %>%
  discard_col_w_levels(levels = c("non", "oui")) %>%
  keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)
#>   case
#> 1  OUI
#> 2  Non
#> 3  non
#> 4  oui
```

Et pour ces variables, il est possible d’extraire les lignes
problèmatiques… il manque quand même un identifiant de ligne pour
extraire directement les observations d’intérêt…

``` r

factor_dataset %>%
  discard_col_w_levels(levels = c("non", "oui")) %>%
  keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE) %>%
  dplyr::filter(dplyr::if_any(.cols = everything(), .fns = \(x) clr_detect_levels(x, levels = c("non", "oui"), negate = TRUE)))
#>   case
#> 1  OUI
#> 2  Non
```

Il peut être ajouté avec un dplyr::bind_cols, à partir d’un identifiant
dans le jeu de données:

``` r

dplyr::bind_cols(
  dplyr::select(factor_dataset, id),
  factor_dataset %>%
    discard_col_w_levels(levels = c("non", "oui")) %>%
    keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)
) %>%
  dplyr::filter(dplyr::if_any(.cols = -id, .fns = \(x) clr_detect_levels(x, levels = c("non", "oui"), negate = TRUE)))
#>   id case
#> 1  1  OUI
#> 2  2  Non
```

C’est réglé en utilisant l’argument `id_cols` pour les fonctions keep &
discard:

``` r

factor_dataset %>%
  discard_col_w_levels(levels = c("non", "oui"), "id") %>%
  keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE, "id")
#>   id case
#> 1  1  OUI
#> 2  2  Non
#> 3  3  non
#> 4  4  oui
```

Il est aussi possible de récupérer uniquement les lignes qui posent
problème:

``` r

factor_dataset %>%
  discard_col_w_levels(levels = c("non", "oui"), "id") %>%
  keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE, "id") %>%
  dplyr::filter(dplyr::if_any(.cols = -"id", .fns = \(x) clr_detect_levels(x, levels = c("non", "oui"), negate = TRUE)))
#>   id case
#> 1  1  OUI
#> 2  2  Non
```

Les opérations précédentes sont regroupées au sein d’une fonction.
Attention: les colonnes d’identification sont appelées par leur nom…La
NSE ne fonctionne pas.

``` r

factor_dataset %>%
  # keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE, id)
  clr_extract_mismatch_w_levels_case(levels = c("non", "oui"), "id")
#>   id case
#> 1  1  OUI
#> 2  2  Non
## La NSE ne fonctionne pas:
# factor_dataset %>%
#   clr_extract_mismatch_w_levels_case(levels = c("non", "oui"), id_cols = c(id, sexe))
```

### Résolution des problèmes de typo

Il est possible de généraliser cette stratégie aux erreurs de typo:

``` r

factor_dataset %>%
  discard_col_w_levels(levels = c("non", "oui"), "id") %>%
  discard_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE, "id") %>%
  keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE, "id", fun = "any") %>%
  dplyr::filter(dplyr::if_any(.cols = -"id", .fns = \(x) clr_detect_levels(x, levels = c("non", "oui"), negate = TRUE)))
#>   id typo
#> 1  4  pui
```

…et de les regrouper au sein d’une fonction:

``` r

factor_dataset %>%
  clr_extract_mismatch_w_levels_typo(levels = c("non", "oui"), "id")
#>   id typo
#> 1  4  pui
```

## Recode

Une fois les typo corrigées, les données peuvent être recodées
automatiquement. A noter que les soucis de case peuvent être recodés
sans vraiment avoir besoin de les corriger, ce qui n’est pas
systématiquement vrai pour les problèmes de typo…

### Strict à partir des levels attendus

``` r

factor_dataset %>%
  recode_col_w_levels(levels = c("non", "oui"), ignore_case = FALSE)
#>   id dummy  DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0 oui  oui  OUI    F          +     oui    <NA>
#> 2  2     0 non  non  Non    H          -     non    <NA>
#> 3  3     1 non  non  non    F          -     non    <NA>
#> 4  4     1 oui  pui  oui    H          +    <NA>    <NA>
```

### Avec correction automatique des problèmes de case

La fonction est généralisée à la correction des problèmes de case en
suivant les étapes suivantes:

``` r

case <- c("OUI", "Non", "non", "oui")
case
#> [1] "OUI" "Non" "non" "oui"
lvl <- c("non", "oui")
# lvl_regex <- paste0("(?i)^(", paste(stringa::stra_transform_to_regex_pattern(lvl), collapse = "|"), ")$")
lvl_regex <- paste0("(?i)^(", paste(stringr::str_escape(lvl), collapse = "|"), ")$")
```

Définition d’une fonction qui corrige la case pour un level unique:

``` r

## correction pour une modalité donnée:
case %>%
  cure_single_level_case("oui")
#> [1] "oui" "Non" "non" "oui"
```

Composition manuelle de ces corrections individuelles:

``` r

## Etapes manuelles
case %>%
  cure_single_level_case("oui") %>%
  cure_single_level_case("non")
#> [1] "oui" "non" "non" "oui"
```

Automatisation avec
[`purrr::reduce`](https://purrr.tidyverse.org/reference/reduce.html):
correction séquentielle de tous les niveaux:

``` r

## Automatisation avec purrr::reduce: correction séquentielle de tous les niveaux
purrr::reduce(lvl, .f = \(x, y) cure_single_level_case(string = x, single_level = y), .init = case)
#> [1] "oui" "non" "non" "oui"
```

Création d’une fonction de correction séquentielle de tous les niveaux
qui prend le dataset en entrée:

``` r

# Application au recodage des jeux de données: OK
factor_dataset %>%
  cure_col_w_levels_case(levels = c("non", "oui"))
#>   id dummy  DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0 oui  oui  oui    F          +     oui    <NA>
#> 2  2     0 non  non  non    H          -     non    <NA>
#> 3  3     1 non  non  non    F          -     non    <NA>
#> 4  4     1 oui  pui  oui    H          +    <NA>    <NA>
```

Recodage auto qui prend en compte les problèmes de case: application de
la correction de la case des levels avant le recodage des variables avec
l’argument `ignore_case = TRUE`:

``` r

factor_dataset %>%
  recode_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)
#>   id dummy  DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0 oui  oui  oui    F          +     oui    <NA>
#> 2  2     0 non  non  non    H          -     non    <NA>
#> 3  3     1 non  non  non    F          -     non    <NA>
#> 4  4     1 oui  pui  oui    H          +    <NA>    <NA>
```

Les labels peuvent aussi être modifiés par la fonction via l’argument
`labels` utilsé comme dans la fonction `factor`:

``` r

factor_dataset %>%
  recode_col_w_levels(levels = c("non", "oui"), labels = c("N", "O"), ignore_case = TRUE)
#>   id dummy DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0  O  oui    O    F          +       O    <NA>
#> 2  2     0  N  non    N    H          -       N    <NA>
#> 3  3     1  N  non    N    F          -       N    <NA>
#> 4  4     1  O  pui    O    H          +    <NA>    <NA>
```
