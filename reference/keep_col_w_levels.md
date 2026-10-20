# Keep columns with specific levels

Keep columns with specific levels

## Usage

``` r
keep_col_w_levels(
  data,
  levels,
  ignore_case = FALSE,
  id_cols = NULL,
  fun = c("all", "any")
)
```

## Arguments

- data:

  input dataset.

- levels:

  Complete set of specific levels seeked for the variables.

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

A dataset with the same number of lines than the input dataset, keeping
only the columns corresponding to the criterion.

## Examples

``` r
# keep only columns with specific levels
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 factor = c("non", "oui"),
 na_col = rep(NA_real_, times = 2),
 date = lubridate::make_date(year = c(2019L, 2021L))
) %>%
 keep_col_w_levels(c("non", "oui"))
#>   factor
#> 1    non
#> 2    oui
```
