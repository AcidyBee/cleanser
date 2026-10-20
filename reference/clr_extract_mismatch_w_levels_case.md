# Extract rows that have case issues with the set of levels

Extract rows that have case issues with the set of levels.

## Usage

``` r
clr_extract_mismatch_w_levels_case(data, levels, id_cols = NULL)
```

## Arguments

- data:

  entry dataset

- levels:

  complete set of specific levels seeked for the variables

- id_cols:

  A set of columns that uniquely identify each observation. Typically
  used when you have to detect rows that don't behave as expected.

## Value

The rows from the input dataset that have no other levels than the ones
specified in the `levels` argument, but with case issues.

## Examples

``` r
data_ex <- data.frame(
  id = 1:4,
  dummy = c(0, 0, 1, 1),
  DB = c("oui", "non", "non", "oui"),
  typo = c("oui", "non", "non", "pui"),
  case = c("OUI", "non", "Non", "oui"),
  sexe = c("F", "H", "F", "H"),
  regex_spec = c("+", "-", "-", "+"),
  DB_w_na = c("oui", "non", "non", NA_character_),
  na_only = rep(NA_character_, times = 4)
)
data_ex %>%
 clr_extract_mismatch_w_levels_case(levels = c("non", "oui"))
#>   row_number case
#> 1          1  OUI
#> 2          3  Non
data_ex %>%
 clr_extract_mismatch_w_levels_case(levels = c("non", "oui"), id_cols = "id")
#>   id case
#> 1  1  OUI
#> 2  3  Non
data_ex %>%
dplyr::select(-case) %>%
 clr_extract_mismatch_w_levels_case(levels = c("non", "oui"), id_cols = "id")
#> No case issues detected for levels: (non, oui)
```
