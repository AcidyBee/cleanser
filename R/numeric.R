
## ----------------------------------------------------------------------------
## Fonctions utilitaires pour vérifier que les variables ont strictement un type 'numeric'

## A ce niveau, il faut repérer les variables qui doivent être converties au type numeric
## et vérifier qu'elle ne contiennent pas de valeur type < 0.12....

## Création d'une fonction qui repère des chaines de character de type numeric
contains_digits <- function(x) {
  stringr::str_detect(x, "\\d")
}
# ## ne reconnait pas les nombres en écriture scientifique, mais reconnait indifféremment `,` ou `.`
# has_strict_numeric_format <- function(x, negate = FALSE) {
#   # stringr::str_detect(x, "^\\d*\\.?\\d*$", negate = negate)
#   ## maj 2023-10-10: prise en compte de 2 sep: . ou ,
#   stringr::str_detect(x, "^\\d*[.,]?\\d*$", negate = negate)
# }

## maj 2024-03-27: ajout à la version précédente les écritures scientifiques...
#' Check if elements of a vector have a strict numeric format
#'
#' Check if elements of a vector have a strict numeric format.
#' This function is used for instance in the `keep_col_numeric` function to select numeric columns,
#' even in case of parsing issues.
#' @inheritParams stringr::str_detect
#' @param decimal_sep vector of expected decimal separators used in the scriptures. Defaults is period and comma: `c(".", ",")`.
#'
#' @returns a vector of logical indicating if elements have a strict numeric scripture, includig `,` or `.` as a decimal separator.
# #' @importFrom stringr str_detect
#' @export
#'
#' @examples
#' vec <- c("1", "09", ".12", "0.12", "2 amis", "test", "< .12", "1.2E-2", "1,5", "2015-05-15")
#' has_strict_numeric_format(vec)
has_strict_numeric_format <- function(string, negate = FALSE, decimal_sep = c(".", ",")) {
  decimal_sep <- paste(decimal_sep, collapse = "")
  regex_pattern <- paste0("^\\d*[", decimal_sep, "]?\\d*(?:(?i)E[+-]?\\d*)?$")
  ## maj 2023-10-10: prise en compte de 2 sep: . ou ,
  ## maj 2024-03-27: ajout à la version précédente des écritures scientifiques...
  stringr::str_detect(string = string, pattern = regex_pattern, negate = negate)
}

# c("1", "09", ".12", "0.12", "2 amis", "test", "< .12") %>% contains_digits()
# c("1", "09", ".12", "0.12", "2 amis", "test", "< .12", "0,12") %>% has_strict_numeric_format()
# ## -> Utilisation:
# ## recodage automatique des variables qui ont un format numeric attendu
# df %>%
#   # pull(BMI.ABM) %>%
#   # has_strict_numeric_format()
#   mutate(across(where(fn = ~all(has_strict_numeric_format(.x), na.rm = TRUE)), as.numeric))
## maj 2023-06-21: généralisation aux notations scientifiques + sep = ","...
# vec <- c("1", "09", ".12", "0.12", "2 amis", "test", "< .12", "1.2E-2", "1,5", "2015-05-15")
# !is.na(as.numeric(vec))
# # [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE
# grepl('^-?[0-9.]+$', vec) # cette autre version ne reconnait pas les nombres avec écriture scientifique (i.e. 1.2E-2)
# # [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
# ## Attention: aucune des 2 écritures précédentes ne reconnait le cas ou le nombre apparaît avec un sep = ","
# parse_number(vec) # Avec les arguments par défaut: élimine les autres sep que ".". Ne traite donc pas 1,5 comme 1.5...

## reconnait les nombres en écriture scientifique, mais ne reconnait pas `,` ou `.`
has_strict_numeric_format_coerced <- function(x, negate = FALSE) {
  # stringr::str_detect(x, "^\\d*\\.?\\d*$", negate = negate)
  logical_x <- is.na(suppressWarnings(as.numeric(stats::na.omit(x)))) # & !lubridate::is.instant(na.omit(x)
  # if(negate == FALSE) {
  if (isFALSE(negate)) {
    logical_x <- !logical_x
  }
  logical_x
}
# Utilisation: has_strict_numeric_format(vec)
# # [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE
# has_strict_numeric_format_1(vec)
# # [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE
## Attention, avec cette nouvelle fonction, une variable au format datetime sera convertie en numeric !!
# vec_date <- c("2015-05-15", "2015-07-15") %>% as_datetime()
# has_strict_numeric_format(vec_date)
# # [1] TRUE TRUE
# is.na(suppressWarnings(as.numeric(na.omit(vec_date))))
# ## is.instant() regarde le type d'un vecteur (ou une colonne): inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))
# # ## il n'y a pas de sens à réaliser un test sur les éléments indépendants d'un vecteur qui sont bien numeric pour un datetime...
# # lubridate::is.instant(na.omit(vec_date))
# # # [1] TRUE
# ## C'est au moment du recodage auto que l'on voudra s'assurer de ne pas recoder un instant en numeric...


