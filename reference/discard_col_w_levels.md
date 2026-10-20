# Discard columns having specific modalities

Discard columns having a specific set of levels

## Usage

``` r
discard_col_w_levels(
  data,
  levels,
  ignore_case = FALSE,
  id_cols = NULL,
  fun = c("all", "any")
)
```

## Arguments

- data:

  entry dataset

- levels:

  complete set of specific levels seeked for the variables

- ignore_case:

  Should case differences be ignored in the match? For fixed(), this
  uses a simple algorithm which assumes a one-to-one mapping between
  upper and lower case letters.

- id_cols:

  A set of columns that uniquely identify each observation. Typically
  used when you have to detect rows that don't behave as expected.

- fun:

  matching function used to match the levels seeked.

## Value

A selection of columns from the input dataset that have no other levels
than the ones specified in the `levels` argument

## Examples

``` r
# Discard dummy columns
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 factor = c("non", "oui"),
 na_col = rep(NA_real_, times = 2)
) %>%
 discard_col_w_levels(levels = c("non", "oui"))
#>   num dummy char
#> 1   1     1    a
#> 2   2     0 <NA>
```
