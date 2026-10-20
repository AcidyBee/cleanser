## ****************************************************************************
## ****************************************************************************
## Fonctions pour la gestion automatique des variables factor
## ****************************************************************************
## ****************************************************************************

## ----------------------------------------------------------------------------
## Fonctions utilitaires pour vérifier que les variables ont des levels spécifiques attendus
#' Check if elements of a vector have expected levels
#'
#' Check if elements of a vector have expected levels.
#' This function is used for instance in the `keep_col_w_levels` function to select specific factor columns,
#' even in case of case issues.
#' @inheritParams stringr::str_detect
#' @param levels Complete set of specific levels seeked for the variables.
#' @param ignore_case Should case differences be ignored in the match? For fixed(), this uses a simple algorithm which assumes a one-to-one mapping between upper and lower case letters.
#'
#' @returns a vector of logical indicating if elements have a strict numeric scripture, includig `,` or `.` as a decimal separator.
# #' @importFrom stringr str_detect
# #' @importFrom stringa stra_transform_to_regex_pattern
#' @export
#'
#' @examples
#' ## Default: ignore_case = FALSE
#' vec <- c("Oui", "oui", "Non", "non", "NON", "ouistiti", NA_character_)
#' clr_detect_levels(vec, levels =  c("Non", "Oui"))
#' ## negate = TRUE
#' clr_detect_levels(vec, levels =  c("Non", "Oui"), negate = TRUE)
#' ## ignore_case = TRUE
#' clr_detect_levels(vec, levels =  c("Non", "Oui"), ignore_case = TRUE)
#' ## Default: ignore_case = FALSE pour +/-
#' vec <- c("+", "-", "Non", "non", "NON", "ouistiti", NA_character_)
#' clr_detect_levels(vec, levels =  c("+", "-"))
clr_detect_levels <- function(string, levels, negate = FALSE, ignore_case = FALSE) {
  ## transformation en regex en cas de pattern spéciaux (notamment +/-)
  ## maj 2024-04-23: utilisation de stringr::str_escape, plutôt que la fonction développée dans stringa
  # regex_levels <- stringa::stra_transform_to_regex_pattern(levels)
  regex_levels <- stringr::str_escape(levels)
  ## creation du pattern correspondant aux lvl recherchés
  regex_pattern <- paste0("^(?:", paste(regex_levels, collapse = "|"), ")$")
  if (isTRUE(ignore_case)) {
    regex_pattern <- paste0("(?i)", regex_pattern)
  }
  ## Vérification si l'elt correspondent aux niveaux (case insensitive)
  stringr::str_detect(string = string, pattern = regex_pattern, negate = negate)
}
# stringa::stra_transform_to_regex_pattern(c("+", "-"))


## ****************************************************************************
## Extract factor variables with given levels
## ----------------------------------------------------------------------------

# ## pour détecter toutes les variables qui ont un jeu de modalités donné
# ## il suffit d'appliquer la fonction suivante
# get_col_w_levels <- function(data, levels) {
#   names(data) %>%
#     purrr::set_names() %>%
#     purrr::map_lgl(~(
#       (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
#         (dplyr::setdiff(data[[.x]], levels) %>% is_only_na())) )%>% ## & elle doit contenir uniquement les niveaux attendus
#     purrr::keep(.p = ~.x == TRUE) %>%
#     names()
# }
## - Fonctions qui réalisent la détection des col qui ont les modalités d'intérêt
## pour détecter toutes les variables qui ont un jeu de modalités donné
## il suffit d'appliquer la fonction suivante
# #' Keep columns having specific modalities
# #'
# #' Keep columns having a specific set of levels
# #' @param data input dataset
# #' @param levels complete set of specific levels seeked for the variables
# #'
# #' @returns A selection of columns from the input dataset that have no other levels than the ones specified in the `levels` argument
# #' @importFrom purrr set_names map_lgl keep
# #' @export
# #'
# #' @examples
# #' # keep only dummy columns
# #' data.frame(
# #'  num = c(1, 2),
# #'  dummy = c(1, 0),
# #'  char = c("a", NA_character_),
# #'  factor = c("non", "oui"),
# #'  na_col = rep(NA_real_, times = 2)
# #' ) %>%
# #'  keep_col_w_levels(levels = c("non", "oui"))
# keep_col_w_levels <- function(data, levels) {
#   names(data) %>%
#     set_names() %>%
#     map_lgl(~(
#       (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
#         (base::setdiff(data[[.x]], levels) %>% is_only_na())) ) %>% ## & elle doit contenir uniquement les niveaux attendus
#     keep(.p = ~.x == TRUE) #%>%
#   ## maj 2024-03-27: the function is modified to get as an output the seeked variables, instead of their names.
#   ## For sake of consistancy with the other variables of the package
#   # names()
# }

