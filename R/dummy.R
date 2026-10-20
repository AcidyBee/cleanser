## ****************************************************************************
## ****************************************************************************
## Fonctions pour la gestion automatique des variables dummy
## ****************************************************************************
## ****************************************************************************

## ****************************************************************************
## Fonction d'identification des dummy variables
## Fonction détectant les variables de type dummy qu'elles soient numeric ou character
#' Check if a vector is only dummy elements (i.e. 0/1)
#'
#' Check if a vector is only dummy elements (i.e. 0/1).
#' This function has 2 direct applications on data structures in the package:
#' 1. spot dummy columns using data %>% purrr::keep(\(x) is_dummy(x)) %>% names()
#' 2. it could be used to select only dummy columns in a dataset (see exemples)
# #' @importFrom stats na.omit
#' @param x a vector of any type. `x` has his NA elements discarded before it
#'   is coerced to a character vector. To check if the vector is made only
#'   of "0" & "1". Logical TRUE/FALSE vectors are not coerced to 0 or 1
#'   (which is the expected behavior).
#'
#' @returns a logical indicating if the input vector is dummy.
#' @export
#'
#' @examples
#' c(1, 7, NA_real_) %>%
#'   is_dummy()
#' c(0, 1, NA_real_) %>%
#'   is_dummy()
# is_dummy(c(0, 1, NA_real_, 5, 0, 1))
# is_dummy( c(0, 1, NA_real_, 0, 1))
# is_dummy(c(0, NA_real_, 0))
# is_dummy(c(1, NA_real_, 1))
# ## la coercion est effectuée automatiquement vers les character
# is_dummy(c("0", "1", NA_character_))
#' # keep only dummy columns names
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  na_col = rep(NA_real_, times = 2)
#' ) %>%
#'  purrr::keep(\(x) is_dummy(x)) %>%
#'  names()
#' # keep only numeric columns that are not dummy
#' data.frame(
#'  num = c(1, 2),
#'  dummy = c(1, 0),
#'  char = c("a", NA_character_),
#'  na_col = rep(NA_real_, times = 2)
#' ) %>%
#'  dplyr::select(dplyr::where(is.numeric)) %>%
#'  dplyr::select(!dplyr::where(is_dummy))
is_dummy <- function(x) {
  # x_unique <- x %>%
  #   na.omit() %>%
  #   unique() %>%
  #   sort()
  # sum(!x_unique %in% c(0, 1)) == 0
  ## maj 2023-10-09: réécriture complète de la fonction
  ## sans pipe et sans le sort (qui ne parait pas utile)
  x_unique <- as.character(unique(stats::na.omit(x)))
  # sum(!x_unique %in% c("0", "1")) == 0
  all(x_unique %in% c("0", "1")) && !is_only_na(x_unique) # on ne veut pas que le vecteur soit étiqueté comme dummy s'il ne contient que des NA
}

## ****************************************************************************
## Fonction d'identification des elts dummy d'un vecteur
#' Detect dummy elements in a vector
#'
#' @param x A vector of any type. `x` is coerced to a character vector before
#'   it is checked: i.e. do the elements of the vector corresponds to "0" & "1".
#'   Logical TRUE/FALSE vectors are not coerced to 0 or 1 (which is the expected behavior).
#' @param na_valid Is NA a valid element to be added to the dummy values 0/1, defaults to TRUE.
#' @param negate If TRUE, inverts the resulting boolean vector, defaults to FALSE
#'
#' @returns detect_dummy() returns a logical vector with TRUE for each element of string that matches pattern and FALSE otherwise.
#' @export
#'
#' @examples
#' c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = FALSE)
#' c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = TRUE)
#' c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(negate = TRUE)
detect_dummy <- function(x, na_valid = TRUE, negate = FALSE) {
  if(isFALSE(na_valid)) {
    x_logical <- as.character(x) %in% c("0", "1")
  } else {
    x_logical <- as.character(x) %in% c("0", "1", NA_character_)
  }
  if(isTRUE(negate)) {
    x_logical <- !x_logical
  }
  x_logical
}
# ## Vérification OK
# c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = FALSE)
# c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = TRUE)
# c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(negate = TRUE)


