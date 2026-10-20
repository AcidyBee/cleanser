# Discard dummy columns

Discard dummy columns

## Usage

``` r
discard_col_dummy(data)
```

## Arguments

- data:

  entry dataset

## Value

A selection of the columns from the input dataset that are not dummy.

## Examples

``` r
# keep only dummy columns
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 na_col = rep(NA_real_, times = 2)
) %>%
 discard_col_dummy()
#>   num char na_col
#> 1   1    a     NA
#> 2   2 <NA>     NA
```