# #' Discard columns having specific modalities
# #'
# #' Discard columns having a specific set of levels
# #' @param data entry dataset
# #' @param levels complete set of specific levels seeked for the variables
# #'
# #' @returns A selection of columns from the input dataset that have no other levels than the ones specified in the `levels` argument
# #' @importFrom purrr set_names map_lgl discard
# #' @export
# #'
# #' @examples
# #' # Discard dummy columns
# #' data.frame(
# #'  num = c(1, 2),
# #'  dummy = c(1, 0),
# #'  char = c("a", NA_character_),
# #'  factor = c("non", "oui"),
# #'  na_col = rep(NA_real_, times = 2)
# #' ) %>%
# #'  discard_col_w_levels(levels = c("non", "oui"))
# discard_col_w_levels <- function(data, levels) {
#   names(data) %>%
#     set_names() %>%
#     map_lgl(~(
#       (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
#         (base::setdiff(data[[.x]], levels) %>% is_only_na())) ) %>% ## & elle doit contenir uniquement les niveaux attendus
#     discard(.p = ~.x == TRUE) #%>%
#   ## maj 2024-03-27: the function is modified to get as an output the seeked variables, instead of their names.
#   ## For sake of consistancy with the other variables of the package
#   # names()
# }

## maj 2024-03-27: pour permettre une reconnaissance des levels case insensitive
#' Keep columns with specific levels
#'
#' Keep columns with specific levels
#' @param data input dataset.
#' @param levels Complete set of specific levels seeked for the variables.
#' @param ignore_case Should case differences be ignored in the match? For fixed(), this uses a simple algorithm which assumes a one-to-one mapping between upper and lower case letters.
#' @param id_cols <tidy-select> A set of columns that uniquely identify each observation. Typically used when you have to detect rows that don't behave as expected.
#' @param fun matching function used to match the levels seeked.
# #' @param ... <tidy-select> One or more unquoted expressions separated by commas. Variable names can be used as if they were positions in the data frame, so expressions like x:y can be used to select a range of variables.
#'
#' @returns A dataset with the same number of lines than the input dataset, keeping only the columns corresponding to the criterion.
# #' @importFrom purrr set_names map_lgl keep
# #' @importFrom lubridate is.instant
# #' @importFrom dplyr select all_of
#' @export
#'
#' @examples
#' # keep only columns with specific levels
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2),
#'  date = lubridate::make_date(year = c(2019L, 2021L))
#' ) %>%
#'  keep_col_w_levels(c("non", "oui"))
keep_col_w_levels <- function(data, levels, ignore_case = FALSE, id_cols = NULL, fun = c("all", "any")) {
  fun <- match.arg(fun) %>% match.fun()
  selected <- names(data) %>%
    purrr::set_names() %>%
    purrr::map_lgl(~(
      (!is_only_na(data[[.x]])) && ## la col ne doit pas contenir que des NA
        # (all(has_strict_numeric_format(data[[.x]]), na.rm = TRUE))) )%>% ## & elle doit contenir uniquement les niveaux attendus
        (fun(clr_detect_levels(data[[.x]], levels, ignore_case = ignore_case), na.rm = TRUE) )) ) %>% ## on veut des éléments tous numeric + la colonne n'est pas déjà de type "instant"
    purrr::keep(.p = ~.x == TRUE) %>%
    names()
  data %>%
    dplyr::select({{ id_cols }}, dplyr::all_of(selected))
}

