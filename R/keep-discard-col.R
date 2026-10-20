## ****************************************************************************
## ****************************************************************************
## Fonction keep/discard de colonnes avec propriétés spécifiques
## - numeric
## - instant
## - col with specific levels for factor
## - dummy
## ****************************************************************************
## ****************************************************************************

## ****************************************************************************
## numeric
## ----------------------------------------------------------------------------

## - Fonctions qui réalisent la détection des col de type numeric
## - Fonctions qui réalisent le recodage auto de toutes les col qui sont de type numeric
## pour détecter toutes les variables qui sont de type numeric
## il suffit d'appliquer la fonction suivante
#' Keep columns with a strict numeric format
#'
#' Keep columns with a strict numeric format
#' @param data entry dataset
#'
#' @returns A selection of columns from the input dataset that have a strict numeric format, as intended in `has_strict_numeric_format()`.
# #' @importFrom purrr set_names map_lgl keep
# #' @importFrom lubridate is.instant
#' @export
#'
#' @examples
#' # keep only numeric columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2),
#'  date = lubridate::make_date(year = c(2019L, 2021L))
#' ) %>%
#'  keep_col_numeric()
keep_col_numeric <- function(data) {
  names(data) %>%
    purrr::set_names() %>%
    purrr::map_lgl(~(
      (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
        # (all(has_strict_numeric_format(data[[.x]]), na.rm = TRUE))) )%>% ## & elle doit contenir uniquement les niveaux attendus
        (all(has_strict_numeric_format(data[[.x]]), na.rm = TRUE) & !lubridate::is.instant(.x) )) ) %>% ## on veut des éléments tous numeric + la colonne n'est pas déjà de type "instant"
    purrr::keep(.p = ~.x == TRUE)
}
## maj 2023-06-21: les colonnes numériques qui doivent être recodées automatiquement ne doivent pas être du type instant

#' Discard columns with a strict numeric format
#'
#' Discard columns with a strict numeric format
#' @param data input dataset
#'
#' @returns A selection of columns from the input dataset that have a strict numeric format, as intended in `has_strict_numeric_format()`.
# #' @importFrom purrr set_names map_lgl discard
# #' @importFrom lubridate is.instant
#' @export
#'
#' @examples
#' # discard only numeric columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2),
#'  date = lubridate::make_date(year = c(2019L, 2021L))
#' ) %>%
#'  discard_col_numeric()
discard_col_numeric <- function(data) {
  names(data) %>%
    purrr::set_names() %>%
    purrr::map_lgl(~(
      (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
        # (all(has_strict_numeric_format(data[[.x]]), na.rm = TRUE))) )%>% ## & elle doit contenir uniquement les niveaux attendus
        (all(has_strict_numeric_format(data[[.x]]), na.rm = TRUE) & !lubridate::is.instant(.x) )) ) %>% ## on veut des éléments tous numeric + la colonne n'est pas déjà de type "instant"
    purrr::discard(.p = ~.x == TRUE)
}


## ****************************************************************************
## instant
## ----------------------------------------------------------------------------

## Fonction qui détecte les variables qui sont déjà de type instant
## is.instant <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))
#' Keep instant columns of a dataset
#'
#' Keep instant columns of a dataset. Makes use of `is.instant <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))` of `lubridate` package.
#' @param data input dataset
#'
#' @returns A selection of columns from the input dataset that have an instant format, as intended in `lubridate::is.instant()`.
# #' @importFrom purrr set_names map_lgl keep
# #' @importFrom lubridate is.instant
#' @export
#'
#' @examples
#' # keep only instant columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2),
#'  date = lubridate::make_date(year = c(2019L, 2021L))
#' ) %>%
#'  keep_col_instant()
keep_col_instant <- function(data) {
  names(data) %>%
    purrr::set_names() %>%
    purrr::map_lgl(~(
      (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
        (lubridate::is.instant(data[[.x]]) )) ) %>% ## on veut des éléments tous "instant"
    purrr::keep(.p = ~.x == TRUE)
}

#' Discard instant columns of a dataset
#'
#' Discard instant columns of a dataset. Makes use of `is.instant <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))` of `lubridate` package.
#' @param data input dataset
#'
#' @returns A selection of columns from the input dataset that do not have an instant format, as intended in `lubridate::is.instant()`.
# #' @importFrom purrr set_names map_lgl keep
# #' @importFrom lubridate is.instant
#' @export
#'
#' @examples
#' # discard instant columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2),
#'  date = lubridate::make_date(year = c(2019L, 2021L))
#' ) %>%
#'  discard_col_instant()
discard_col_instant <- function(data) {
  names(data) %>%
    purrr::set_names() %>%
    purrr::map_lgl(~(
      (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
        (lubridate::is.instant(data[[.x]]) )) ) %>% ## on veut des éléments tous "instant"
    purrr::discard(.p = ~.x == TRUE)
}


## ****************************************************************************
## Dummy
## ----------------------------------------------------------------------------
## TODO: pour l'instant, keep_col_dummy sélectionne aussi les colonnes vides


#' Keep dummy columns
#'
#' Keep dummy columns
#' @param data entry dataset
#'
#' @returns A selection of the dummy columns from the input dataset.
# #' @importFrom dplyr select where
#' @export
#'
#' @examples
#' # keep only dummy columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2)
#' ) %>%
#'  keep_col_dummy()
keep_col_dummy <- function(data) {
  dplyr::select(data, dplyr::where(is_dummy))
}

#' Discard dummy columns
#'
#' Discard dummy columns
#' @param data entry dataset
#'
#' @returns A selection of the columns from the input dataset that are not dummy.
# #' @importFrom dplyr select where
#' @export
#'
#' @examples
#' # keep only dummy columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  na_col = rep(NA_real_, times = 2)
#' ) %>%
#'  discard_col_dummy()
discard_col_dummy <- function(data) {
  dplyr::select(data, !dplyr::where(is_dummy))
}
