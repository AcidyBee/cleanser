# Check if data are shared across rows of a set of columns

Check if data are shared across rows of a set of columns. This is
especially useful for SAP datasets where duplicated columns can hold the
same information but each corresponds to a specific time span.

Check if data are shared across rows of a set of columns. This is
especially useful for SAP datasets where duplicated columns can hold the
same information but each corresponds to a specific time span.

## Usage

``` r
is_shared_values_across_rows(.data, ...)

is_shared_values_across_rows(.data, ...)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  One or more unquoted expressions separated by commas. Variable names
  can be used as if they were positions in the data frame, so
  expressions like `x:y` can be used to select a range of variables.

## Value

a dataset with the same number of rows as the imput data, but without
the empty columns that were discarded.

a dataset with the same number of rows as the imput data, but without
the empty columns that were discarded.

## Examples

``` r
data.frame(
  ischemie_froide.1 = c(NA_real_, NA_real_, 720, 780),
  ischemie_froide.2 = c(720, 780, NA_real_, NA_real_)
) %>%
  is_shared_values_across_rows(dplyr::matches("^ischemie_froide"))
#> [1] FALSE
data.frame(
  ischemie_froide.1 = c(NA_real_, NA_real_, 720, 780),
  ischemie_froide.2 = c(720, 780, NA_real_, NA_real_)
) %>%
  is_shared_values_across_rows(dplyr::matches("^ischemie_froide"))
#> [1] FALSE
```
