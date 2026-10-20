# Spot empty rows

Spot empty rows in a dataset. The default spot empty rows for the whole
datasets

## Usage

``` r
is_empty_row(data, .cols = dplyr::everything())
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

a data logical vector with the same number of rows as the imput data.

## Examples

``` r
data <- data.frame(
  id = 1:4,
  a = c(1, 2, NA_real_, 4),
  b = c("a", "b", NA_character_, "d")
  )
# is there an empty row for the whole data
is_empty_row(data)
#> [1] FALSE FALSE FALSE FALSE
# discard empty row for the whole data
data[!is_empty_row(data), ]
#>   id  a    b
#> 1  1  1    a
#> 2  2  2    b
#> 3  3 NA <NA>
#> 4  4  4    d
# is there an empty row for a subset of columns a & b
is_empty_row(data, .cols = c(a, b))
#> [1] FALSE FALSE  TRUE FALSE
# keep empty rows for a subset of columns a & b
data[is_empty_row(data, .cols = c(a, b)), ]
#>   id  a    b
#> 3  3 NA <NA>
# keep only the non-empty rows
data[!is_empty_row(data, .cols = c(a, b)), ]
#>   id a b
#> 1  1 1 a
#> 2  2 2 b
#> 4  4 4 d
```
