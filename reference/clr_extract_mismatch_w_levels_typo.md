# Extract rows that have typo issues with the set of levels

Extract rows that have typo issues with the set of levels.

## Usage

``` r
clr_extract_mismatch_w_levels_typo(data, levels, id_cols = NULL)
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

The rows from the input dataset that have at least the levels like the
ones specified in the `levels` argument, but with additional levels
which may be typo issues.

## Examples

``` r
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
 clr_extract_mismatch_w_levels_typo(levels = c("non", "oui"))
#>   typo
#> 1  pui
```