## ****************************************************************************
## Séparation d'une variable (n'importe quel type) en dummy pour chacun de ses niveaux
## ****************************************************************************
### TODO: input de la colonne à dummifier en NSE plutôt que par son nom ?
## ----------------------------------------------------------------------------
## Transforme les variables de type facteur en dummy pour les tableaux agrégés
## Transforme les variables facteurs numériques (ex: nperr_123) en numériques pour une lecture simplifiée
#' Augment a dataset with dummified version of a variable
#'
#' @description Augment a dataset with dummified version of a variable
#'   obtained from the combinations of the distinct cell values of the variable.
#'   Any type of character variable is allowed.
# #' @importFrom dplyr mutate row_number arrange select all_of enquo .data full_join relocate matches
# #' @importFrom tidyr pivot_wider
#' @param data a dataset containing the column to dummify.
#' @param names_from the name of the variable to dummify.
#' @param dummy_code optional length 2 vector giving the dummy coding (i.e. `0` and `1` modalities).
#'   Defaults to c(0, 1), but can be conveniently switched to c("no", "yes")
#'   to identify factor categories for instance.
#' @returns an augmented dataset with dummy values observations for each unique cell value of the variable.
#' @export
#' @examples
#' dataset <- data.frame(
#'   id = 1:6,
#'   char = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
#'   factor = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_) %>% factor(levels = c("Non", "Oui")),
#'   numeric = c(3, 2, 2, 1, 3, NA_real_),
#'   logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA)
#' )
#' # char
#' dummify(dataset, "char")
#' # factor
#' dummify(dataset, "factor")
#' # numeric
#' dummify(dataset, "numeric")
#' # logical
#' dummify(dataset, "logical")
#' # with non/oui instead of 0/1
#' dummify(dataset, "logical", dummy_code = c("non", "oui"))
dummify <- function(data, names_from, dummy_code = c(0, 1)){ # , id_cols = NULL
  # name_prefix <- ensym(names_from)
  ## Création d'identifiants pour conserver l'ordre initial + ordonner les variables dans l'ordre des facteurs (pour les variables factor)
  data <- data %>%
    ## Creation d'un identifiant de ligne pour conserver l'ordre initial + servir de id_cols pour le pivot_wider
    dplyr::mutate(initial_order = dplyr::row_number()) %>%
    dplyr::arrange(.data[[names_from]]) #%>% # permet d'ordonner les colonnes selon l'ordre des facteurs si c'est une variable facteur, dans l'ordre alphanumeric sinon
  # dplyr::mutate(order_factors = dplyr::row_number())
  dummified_data <- data %>%
    dplyr::select(dplyr::all_of(c("initial_order", names_from))) %>%
    dplyr::mutate(value = dummy_code[2]) %>%
    tidyr::pivot_wider(id_cols = "initial_order", names_from = !! dplyr::enquo(names_from), values_from = "value", values_fill = dummy_code[1],
                       names_prefix = paste0(names_from, "."))
  # dummified_data
  ## L'ordre des lignes doit être le même que celui des données dummyfiées
  # dplyr::arrange(.data[[names_from]]) %>% # permet d'ordonner les colonnes selon l'ordre des facteurs si c'est une variable facteur, dans l'ordre alphanumeric sinon
  # dplyr::bind_cols(dummified_data) %>%
  dplyr::full_join(data, dummified_data, by = "initial_order") %>%
    dplyr::relocate(dplyr::matches(paste0(names_from, ".")), .after = dplyr::matches(paste0("^", names_from, "$"))) %>%
    ## rétablissement de l'ordre initial des lignes
    dplyr::arrange(.data[["initial_order"]]) %>%
    ## suppression de la variable temporaire d'ordre
    dplyr::select(-"initial_order")
}

