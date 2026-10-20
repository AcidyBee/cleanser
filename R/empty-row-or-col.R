## ****************************************************************************
## ****************************************************************************
## Fonction intervenant sur les éléments vides d'un jeu de données: lignes & colonnes
## ****************************************************************************
## ****************************************************************************

## Anciennement la fonction s'appelait is_empty(), mais is_empty existe déjà dans rlang,
## et ici on teste plutôt s'i on'il n'y a que des NA (d'où le chgt de nom)
#' Check if a vector is only NA elements
#'
#' Check if a vector is only NA elements. This function has 2 direct applications on data structures in the package:
#' 1. spot empty columns using data %>% purrr::keep(\(x) is_only_na(x)) %>% names()
#' 1.b it could be used in function `discard_empty_col`, even though it is not the case yet
#' 2. get an accurate result when spoting col types, like for instance in the `keep_col_numeric` function:
#'   columns with only NA will otherwise return o positive result...
#' @param x a vector of any type
#'
#' @returns a logical indicating if there is only NA in the input vector.
#' @export
#'
#' @examples
#' c(1, 7, NA_real_) %>%
#'   is_only_na()
#' c(NA_real_, NA_real_, NA_real_) %>%
#'   is_only_na()
#' data.frame(
#'  num = c(1, 2),
#'  char = c("a", NA_character_),
#'  na_col = rep(NA_real_, times = 2)
#' ) %>%
#'  purrr::keep(\(x) is_only_na(x)) %>%
#'  names()
is_only_na <- function(x) {
  sum(is.na(x)) == length(x)
  ## alternative rlang ne fonctionne pas pour une colonne de dataframe qui a une longueur donnee
  ## length(x) == 0
  ## variante naniar
  # all(is.na(x))
}
## il y a une fonction du package naniar qui fait ça: naniar::all_na()


## ****************************************************************************
## Colonnes
## ----------------------------------------------------------------------------

## ****************************************************************************
## Elimination des colonnes vides d'un df
## i.e. les colonnes contenant autant de NA
## que le jeu de données ne contient de lignes
## Cette fonction est extraite de utils-recode.R
#' Discard empty columns
#'
#' Discard empty columns
#' @param data A dataset where empty columns are to be discarded
#'
#' @returns a data frame with the same number of rows as the imput data, but without the empty columns that were discarded.
# #' @importFrom dplyr select where
#' @export
#'
#' @examples
#' \dontrun{
#' data_D_raw %>%
#'   discard_empty_col()
#' }
discard_empty_col <- function(data) {
  data %>%
    dplyr::select(dplyr::where(
      \(x) sum(is.na(x)) != NROW(data)
    ))
}
# ## Colonnes conservées: OK
# test <- discard_empty_col(df_raw)
# ## colonnes éliminées: OK
# test_comp <- df_raw[, !(names(df_raw) %in% names(test))]

#' Keep empty columns
#'
#' Keep empty columns
#' @param data A dataset where empty columns are to be extracted
#'
#' @returns a data frame with the same number of rows as the imput data, but keeping only the empty columns.
# #' @importFrom dplyr select where
#' @export
#'
#' @examples
#' \dontrun{
#' data_D_raw %>%
#'   keep_empty_col()
#' }
keep_empty_col <- function(data) {
  data %>%
    dplyr::select(dplyr::where(
      \(x) sum(is.na(x)) == NROW(data)
    ))
}


## ****************************************************************************
## Cette fonction s'appelle maintenant is_only_na()...
## mais les applications à la détectioin des colonnes vides sont tjs d'actualité...
## Si on veut pouvoir vérifier les colonnes rejetées
## aussi bien que de sélectionner uniquement les colonnes conservées
## on peut passer par keep et discard,
## avec une helper function qui détecte les colonnes vides
## la fonction détecte si il y a autant de NA que d'éléments dans un vecteur
# is_empty <- function(x) {
#   sum(is.na(x)) == length(x)
# }
# c(NA, NA, NA, 5) %>% is_empty
# purrr::keep(df_raw, is_empty)
# df_raw_col <- df_raw %>%
#   purrr::discard(is_empty)

## Utilisation:
## 1. Détection des colonnes vides: seul le nom est utile
## purrr::keep(df_raw, is_empty) %>% names()
## 2. Elimination des colonnes vides: 2 méthodes
## soit df_clean <- df_raw %>% purrr::discard(is_empty)
## soit df_clean <- df_raw %>% discard_empty_col()


## ****************************************************************************
## Lignes
## ----------------------------------------------------------------------------

## ****************************************************************************
## Elimination des lignes vides d'un df
## i.e. les lignes qui ne contiennent rien d'autre que des NA
## que le jeu de données ne contient de lignes

## Détecte les lignes vides d'un df
# df_raw_col %>%
#   mutate(across(everything(), as.character)) %>%
#                 rowwise() %>%
#   mutate(is_empty_row = sum(is.na(
#     c_across(everything())
#   )) == NCOL(df_raw_col)) %>%
#   select(NOM, is_empty_row)
## maj 2022-09-20: fonction généralisée...
# is_empty_row <- function(data) {
#   data %>%
#     # le compte des NA par ligne ne semble fonctionner que
#     # si toutes les colonnes ont le même type
#     mutate(across(everything(), as.character)) %>%
#     rowwise() %>%
#     mutate(empty_row = sum(is.na(
#       c_across(everything())
#     )) == NCOL(data)) %>%
#     pull(empty_row)
# }
# is_empty_row(df_raw_col) %>% sum()

