## ****************************************************************************
## Recodage des numeric
## ****************************************************************************

## ****************************************************************************
## Recodages auto des variables de type numeric:
## Fonction qui se charge de la détection et du recodage en numeric des cols
## et qui exclue les colonnes qui sont déjà recodées en instant: function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))
## nécessite utils-recode.R
#' Detects and recode numeric columns
#'
#' Detects and recode numeric columns
#' @param data input dataset
#'
#' @returns dataset with the same properties as the input dataset, with the numeric columns automatically recoded as such,
#' as long as the values of the vector correspond to a strict numeric scripture as intended in `cln_has_strict_numeric_format`.
# #' @importFrom dplyr mutate across all_of
#' @export
#'
#' @examples
#' data.frame(
#' x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
#' y = c(1, 0, 5, 3, 2, NA_real_),
#' z = c("1", "0", "5,2", "3.5", "2E-2", NA_character_)
#' ) %>%
#'   cln_recode_col_numeric()
cln_recode_col_numeric <- function(data) {
  col_numeric <- cln_keep_col_numeric(data) %>% names()
  col_instant <- cln_keep_col_instant(data) %>% names()
  col_numeric_not_instant <- base::setdiff(col_numeric, col_instant)
  data %>%
    dplyr::mutate(dplyr::across(dplyr::all_of(col_numeric_not_instant), as.numeric))
}
# ## -> Utilisation:
# ## recodage automatique des variables qui ont un format numeric attendu
# df <- df %>%
#   # pull(BMI.ABM) %>%
#   # cln_has_strict_numeric_format()
#   # mutate(across(where(fn = ~all(cln_has_strict_numeric_format(.x), na.rm = TRUE)), as.numeric))
#   cln_recode_col_numeric()



## ****************************************************************************
## Composite score:
## Crée un score composite de plusieurs variables
## avec gestion des NA via un argument na.rm = FALSE
#' Computes a composite score
#'
#' Computes a composite score
#' @param ... ellipsis to allow for an undefinied number of vectors to add
#' @inheritParams base::rowSums
#' @param score_fun matching function used to compute the score: either rowMeans or rowSums.
#'
#' @returns data with the same properties as the input data, with the columns having all the levels specified in the `levels` argument recoded
# #' @importFrom dplyr mutate across all_of
# #' @importFrom assertive coerce_to use_first
#' @export
#'
#' @examples
#' expand.grid(
#'   g = c(NA_real_, 0, NA_real_),
#'   ptc = c(NA_real_, 0, 1)
#' ) %>%
#'   dplyr::mutate(is_na_score = cln_compute_composite_score(g, ptc, na.rm = TRUE),
#'     score_fun = "rowSums") %>%
#'   dplyr::arrange(g, ptc)
cln_compute_composite_score <- function(..., na.rm = FALSE, score_fun = c("rowMeans", "rowSums")) {
  score_fun <- match.arg(score_fun) %>% match.fun()
  # if( !is.logical(na.rm) ) {
  #   stop("na.rm is not of class 'logical' ; it has class '", class(na.rm), "'.")
  # }
  # na.rm <- assertive::coerce_to(assertive::use_first(na.rm), target_class = "logical")
  # --- Validation et coercition de na.rm ---
  na.rm <- validate_na_rm(na.rm)

  args <- list(...) %>%
    as.data.frame()
  # args
  ## TODO: il faudrait vérifier que les arguments servant au calcul du score sont bien tous numeric
  # if( ! purrr::map(args, is.numeric) ) {
  #   stop("... is not of class 'numeric' ; it has class '", class(na.rm), "'.")
  # }
  score_fun(x = args, na.rm = na.rm)
}

# test_list <-
#   expand.grid(
#   g = c(NA, 0:3),
#   ptc = c(NA, 0:3)#,
#   # na.rm = c(TRUE, FALSE)
# ) %>%
#   # cln_compute_composite_score()
#   # mutate(MVI_share = classify_MVI_sup2(g, ptc, na.rm = FALSE)) %>%
#   # mutate(C4d_pos = classify_C4d_pos(g, ptc, na.rm = FALSE)) %>%
#   mutate(score_FALSE = cln_compute_composite_score(g, ptc, na.rm = FALSE),
#          score_TRUE = cln_compute_composite_score(g, ptc, na.rm = TRUE)) %>%
#   arrange(g, ptc)

