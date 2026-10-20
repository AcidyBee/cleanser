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
#' @inheritParams dplyr::select
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