#' Discard columns having specific modalities
#'
#' Discard columns having a specific set of levels
#' @param data entry dataset
#' @param levels complete set of specific levels seeked for the variables
#' @param ignore_case Should case differences be ignored in the match? For fixed(), this uses a simple algorithm which assumes a one-to-one mapping between upper and lower case letters.
#' @param id_cols <tidy-select> A set of columns that uniquely identify each observation. Typically used when you have to detect rows that don't behave as expected.
#' @param fun matching function used to match the levels seeked.
# #' @param ... <tidy-select> One or more unquoted expressions separated by commas. Variable names can be used as if they were positions in the data frame, so expressions like x:y can be used to select a range of variables.
#'
#' @returns A selection of columns from the input dataset that have no other levels than the ones specified in the `levels` argument
# #' @importFrom purrr set_names map_lgl discard
#' @export
#'
#' @examples
#' # Discard dummy columns
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  factor = c("non", "oui"),
#'  na_col = rep(NA_real_, times = 2)
#' ) %>%
#'  discard_col_w_levels(levels = c("non", "oui"))
discard_col_w_levels <- function(data, levels, ignore_case = FALSE, id_cols = NULL, fun = c("all", "any")) {
  ## avec `all` on a les colonnes qui n'ont que les niveaux attendus (à la case près si ignore_case = TRUE)
  ## avec `any` on a les colonnes qui ont que les niveaux attendus (à la case près si ignore_case = TRUE), mais qui peuvent également avoir d'autres niveaux
  ## ce qui peut permettre de repérer les varaibles avec des typos...
  fun <- match.arg(fun) %>% match.fun()
  selected <- names(data) %>%
    purrr::set_names() %>%
    purrr::map_lgl(~(
      ## maj 2024-03-28: contrairement à keep, il faut modifier la ligne ci-dessous pour forcer l'élimination des colonnes ne contenant que des NA
      (is_only_na(data[[.x]])) || ## la col ne doit pas contenir que des NA
        # (all(has_strict_numeric_format(data[[.x]]), na.rm = TRUE))) )%>% ## & elle doit contenir uniquement les niveaux attendus
        (fun(clr_detect_levels(data[[.x]], levels, ignore_case = ignore_case), na.rm = TRUE) )) ) %>% ## on veut des éléments tous numeric + la colonne n'est pas déjà de type "instant"
    purrr::discard(.p = ~.x == TRUE) %>%
    names()
  data %>%
    dplyr::select(id_cols, dplyr::all_of(selected))
}



#' Extract rows that have case issues with the set of levels
#'
#' Extract rows that have case issues with the set of levels.
#' @param data entry dataset
#' @param levels complete set of specific levels seeked for the variables
#' @param id_cols <tidy-select> A set of columns that uniquely identify each observation. Typically used when you have to detect rows that don't behave as expected.
#'
#' @returns The rows from the input dataset that have no other levels than the ones specified in the `levels` argument, but with case issues.
# #' @importFrom dplyr filter if_any
#' @export
#'
#' @examples
#' data_ex <- data.frame(
#'   id = 1:4,
#'   dummy = c(0, 0, 1, 1),
#'   DB = c("oui", "non", "non", "oui"),
#'   typo = c("oui", "non", "non", "pui"),
#'   case = c("OUI", "non", "Non", "oui"),
#'   sexe = c("F", "H", "F", "H"),
#'   regex_spec = c("+", "-", "-", "+"),
#'   DB_w_na = c("oui", "non", "non", NA_character_),
#'   na_only = rep(NA_character_, times = 4)
#' )
#' data_ex %>%
#'  clr_extract_mismatch_w_levels_case(levels = c("non", "oui"))
#' data_ex %>%
#'  clr_extract_mismatch_w_levels_case(levels = c("non", "oui"), id_cols = "id")
#' data_ex %>%
#' dplyr::select(-case) %>%
#'  clr_extract_mismatch_w_levels_case(levels = c("non", "oui"), id_cols = "id")
clr_extract_mismatch_w_levels_case <- function(data, levels, id_cols = NULL) {
  ## Ajout du numéro de ligne si aucune id_cols n'est définie
  if (is.null(id_cols)) {
    data <- data %>%
      dplyr::mutate(row_number = dplyr::row_number())
    id_cols <- "row_number"
  }
  data <- data %>%
    discard_col_w_levels(levels = levels, id_cols) %>% # discard cols that exactly match the levels expected: no pb with these cols
    keep_col_w_levels(levels = levels, ignore_case = TRUE, id_cols) %>% # keep only cols with case pb + id_cols
    dplyr::filter(dplyr::if_any(.cols = -id_cols, .fns = \(x) clr_detect_levels(x, levels = levels, negate = TRUE))) # filter only rows with pb

  if (NCOL(data) == length(id_cols)) {
    message(paste0("No case issues detected for levels: (", paste(levels, collapse = ", "), ")"))
  } else {
    data
  }
}