#' Validate and coerce na.rm to a single logical
#'
#' Takes the first element if `na.rm` is a vector (mimicking
#' `assertive::use_first()`), then coerces it to logical while
#' rejecting ambiguous values.
#'
#' @param na.rm Value passed by the user.
#' @return A single `TRUE` or `FALSE`.
#' @noRd
validate_na_rm <- function(na.rm) {
  # 1. Longueur : on garde la première valeur (comme use_first)
  if (length(na.rm) == 0L) {
    stop("`na.rm` must not be empty.", call. = FALSE)
  }
  value <- na.rm[[1L]]

  # 2. Si c'est déjà un logical, on le retourne directement
  if (is.logical(value)) {
    if (is.na(value)) {
      stop("`na.rm` must be TRUE or FALSE, not NA.", call. = FALSE)
    }
    return(value)
  }

  # 3. Si c'est un numeric : 0 -> FALSE, 1 -> TRUE, autre -> erreur
  if (is.numeric(value)) {
    if (is.na(value)) {
      stop("`na.rm` must be TRUE or FALSE, not NA.", call. = FALSE)
    }
    if (value == 0) return(FALSE)
    if (value == 1) return(TRUE)
    stop(
      "`na.rm` must be TRUE or FALSE (or 1/0), not ", value, ".",
      call. = FALSE
    )
  }

  # 4. Si c'est un character : on accepte "TRUE"/"FALSE" (insensible à la casse)
  if (is.character(value)) {
    if (is.na(value)) {
      stop("`na.rm` must be TRUE or FALSE, not NA.", call. = FALSE)
    }
    upper <- toupper(value)
    if (upper == "TRUE")  return(TRUE)
    if (upper == "FALSE") return(FALSE)
    stop(
      "`na.rm` must be TRUE or FALSE, not '", value, "'.",
      call. = FALSE
    )
  }

  # 5. Tout le reste est refusé
  stop(
    "`na.rm` must be a logical, not an object of class '",
    paste(class(value), collapse = "/"), "'.",
    call. = FALSE
  )
}


## ****************************************************************************
## Arrondi un vecteur de type numeric au plus proche entier
#' Round to nearest integer
#'
#' Round to nearest integer
#' @param x a numeric vector.
#'
#' @returns a vector the same length as x, rounded and converted to the nearest integer.
#' @export
#'
#' @examples
#' # Round to nearest integer:
#' cln_round_to_nearest_integer(c(1.0, 2.1, 2.7, 5.7, NA_real_, NA))
cln_round_to_nearest_integer <- function(x) {
  as.integer(round(x))
}

## ****************************************************************************
## Sépare une variable continue en quantiles
## ****************************************************************************
#' Classify a numeric vector in quantiles
#'
#' Classify a numeric vector in quantiles. Default is quartile through argument `probs = seq(0, 1, 0.25)`.
#' @inheritParams base::cut
#' @inheritParams stats::quantile
#'
#' @returns a vector the same length as x, with the 3 corresponding tercile categories.
# #' @importFrom stats quantile
#' @export
#'
#' @examples
#' # Default quartile classification
#' cln_split_quantile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#' # Default with na.rm = FALSE
#' \dontrun{
#' cln_split_quantile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
#' }
cln_split_quantile <- function(x, labels = NULL, probs = seq(0, 1, 0.25), na.rm = FALSE,
                           names = TRUE, type = 7, ...) {
  if (!is.numeric(x)) {
    stop("x argument has to be numeric for the classification")
  }
  quantiles = stats::quantile(x, probs = probs, na.rm = na.rm, names = names, type = type, ...)
  cut(x, breaks = quantiles, labels = labels,
      include.lowest = TRUE) # sans cet argument la première valeur à gauche de l'intervalle est classée en NA
}

## Séparation à la médiane
#' Split a numeric vector at the median
#'
#' Split a numeric vector at the median
#' @inheritParams purrr::partial
#' @inheritParams cln_split_quantile
#'
#' @returns a splited vector the same length as `x`
# #' @importFrom purrr partial
#' @export
#'
#' @examples
#' # split at the median
#' cln_split_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#' # Default with na.rm = FALSE
#' \dontrun{
#' cln_split_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
#' }
cln_split_median <- purrr::partial(cln_split_quantile, probs = c(0, 0.5, 1), labels = c("low", "high"))

## ****************************************************************************
#' Classify a numeric vector at the median
#'
#' Classify a numeric vector at the median
#' @inheritParams cln_split_quantile
#'
#' @returns a vector the same length as x, with the 2 corresponding categories for a split at the median.
# #' @importFrom stats quantile
#' @export
#'
#' @examples
#' # split at the median
#' cln_classify_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#' # Default with na.rm = FALSE
#' \dontrun{
#' cln_classify_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
#' }
cln_classify_median <- function(x, labels = c("low", "high"), na.rm = TRUE) {
  cln_split_quantile(x = x, labels = labels, probs = c(0:2/2), na.rm = na.rm)
}

