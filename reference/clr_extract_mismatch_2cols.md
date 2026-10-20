# Extract Rows that Do Not Match for a 2 Columns Comparison

Extract rows that do not match for a 2 columns comparison.

## Usage

``` r
clr_extract_mismatch_2cols(data, x, y, id_cols = NULL)
```

## Arguments

- data:

  input dataset.

- x, y:

  the 2 variables to compare.

- id_cols:

  A set of columns that uniquely identify each observation. Typically
  used when you have to detect rows that don't behave as expected.

## Value

The rows from the input dataset that have no other levels than the ones
specified in the `levels` argument, but with case issues.

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
 clr_extract_mismatch_2cols(DB, case, id_cols = "id")
#>   id  DB case
#> 1  1 oui  OUI
#> 2  2 non  Non
```
