# Discard columns with a strict numeric format

Discard columns with a strict numeric format

## Usage

``` r
discard_col_numeric(data)
```

## Arguments

- data:

  input dataset

## Value

A selection of columns from the input dataset that have a strict numeric
format, as intended in
[`has_strict_numeric_format()`](https://acidybee.github.io/cleanser/reference/has_strict_numeric_format.md).

## Examples

``` r
# discard only numeric columns
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 factor = c("non", "oui"),
 na_col = rep(NA_real_, times = 2),
 date = lubridate::make_date(year = c(2019L, 2021L))
) %>%
 discard_col_numeric()
#>   char factor na_col   date 
#>  FALSE  FALSE  FALSE  FALSE 
```
