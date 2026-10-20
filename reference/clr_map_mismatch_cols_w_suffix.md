# Extract Rows that Do Not Match for a 2 Columns Comparison

Extract rows that do not match for a 2 columns comparison.

## Usage

``` r
clr_map_mismatch_cols_w_suffix(data, suffix = c(".x", ".y"), id_cols = NULL)
```

## Arguments

- data:

  input dataset.

- suffix:

  If there are non-joined duplicate variables in `x` and `y`, these
  suffixes will be added to the output to disambiguate them. Should be a
  character vector of length 2.

- id_cols:

  A set of columns that uniquely identify each observation. Typically
  used when you have to detect rows that don't behave as expected.

## Value

A list of datasets for each comparison of suffixed variables detected.

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