## ****************************************************************************
#' Classify a numeric vector in terciles
#'
#' Classify a numeric vector in tercile categories
#' @inheritParams cln_split_quantile
#'
#' @returns a vector the same length as x, with the 3 corresponding tercile categories.
# #' @importFrom stats quantile
#' @export
#'
#' @examples
#' # classify in terciles
#' cln_classify_tercile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#' # Default with na.rm = FALSE
#' \dontrun{
#' cln_classify_tercile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
#' }
cln_classify_tercile <- function(x, labels = c("low", "medium", "high"), na.rm = TRUE) {
  # if (!is.numeric(x)) {
  #   stop("x argument has to be numeric for the classification")
  # }
  # tertile_quantiles = quantile(x, c(0:3/3), na.rm = TRUE)
  # cut(x,
  #     tertile_quantiles,
  #     include.lowest = T,
  #     labels = labels)
  ## maj 2024-03-27: utilisation de la fonction générale: cln_split_quantile
  cln_split_quantile(x = x, labels = labels, probs = c(0:3/3), na.rm = na.rm)
}

## ****************************************************************************
#' Classify a numeric vector in quartiles
#'
#' Classify a numeric vector in quartile categories
#' @inheritParams cln_split_quantile
#'
#' @returns a vector the same length as x, with the 4 corresponding quartile categories.
# #' @importFrom stats quantile
#' @export
#'
#' @examples
#' # classify in quartiles
#' cln_classify_quartile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#' # Default with na.rm = FALSE
#' \dontrun{
#' cln_classify_quartile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
#' }
cln_classify_quartile <- function(x, labels = c("Q1", "Q2", "Q3", "Q4"), na.rm = TRUE) {
  cln_split_quantile(x = x, labels = labels, probs = c(0:4/4), na.rm = na.rm)
}


## ****************************************************************************
## maj 2024-03-26: déplacement dans le fichier `recode.R` du package `cleanser`
## fonction initialement placée dans le package `medikit` sous le nom `med_convert_linear`
## Applique un Facteur de Conversion (FC):
## la relation est inversée si argument `inverse = TRUE`
#' General unit conversion function
#'
#' Transforms a vector into a same length vector after applying a conversion factor (CF)
#' the relation can be inverted with argument `inverse = TRUE`
#' @param x a numeric vector
#' @param CF a numeric constant conversion factor
#' @param inverse does the conversion factor should be used to invert the direction of the conversion ?
#'
#' @returns a converted vector the same length as `x`
#' @export
#'
#' @examples
#' # convert a human size from meters to cm
#' cln_convert_linear(c(1.50, 1.82, NA_real_), CF = 100)
cln_convert_linear <- function(x, CF, inverse = FALSE) {
  if (!is.numeric(x)) {
    stop("x has to be numeric to be converted")
  }
  if (!is.numeric(CF)) {
    stop("CF has to be numeric to be converted")
  }
  if (isTRUE(inverse)) {
    x / CF
  } else {
    x * CF
  }
}

## ****************************************************************************
## Calculs sur logical
## ****************************************************************************

## ****************************************************************************
## Composition de la fonction logique OR
# ## Fonction qui peut prendre un nombre indéfini d'arguments en entrée
# cln_compose_logical_or <- function(...) {
#   purrr::reduce(.x = list(...), .f = `|`)
# }
# # cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE))
# # cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA))
# # cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), c(NA, F, T, F, F))

# cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), c(NA, F, T, F, F))
#' Compute the OR logical composition of any number of vectors
#'
#' Fonction obtenue à partir de \code{base::Reduce} (pas d'appel à des libraries extérieures)
#' elle est compatible tidyverse...
#' @param ... raw, logical or ‘number-like’ vectors (i.e., of types double (class numeric), integer and complex), or objects for which methods have been written. <tidy-select> compatible: One or more unquoted expressions separated by commas. Variable names can be used as if they were positions in the data frame, so expressions like x:y can be used to select a range of variables.
#' @returns A logical or raw vector of the same length as \code{...} If involving a zero-length vector the result has length zero. Otherwise, the elements of shorter vectors are recycled as necessary (with a warning when they are recycled only fractionally). The rules for determining the attributes of the result are rather complicated. Most attributes are taken from the longer argument, the first if they are of the same length. Names will be copied from the first if it is the same length as the answer, otherwise from the second if that is. For time series, these operations are allowed only if the series are compatible, when the class and tsp attribute of whichever is a time series (the same, if both are) are used. For arrays (and an array result) the dimensions and dimnames are taken from first argument if it is an array, otherwise the second.
#' Numeric and complex vectors will be coerced to logical values, with zero being false and all non-zero values being true. Raw vectors are handled without any coercion for !, &, | and xor, with these operators being applied bitwise (so ! is the 1s-complement).
#' @export
#'
#' @examples
#' cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(0, 1, FALSE, TRUE, NA))
#' \dontrun{
#' cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE))
#' cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), c(NA, F, T, F, F))
#' cln_compose_logical_or(c("a", 1, FALSE, TRUE, NA))
#' }
cln_compose_logical_or <- function(...) {
  base::Reduce(f = base::`|`, x = base::list(...), init = FALSE) # le default init = FALSE permet une vérification automatique des types d'entrée compatibles
}

# compute_composite_logical <- function(..., f = c("|", "&")) {
# # cln_compose_logical_or <- function(..., f = c(`|`, `&`)) {
#   # f <- match.arg(f)
#   base::Reduce(f = match.arg(f), x = base::list(...))
#   # base::Reduce(f = match.fun(f), x = base::list(...))
# }
# cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE))
# compute_composite_logical(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), f = c("&"))
# cln_compose_logical_or(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), f = `&`)

#' Compute the AND logical composition of any number of vectors
#'
#' Fonction obtenue à partir de \code{base::Reduce} (pas d'appel à des libraries extérieures)
#' elle est compatible tidyverse...
#' @param ... raw, logical or ‘number-like’ vectors (i.e., of types double (class numeric), integer and complex), or objects for which methods have been written. <tidy-select> compatible: One or more unquoted expressions separated by commas. Variable names can be used as if they were positions in the data frame, so expressions like x:y can be used to select a range of variables.
#' @returns A logical or raw vector of the same length as \code{...} If involving a zero-length vector the result has length zero. Otherwise, the elements of shorter vectors are recycled as necessary (with a warning when they are recycled only fractionally). The rules for determining the attributes of the result are rather complicated. Most attributes are taken from the longer argument, the first if they are of the same length. Names will be copied from the first if it is the same length as the answer, otherwise from the second if that is. For time series, these operations are allowed only if the series are compatible, when the class and tsp attribute of whichever is a time series (the same, if both are) are used. For arrays (and an array result) the dimensions and dimnames are taken from first argument if it is an array, otherwise the second.
#' Numeric and complex vectors will be coerced to logical values, with zero being false and all non-zero values being true. Raw vectors are handled without any coercion for !, &, | and xor, with these operators being applied bitwise (so ! is the 1s-complement).
#' @export
#'
#' @examples
#' cln_compose_logical_and(c(0, 1, FALSE, TRUE, NA), c(0, 1, FALSE, TRUE, NA))
# #' \dontrun{
#' try(cln_compose_logical_and(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE)))
#' try(cln_compose_logical_and(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), c(NA, F, T, F, F)))
#' try(cln_compose_logical_and(c("a", 1, FALSE, TRUE, NA)))
# #' }
cln_compose_logical_and <- function(...) {
  base::Reduce(f = base::`&`, x = base::list(...), init = TRUE) # le default init = TRUE permet une vérification automatique des types d'entrée compatibles
}

## ****************************************************************************
## Repère les lignes qui contiennent les valeurs manquantes pour un jeu de variable donné
## La fonction is_na_component prend les même arguments que le score créé par
## cln_compute_composite_score ou bien cln_compose_logical_or au sein de l'ellipse
## et retourne un vecteur de logical indiquant si une observation contient une (ou plusieurs) NA
#' Computes the number of NAs per row in a set of columns
#'
#' Computes the number of NAs per row in a set of columns.
#' @param ... ellipsis to allow for an undefinied number of vectors to add
#'
#' @returns data with the same properties as the input data, with the columns having all the levels specified in the `levels` argument recoded
#' @export
#'
#' @examples
#' expand.grid(
#'   g = c(NA_real_, 0, NA_real_),
#'   ptc = c(NA_real_, 0, 1)
#' ) %>%
#'   dplyr::mutate(na_score = cln_compute_na_score(g, ptc)) %>%
#'   dplyr::arrange(g, ptc)
cln_compute_na_score <- function(...) {
  args <- list(...) %>%
    lapply(as.character) %>%
    as.data.frame()
  rowSums(x = is.na(args), na.rm = FALSE) != 0
}

