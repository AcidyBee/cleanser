## ****************************************************************************
## ****************************************************************************
## Détection et ré-unification d'une variable séparée sur plusieurs colonnes
## Par exemple `ischemie_froide` variables in ABM rapport de greffe files
## ****************************************************************************
## ****************************************************************************


## ****************************************************************************
## ----------------------------------------------------------------------------
## Repère les noms de variables dupliquées sur plusieurs colonnes (avec préfixe commun)
## test si un groupe de colonnes partage des observations communes. 2 cas:
## 1. les colonne d'un même groupe ne partagent pas d'observations en commun: colonnes à unifier
## 2. les colonnes d'un même groupe partagent des observations en commun: colonnes au format large
# ne fonctionne pas avec les pipes de R, mais fonctionne avec ceux de magritr
# is_shared_values_across_rows <- function(.data, ...) {
#   .data %>%
#     dplyr::select(...) %>%
#     is.na() %>%
#     `!`() %>%
#     rowSums() %>%
#     `>`(1) %>%
#     any()
# }
#' Check if data are shared across rows of a set of columns
#'
#' Check if data are shared across rows of a set of columns.
#' This is especially useful for SAP datasets where duplicated columns can hold the same information
#' but each corresponds to a specific time span.
# #' @inheritParams dplyr::select
#'
#' @returns a dataset with the same number of rows as the imput data, but without the empty columns that were discarded.
# #' @importFrom dplyr select `%>%`
#' @export
#'
#' @examples
#' data.frame(
#'   ischemie_froide.1 = c(NA_real_, NA_real_, 720, 780),
#'   ischemie_froide.2 = c(720, 780, NA_real_, NA_real_)
#' ) %>%
#'   is_shared_values_across_rows(dplyr::matches("^ischemie_froide"))
# #' \dontrun{
# #' }
is_shared_values_across_rows <- function(.data, ...) {
  .data  %>%
    dplyr::select(...) %>%
    is.na() %>%
    `!`() %>%
    rowSums() %>%
    `>`(1) %>%
    any()
}
# ## Utilisation: OK
# ## ... pour un groupe de variables
# is_shared_values_across_rows(df_greffe_patched, matches(dup_groupes[1]))
# is_shared_values_across_rows(df_greffe_patched, matches(dup_groupes[2]))
# ## ... pour plusieurs groupes de variables avec un map
# dup_groups_is_shared_across_rows <- dup_groups %>%
#   rlang::set_names() %>%
#   map_lgl(.f = ~ is_shared_values_across_rows(.data = df_greffe_patched, matches(paste0("^", .x))))
# ## séparation des candidats au format large: une ligne donnée peut avoir des valeurs dans plusieurs colonnes du même groupe
# ## on retrouve sans surprise maladie_initiale et complications
# ## ttt_IS_1 est à la fois au format large et a un effet de millésime
# ## les autres sont à vérifier: HBV_DNA, type_ttt_DI_pre, type_ttt_DI_post
# dup_groups_wide_candidates <- keep(dup_groups_is_shared_across_rows, .p = ~.x == TRUE)
# ## ...et son groupe complémentaire: les colonnes dupliquées qui ne partagent pas d'observations
# dup_groups_millesime_candidates <- keep(dup_groups_is_shared_across_rows, .p = ~.x == FALSE)
# names(dup_groups_millesime_candidates)


## ****************************************************************************
## ----------------------------------------------------------------------------
## Fuzzy join autour d'une date pour faciliter des jointures imparfaites entre 2 bases
## C'est particuliérement utile dans les 2 cas suivants
## - jointure sur la date_nais pour des individus dont celle-ci est imparfaitement connue
## c'est le cas par exemple pour certains patients dont seule l'année de naissance est connue
## et qui est parfois complétée par un 1er janv., un 31 déc. ou encore un 15 juin...
## solution: jointure à +/- 1 an
## - jointure sur la date_GRF qui peut varier d'une base à l'autre lorsque la Tx est réalisée au cours de la nuit,
## et que l'intervalle de l'intervention se fait sur les 2 jours...
## solution: jointure à +/- 1 jour
## Généralisation de la left_join_fuzzy_date
#' Fuzzy left join including a jon specification on a date
#'
#' Fuzzy left join including a jon specification on a date
#' @inheritParams dplyr::left_join
#' @inheritParams lubridate::period
#' @param by_date_x,by_date_y A join specification with the name of the date variable of dataset x & y invalved in the fuzzy date join.
#'   If only `by_date_x` is provided, `by_date_y` will default to `by_date_x`.
#' @param by_not_fuzzy A regular join specification.
#'
#' @returns An object of the same type as x (including the same groups), with the same number of rows as x. The order of the rows and columns of x is preserved as much as possible.
# #' @importFrom dplyr left_join mutate join_by between select all_of
# #' @importFrom lubridate period
#' @export
#'
#' @examples
#' clr_left_join_fuzzy_date(
#' data.frame(
#'   id = 1:5,
#'   sexe = c("F", "H", "F", "F", "H"),
#'   date_nais = c("1923/01/01", "1924/01/01", "1925/01/01", "1926/01/01", "1927/01/01") %>%
#'   lubridate::ymd(),
#'   DB = c("oui", "non", "non", "oui", NA_character_)
#' ),
#' data.frame(
#'   id = 1:5,
#'   sexe = c("F", "H", "F", "F", "H"),
#'   date_nais = c("1923/01/01", "1924/01/02", "1924/12/31", "1926/01/03", "1926/12/30") %>%
#'   lubridate::ymd(),
#'   DB = c("oui", "non", "non", "oui", NA_character_)
#' ), by_date_x = "date_nais", by_not_fuzzy = "id"
#' )
clr_left_join_fuzzy_date <- function(x, y, by_date_x, by_date_y = by_date_x, by_not_fuzzy = NULL, suffix = c(".x", ".y"),
                                     num = 1, units = "days") { # default: 1 jour
  dplyr::left_join(
    x,
    y %>%
      dplyr::mutate(
        date_lower = .data[[by_date_y]] - lubridate::period(num = num, units = units),
        date_upper = .data[[by_date_y]] + lubridate::period(num = num, units = units)
      ),
    by = dplyr::join_by(!!by_not_fuzzy, dplyr::between(!!by_date_x, "date_lower", "date_upper")),
    suffix = suffix
  ) %>%
    dplyr::select(-dplyr::all_of(c("date_lower", "date_upper")))
}