## Généralisation pour voir si un groupe de colonnes est totalement vide:
## fonctionne avec les {{...
# extraction des lignes pour lesquelles toutes les scores sont NA
## généralisation de la fonction pour ne vérifier qu'un subset de colonnes d'intérêt...
## le défaut .cols = everything(), permet de vérifier les lignes vides pour tout le df...
#' Spot empty rows
#'
#' Spot empty rows in a dataset. The default spot empty rows for the whole datasets
#' @param data A dataset where empty rows are to be identified
#' @inheritParams dplyr::across
#'
#' @returns a data logical vector with the same number of rows as the imput data.
# #' @importFrom dplyr everything select mutate across rowwise c_across pull .data
#' @export
#'
#' @examples
#' data <- data.frame(
#'   id = 1:4,
#'   a = c(1, 2, NA_real_, 4),
#'   b = c("a", "b", NA_character_, "d")
#'   )
#' # is there an empty row for the whole data
#' is_empty_row(data)
#' # discard empty row for the whole data
#' data[!is_empty_row(data), ]
#' # is there an empty row for a subset of columns a & b
#' is_empty_row(data, .cols = c(a, b))
#' # keep empty rows for a subset of columns a & b
#' data[is_empty_row(data, .cols = c(a, b)), ]
#' # keep only the non-empty rows
#' data[!is_empty_row(data, .cols = c(a, b)), ]
is_empty_row <- function(data, .cols = dplyr::everything()) {
  length_considered <- data %>%
    dplyr::select({{ .cols }}) %>%
    NCOL()
  data %>%
    # le compte des NA par ligne ne semble fonctionner que
    # si toutes les colonnes ont le même type
    dplyr::mutate(dplyr::across(.cols = {{ .cols }}, as.character)) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(empty_row = sum(is.na(
      dplyr::c_across(cols = {{ .cols }})
    )) == length_considered) %>%
    dplyr::pull(.data$empty_row)
}

# test <- df_raw_col %>%
#   filter(!is_empty_row(.))
## ou pour les identifier
# test <- df_raw_col %>%
#   filter(is_empty_row(.))
#
#' Discard empty rows
#'
#' Discard empty rows for a subset of columns which defaults to everything() (i.e. the whole dataset);
#' but which can be restricted to a subset of columns.
#' @inheritParams is_empty_row
#'
#' @returns a data frame with the same number of columns as the imput data, but without the empty rows that were discarded.
# #' @importFrom dplyr everything
#' @export
#'
#' @examples
#' data <- data.frame(
#'   id = 1:4,
#'   a = c(1, 2, NA_real_, 4),
#'   b = c("a", "b", NA_character_, "d")
#'   )
#' # discard empty row for the whole data
#' discard_empty_row(data)
#' # discard empty row for a subset of columns a & b
#' discard_empty_row(data, .cols = c(a, b))
discard_empty_row <- function(data, .cols = dplyr::everything()) {
  data[!is_empty_row(data, {{ .cols }}), ]
  # filter(data, !is_empty_row(.))
}
# test <- discard_empty_row(df_raw_col)

# # pour un vecteur peut importe le type des élément,
# # le comptage des NA peut se faire sans pb
# # ce n'est pas vrai pour les colonnes d'un df
# test <- c(3, NA, 5, "4")
# sum(is.na(test))

## Utilisation:
## 1. Détection des lignes vides: ajout d'un identifiant de ligne
# df_raw %>%
#   mutate(row_id = row_number()) %>% # identifiant de ligne
#   filter(is_empty_row(df_raw)) %>%
#   select(row_id, 1:7)
## 2. Elimination des lignes vides: 2 méthodes
## df_clean <- df_raw %>% discard_empty_row()
## df_clean <- df_raw %>% filter(!is_empty_row(.))

#' Keep empty rows
#'
#' Keep empty rows for a subset of columns which defaults to everything() (i.e. the whole dataset);
#' but which can be restricted to a subset of columns.
#' @inheritParams is_empty_row
#'
#' @returns a data frame with the same number of columns as the imput data, but keeping only the empty rows that were spoted.
# #' @importFrom dplyr everything
#' @export
#'
#' @examples
#' data <- data.frame(
#'   id = 1:4,
#'   a = c(1, 2, NA_real_, 4),
#'   b = c("a", "b", NA_character_, "d")
#'   )
#' # keep empty row for the whole data
#' keep_empty_row(data)
#' # keep empty row for a subset of columns a & b
#' keep_empty_row(data, .cols = c(a, b))
keep_empty_row <- function(data, .cols = dplyr::everything()) {
  data[is_empty_row(data, {{ .cols }}), ]
}


# ## ****************************************************************************
# ## Elimination séquentielle des colonnes vides et des lignes vides
# df_clean <- df_raw %>%
#   discard_empty_col() %>%
#   discard_empty_row()
