# Keep dummy columns

Keep dummy columns

## Usage

``` r
keep_col_dummy(data)
```

## Arguments

- data:

  entry dataset

## Value

A selection of the dummy columns from the input dataset.

## Examples

``` r
# keep only dummy columns
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 factor = c("non", "oui"),
 na_col = rep(NA_real_, times = 2)
) %>%
 keep_col_dummy()
#>   dummy
#> 1     1
#> 2     0
```
