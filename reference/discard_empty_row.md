# Discard empty rows

Discard empty rows for a subset of columns which defaults to
everything() (i.e. the whole dataset); but which can be restricted to a
subset of columns.

## Usage

``` r
discard_empty_row(data, .cols = dplyr::everything())
```

## Arguments

- data:

  A dataset where empty rows are to be identified

- .cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to transform. You can't select grouping columns because they
  are already automatically handled by the verb (i.e.
  [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  or [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)).

## Value

a data frame with the same number of columns as the imput data, but
without the empty rows that were discarded.

## Examples

``` r
data <- data.frame(
  id = 1:4,
  a = c(1, 2, NA_real_, 4),
  b = c("a", "b", NA_character_, "d")
  )
# discard empty row for the whole data
discard_empty_row(data)
#>   id  a    b
#> 1  1  1    a
#> 2  2  2    b
#> 3  3 NA <NA>
#> 4  4  4    d
# discard empty row for a subset of columns a & b
discard_empty_row(data, .cols = c(a, b))
#>   id a b
#> 1  1 1 a
#> 2  2 2 b
#> 4  4 4 d
```