#' Extract rows that have typo issues with the set of levels
#'
#' Extract rows that have typo issues with the set of levels.
#' @param data entry dataset
#' @param levels complete set of specific levels seeked for the variables
#' @param id_cols <tidy-select> A set of columns that uniquely identify each observation. Typically used when you have to detect rows that don't behave as expected.
#'
#' @returns The rows from the input dataset that have at least the levels like the ones specified in the `levels` argument, but with additional levels which may be typo issues.
# #' @importFrom dplyr filter if_any
#' @export
#'
#' @examples
#' data.frame(
#'   id = 1:4,
#'   dummy = c(0, 0, 1, 1),
#'   DB = c("oui", "non", "non", "oui"),
#'   typo = c("oui", "non", "non", "pui"),
#'   case = c("OUI", "Non", "non", "oui"),
#'   sexe = c("F", "H", "F", "H"),
#'   regex_spec = c("+", "-", "-", "+"),
#'   DB_w_na = c("oui", "non", "non", NA_character_),
#'   na_only = rep(NA_character_, times = 4)
#' ) %>%
#'  clr_extract_mismatch_w_levels_typo(levels = c("non", "oui"))
clr_extract_mismatch_w_levels_typo <- function(data, levels, id_cols = NULL) {
  data %>%
    discard_col_w_levels(levels = levels, id_cols) %>%
    discard_col_w_levels(levels = levels, ignore_case = TRUE, id_cols) %>%
    keep_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE, id_cols, fun = "any") %>%
    dplyr::filter(dplyr::if_any(.cols = -id_cols, .fns = \(x) clr_detect_levels(x, levels = levels, negate = TRUE)))
}


## ****************************************************************************
## Recodages auto des variables factor qui ont une modalité donnée (par ex O/N):
## ****************************************************************************

## ****************************************************************************
## Fonctions internes du package qui permettent de corriger les probèmes de case
## avant l'étape de recodage

## Construction d'une fonction qui corrige le problème de case pour un niveau donné
#' Cure a single case issue for a factor level in a string
#'
#' Cure a single case issue for a factor level in a string
#' @inheritParams stringr::str_replace
#' @param single_level a single element of the complete set of specific levels seeked for the variables
#'
#' @returns A selection of columns from the input dataset that have no other levels than the ones specified in the `levels` argument
# #' @importFrom stringr str_replace
# #' @importFrom stringa stra_transform_to_regex_pattern
#' @export
#'
#' @examples
#' case <- c("OUI", "Non", "non", "oui")
#' ## single application
#' case %>%
#' cure_single_level_case("oui")
#' ## pipe of several applications of the function
#' case %>%
#' cure_single_level_case("oui") %>%
#' cure_single_level_case("non")
cure_single_level_case <- function(string, single_level) {
  ## maj 2024-04-23: utilisation de stringr::str_escape, plutôt que la fonction développée dans stringa
  regex_level <- stringr::str_escape(single_level)
  stringr::str_replace(
    string,
    # pattern = paste0("(?i)^(", paste(stringa::stra_transform_to_regex_pattern(single_level), collapse = "|"), ")$"),
    pattern = paste0("(?i)^(", paste(regex_level, collapse = "|"), ")$"),
    replacement = single_level)
}


# Application au recodage des jeux de données: OK
#' Cure columns with case issues for specific factor levels
#'
#' Cure columns with case issues for specific factor levels
#' @param data input dataset.
#' @param levels Complete set of specific levels seeked for the variables.
#'
#' @returns A dataset with the same number of columns than the input dataset, with the columns corresponding to the criterion cured from any case issue.
# #' @importFrom dplyr mutate across all_of
# #' @importFrom purrr reduce
#' @export
#'
#' @examples
#' # Cure case issues in the variables
#' data.frame(
#'   id = 1:4,
#'   dummy = c(0, 0, 1, 1),
#'   DB = c("oui", "non", "non", "oui"),
#'   typo = c("oui", "non", "non", "pui"),
#'   case = c("OUI", "Non", "non", "oui"),
#'   sexe = c("F", "H", "F", "H"),
#'   regex_spec = c("+", "-", "-", "+"),
#'   DB_w_na = c("oui", "non", "non", NA_character_),
#'   na_only = rep(NA_character_, times = 4)
#' ) %>%
#' cure_col_w_levels_case(levels = c("non", "oui"))
cure_col_w_levels_case <- function(data, levels) {
  col_w_levels_case_issues <- data %>%
    discard_col_w_levels(levels = levels) %>%
    keep_col_w_levels(levels = levels, ignore_case = TRUE) %>%
    names()
  data <- data %>%
    dplyr::mutate(dplyr::across(dplyr::all_of(col_w_levels_case_issues),
                  .fns = \(ci) purrr::reduce(levels,
                                             .f = \(x, y) cure_single_level_case(string = x, single_level = y),
                                             .init = .data$ci)))
  data
}