## ****************************************************************************
## ----------------------------------------------------------------------------
## Column comparison

## ----------------------------------------------------------------------------
## 2 by 2 comparison
## Fonction d'extractions d'observations différentes dans 2 colonnes
#' Extract Rows that Do Not Match for a 2 Columns Comparison
#'
#' Extract rows that do not match for a 2 columns comparison.
#' @param data input dataset.
#' @param x,y the 2 variables to compare.
#' @param id_cols <tidy-select> A set of columns that uniquely identify each observation. Typically used when you have to detect rows that don't behave as expected.
#'
#' @returns The rows from the input dataset that have no other levels than the ones specified in the `levels` argument, but with case issues.
# #' @importFrom dplyr select filter any_of
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
#'  clr_extract_mismatch_2cols(DB, case, id_cols = "id")
clr_extract_mismatch_2cols <- function(data, x, y, id_cols = NULL) {
  # dots <- rlang::ensyms(...)
  # if (length(dots) != 2L) {
  #   stop("Only 2 by 2 comparison is possible: check there are only two variables as input for the ellipsis arguments.")
  # }
  # data %>%
  #   dplyr::select(dplyr::any_of(id_cols), ...) %>%
  #   dplyr::filter(!!dots[[1]] != !!dots[[2]] | is.na(!!dots[[1]]) != is.na(!!dots[[2]]))
  ## maj: seules 2 variables sont comparées à la fois
  data %>%
    dplyr::select(dplyr::any_of(id_cols), {{ x }}, {{ y }}) %>%
    dplyr::filter(({{ x }} != {{ y }}) | (is.na({{ x }}) != is.na({{ y }})))
}

## ----------------------------------------------------------------------------
## map of 2 by 2 comparison, on columns corresponding to a given sufix
## Fonction d'extractions d'observations différentes dans 2 colonnes
#' Extract Rows that Do Not Match for a 2 Columns Comparison
#'
#' Extract rows that do not match for a 2 columns comparison.
#' @inheritParams clr_extract_mismatch_2cols
#' @inheritParams dplyr::left_join
#' @param id_cols <tidy-select> A set of columns that uniquely identify each observation. Typically used when you have to detect rows that don't behave as expected.
#'
#' @returns A list of datasets for each comparison of suffixed variables detected.
# #' @importFrom dplyr mutate group_by filter ungroup distinct pull .data n
# #' @importFrom stringr str_subset str_remove
# #' @importFrom purrr set_names map
# #' @importFrom rlang sym
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
#'  clr_extract_mismatch_2cols(DB, case, id_cols = "id")
clr_map_mismatch_cols_w_suffix <- function(data, suffix = c(".x", ".y"), id_cols = NULL) {
  # suffix_regex <- paste0("(?:", paste(stringa::stra_transform_to_regex_pattern(suffix), collapse = "|"), ")$")
  suffix_regex <- paste0("(?:", paste(stringr::str_escape(suffix), collapse = "|"), ")$")
  # print(names(data))
  prefix_to_check <- data.frame(
    names_suffixed = names(data) %>%
      stringr::str_subset(pattern = paste0(".*", suffix_regex))
  ) %>%
    dplyr::mutate(names_prefix = stringr::str_remove(.data$names_suffixed, pattern = suffix_regex)) %>%
    ## maj 2024-04-04: on ne veut conserver que les préfixes qui existent pour les 2 suffixes
    dplyr::group_by(.data$names_prefix) %>%
    dplyr::filter(dplyr::n() == 2L) %>%
    dplyr::ungroup() %>%
    dplyr::distinct(.data$names_prefix) %>%
    dplyr::pull(.data$names_prefix)
  # prefix_to_check <- names(data) %>%
  #   stringr::str_subset(pattern = paste0(".*", suffix_regex)) %>%
  #   stringr::str_remove(pattern = suffix_regex) %>%
  #   unique()
  prefix_to_check %>%
    purrr::set_names() %>%
    purrr::map(\(x) clr_extract_mismatch_2cols(data,
                                               !!rlang::sym(paste0(x, suffix[[1]])),
                                               !!rlang::sym(paste0(x, suffix[[2]])),
                                               id_cols = id_cols
    ))
}
