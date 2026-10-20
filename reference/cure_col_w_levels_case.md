# Cure columns with case issues for specific factor levels

Cure columns with case issues for specific factor levels

## Usage

``` r
cure_col_w_levels_case(data, levels)
```

## Arguments

- data:

  input dataset.

- levels:

  Complete set of specific levels seeked for the variables.

## Value

A dataset with the same number of columns than the input dataset, with
the columns corresponding to the criterion cured from any case issue.

## Examples

``` r
# Cure case issues in the variables
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
cure_col_w_levels_case(levels = c("non", "oui"))
#>   id dummy  DB typo case sexe regex_spec DB_w_na na_only
#> 1  1     0 oui  oui  oui    F          +     oui    <NA>
#> 2  2     0 non  non  non    H          -     non    <NA>
#> 3  3     1 non  non  non    F          -     non    <NA>
#> 4  4     1 oui  pui  oui    H          +    <NA>    <NA>
```