## ****************************************************************************
## Fonction qui se charge de la détection et du recodage en facteur des cols
## qui ont uniquement les modalités définies dans levels
## nécessite keep_col_w_levels de utils-recode.R
## maj 2024-03-29: Fonctions qui réalisent le recodage auto de toutes les col qui ont les modalités d'intérêt
#' Recode columns having specific modalities
#'
#' Spot columns having a specific set of levels using `keep_col_w_levels`,
#' and recode them using the order of the levels in the levels argument.
# #' @inheritParams keep_col_w_levels
#' @param data input dataset
#' @param levels complete set of specific levels seeked for the variables
#' @param ignore_case Should case differences be ignored in the match? For fixed(), this uses a simple algorithm which assumes a one-to-one mapping between upper and lower case letters.
#' @inheritParams base::factor
#'
#' @returns data with the same properties as the input data, with the columns having all the levels specified in the `levels` argument recoded
# #' @importFrom dplyr mutate across all_of
# #' @importFrom stringr str_replace
#' @export
#'
#' @examples
#' data.frame(
#' x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
#' y = c("N", "O", "Non", "Oui", "Oui", NA_character_),
#' z = c("Non", "Oui", "Non", "Oui", "+", NA_character_)
#' ) %>%
#'   recode_col_w_levels(levels = c("Non", "Oui"))
#' data.frame(
#' x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
#' y = c("N", "O", "Non", "Oui", "Oui", NA_character_),
#' z = c("Non", "Oui", "Non", "Oui", "+", NA_character_)
#' ) %>%
#'   recode_col_w_levels(levels = c("Non", "Oui"), labels = c("N", "O"))
#' # Recode the dataset even for columns with case issues in the factors
#' data.frame(
#'   id = 1:4,
#'   dummy = c(0, 0, 1, 1),
#'   DB = c("oui", "non", "non", "oui"),
#'   typo = c("oui", "non", "non", "pui"),
#'   case = c("OUI", "Non", "non", "oui"),
#'   sexe = c("F", "H", "F", "H"),
#'   regex_spec = c("+", "-", "-", "+"),
#'   DB_w_na = c("oui", "non", "non", NA_character_),
#'   na_only = rep(NA_character_, times = 4)
#' ) %>%
#' recode_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)

#' \dontrun{
#' recoded_data <- recode_col_w_levels(data, levels = c("non", "oui"))
#' recode_col_N_O <- partial(.f = recode_col_w_levels, levels = c("N", "O"))
#' }
recode_col_w_levels <- function(data, levels, labels = levels, ignore_case = FALSE) {
  col_w_levels <- keep_col_w_levels(data, levels = levels, ignore_case = ignore_case) %>% names()
  if (isTRUE(ignore_case)) {
    data <- data %>%
      cure_col_w_levels_case(levels = levels)
  }
  data %>%
    dplyr::mutate(dplyr::across(dplyr::all_of(col_w_levels), \(x) factor(x = x, levels = levels, labels = labels)))
}
# ## -> Utilisation
# recode_col_N_O <- partial(.f = recode_col_w_levels, levels = c("N", "O"))
# df_greffe_parsed %>%
#   recode_col_N_O()

## specific recoding avec modalités N/O et -/+
## A partir de "recode_col_w_levels()" définie dans utils-recode.R
#' Automated recoding of N/O factors
#'
#' Automated recoding of N/O factors
#' @inheritParams purrr::partial
# #' @inheritParams recode_col_w_levels
#'
#' @returns a function that automatically recodes N/Y factors
# #' @importFrom purrr partial
#' @export
#'
#' @examples
#' data.frame(
#'   x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
#'   y = c("N", "O", "Non", "Oui", "Oui", NA_character_),
#'   z = c("Non", "Oui", "Non", "Oui", "+", NA_character_)
#' ) %>%
#' recode_col_N_O()
recode_col_N_O <- purrr::partial(.f = recode_col_w_levels, levels = c("non", "oui"), labels = c("N", "O"))

#' Automated recoding of -/+ factors
#'
#' Automated recoding of -/+ factors
#' @inheritParams purrr::partial
# #' @inheritParams recode_col_w_levels
#'
#' @returns a function that automatically recodes N/Y factors
# #' @importFrom purrr partial
#' @export
#'
#' @examples
#' data.frame(
#'   x = c("-", "+", "+", NA_character_),
#'   y = c("-", "O", "+", NA_character_)
#' ) %>%
#' recode_col_neg_pos() %>%
#' purrr::map_chr(class)
recode_col_neg_pos <- purrr::partial(.f = recode_col_w_levels, levels = c("-", "+"))
# recode_col_NF_neg_pos <- partial(.f = recode_col_w_levels, levels = c("NF", "-", "+"))

