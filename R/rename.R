## ****************************************************************************
## ****************************************************************************
## Nettoyage du nom des variables
## ****************************************************************************
## Fonctions exportees depuis utils-recode.R
## Ordre: Une fois éliminées les colonnes et lignes ne contenant pas de données
## Il faut partir direct sur un jeu de données avec des noms adaptés
## Méthode: utiliser un tableau de correspondance
## entre le libellé et le code de chaque variable:
## un dictionnaire qui peut également contenir le type et l'unité de chaque variable

# ## ----------------------------------------------------------------------------
# ## 1. -> Il faut souvent créer un dictionnaire à partir des données:
# # dput(names(df_clean)) %>%
# #     str_replace_all(pattern = "é|è|ê", replacement = "e") %>%
# #     str_replace_all(pattern = " ", replacement = "_") %>%
# #     dput()
# # names(df_clean) %>% repair_name_mapper_unique()
# df_dict <- tibble(
#   code = names(df_clean) %>% repair_name_mapper_unique(),
#   lib = names(df_clean),
#   type = map_chr(df_clean, ~ class(.x)[[1]]),
#   unit = ""
# )
#
# ## ----------------------------------------------------------------------------
# ## 2. -> le sauver pour édition dans xls:
# ## Attention: xls ne gère pas bien l'ouverture des fichiers UTF-8 (au moins la version 2011 pour mac)
# ## Il faudra donc ouvrir le fichier créé avec 'Numbers' puis l'exporter vers xls en xlsx à partir de 'Numbers'
# ## L'ouverture se passera alors correctement...
# path_to_dict <- "/Users/Alexis/Documents/Travail/R/Packages/acidyBeeToolBox/data/utils-recode"
# ## en tsv avec vroom ou autre méthode...
# vroom::vroom_write(df_dict, file.path(path_to_dict, "dict.tsv"), bom = TRUE)
# readr::write_excel_csv2(df_dict, file.path(path_to_dict, "dict.csv"))
# write_csv2(df_dict, file.path(path_to_dict, "dict.csv"))

## 3. -> modifier le code des variables à la main dans le fichier xls
## jusqu'au résultat désiré, puis le sauvegarder

## 4. -> importer le dictionnaire dans R pour créer la lut, et renomer les variables du df

## ----------------------------------------------------------------------------
## 2. -> Une solution alternative pourrait être d'afficher la lut dans
## un tableau interactif editable au sein d'un document Rmd,
## de la modifier directement puis de la sauver (tout gérer à partir du tableau)...
## -> DT::datatable()
## ----------------------------------------------------------------------------



# ## ****************************************************************************
# ## fonction de recodage à partir d'une lut
# ## data dataframe avec au moins 2 colonnes:
# ## - new_name: contenant le nouveau nom
# ## - old_name: contenant l'ancien nom
#
# ## ----------------------------------------------------------------------------
# ## Evaluation std: SE
# create_lut_from_dict <- function(data, new_name = "code", old_name = "lib") {
#   data[[old_name]] %>% purrr::set_names(data[[new_name]] %>% as.character())
# }
#
# rename_from_lut <- function(x, lut){
#   lut[x] %>% factor(levels = lut)
# }
# # la création de la lut est du type:
# # lut_x <- var_x$mod_lib %>%
# #   purrr::set_names(var_x$mod_code)
# # rename_from_lut("1", lut_x)


## ----------------------------------------------------------------------------
## Fonction pour transformer les libelles utilisés comme nom de colonnes
## en codes de variables syntaxiques utilisables lors de l'analyse
## Creation d'une lut entre old et new name
#' Recode from a lut
#'
#' This function allows to transform non-syntaxic libs to syntaxic var code
#' @param dictionary Dictionary linking lib to a given code
#' @param old lib col of the dictionary
#' @param new code col of the dictionary
#'
#' @returns lut linking lib to code
# #' @importFrom dplyr pull
#' @export
#'
#' @examples
#' dict <- data.frame(
#' lib_raw = c("date evenement", "uti'l"),
#' code = c("date_evt", "util")
#' )
#' create_lut_from_dictionary(dict, old = lib_raw, new = code)
create_lut_from_dictionary <- function(dictionary, old, new) {
  lut <- dictionary %>% dplyr::pull({{ new }})
  names(lut) <- dictionary %>% dplyr::pull({{ old }})
  lut
}

## Fonction de traduction a partir d'un dictionnaire, et des variables
## associees definissant permettant le passage des old vers les new
#' Translate data libs to syntaxic var code
#'
#' This function allows to transform non-syntaxic libs to syntaxic var code.
#' Using it in conjonction of dplyr rename_with it allows for direct dataframe names modification
#' (see example).
#' @param x Vector of names
#' @param dictionary Dictionary linking var libs to codes
#' @param old lib col of the dictionary
#' @param new code col of the dictionary
#'
#' @returns Vector of names of the same size as x
#' @export
#'
#' @examples
#' \dontrun{
#' dict <- data.frame(
#'   lib_raw = c("date evenement", "uti\'l"),
#'   code = c("date_evt", "util")
#' )
#' data <- tibble::tibble(
#'   `date evenement` = c("01/01/1974", "01/01/1989"),
#'   `uti\'l` = c("oui", "non")
#' )
#' translate_from_dictionary(names(data), dict, lib_raw, code)
#' dplyr::rename_with(data, .fn = \(x) translate_from_dictionary(x, dict, lib_raw, code))
#' }
translate_from_dictionary <- function(x, dictionary, old, new) {
  lut <- create_lut_from_dictionary(dictionary, {{ old }}, {{ new }}) # ABM.tidyr:::
  lut[x]
  # create_lut_from_dictionary(dictionary, {{ old }}, {{ new }})[x] # non-teste
}

