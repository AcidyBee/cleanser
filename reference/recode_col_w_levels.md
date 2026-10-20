# Recode columns having specific modalities

Spot columns having a specific set of levels using `keep_col_w_levels`,
and recode them using the order of the levels in the levels argument.

## Usage

``` r
recode_col_w_levels(data, levels, labels = levels, ignore_case = FALSE)
```

## Arguments

- data:

  input dataset

- levels:

  complete set of specific levels seeked for the variables

- labels:

  *either* an optional character vector of labels for the levels (in the
  same order as `levels` after removing those in `exclude`), *or* a
  character string of length 1. Duplicated values in `labels` can be
  used to map different values of `x` to the same factor level.

- ignore_case:

  Should case differences be ignored in the match? For fixed(), this
  uses a simple algorithm which assumes a one-to-one mapping between
  upper and lower case letters.

## Value

data with the same properties as the input data, with the columns having
all the levels specified in the `levels` argument recoded

## Examples

``` r
data.frame(
x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
y = c("N", "O", "Non", "Oui", "Oui", NA_character_),
z = c("Non", "Oui", "Non", "Oui", "+", NA_character_)
) %>%
  recode_col_w_levels(levels = c("Non", "Oui"))
#>      x    y    z
#> 1  Non    N  Non
#> 2  Oui    O  Oui
#> 3  Non  Non  Non
#> 4  Oui  Oui  Oui
#> 5  Oui  Oui    +
#> 6 <NA> <NA> <NA>
data.frame(
x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
y = c("N", "O", "Non", "Oui", "Oui", NA_character_),
z = c("Non", "Oui", "Non", "Oui", "+", NA_character_)
) %>%
  recode_col_w_levels(levels = c("Non", "Oui"), labels = c("N", "O"))
#>      x    y    z
#> 1    N    N  Non
#> 2    O    O  Oui
#> 3    N  Non  Non
#> 4    O  Oui  Oui
#> 5    O  Oui    +
#> 6 <NA> <NA> <NA>
# Recode the dataset even for columns with case issues in the factors
data.frame(
  id = 1:4,
  dummy = c(0, 0, 1, 1),
  DB = c("oui", "non", "non", "oui"),
  typo = c("oui", "non", "non", "pui"),
  case = c("OUI", "Non", "non", "oui"),
  sexe = c("F", "H", "F", "H"),
  regex_spec = c("+", "-", "-", "+"),
  DB_w_na = c("oui", "non", "non", NA_character_),
  na_only = rep(NA_character_, times = 4)
) %>%
recode_col_w_levels(levels = c("non", "oui"), ignore_case = TRUE)
#>   id dummy  DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0 oui  oui  oui    F          +     oui    <NA>
#> 2  2     0 non  non  non    H          -     non    <NA>
#> 3  3     1 non  non  non    F          -     non    <NA>
#> 4  4     1 oui  pui  oui    H          +    <NA>    <NA>
if (FALSE) { # \dontrun{
recoded_data <- recode_col_w_levels(data, levels = c("non", "oui"))
recode_col_N_O <- partial(.f = recode_col_w_levels, levels = c("N", "O"))
} # }
```
