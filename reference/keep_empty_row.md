# Keep empty rows

Keep empty rows for a subset of columns which defaults to everything()
(i.e. the whole dataset); but which can be restricted to a subset of
columns.

## Usage

``` r
keep_empty_row(data, .cols = dplyr::everything())
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
keeping only the empty rows that were spoted.

## Examples

``` r
data <- data.frame(
  id = 1:4,
  a = c(1, 2, NA_real_, 4),
  b = c("a", "b", NA_character_, "d")
  )
# keep empty row for the whole data
keep_empty_row(data)
#> [1] id a  b 
#> <0 rows> (or 0-length row.names)
# keep empty row for a subset of columns a & b
keep_empty_row(data, .cols = c(a, b))
#>   id  a    b
#> 3  3 NA <NA>
```
