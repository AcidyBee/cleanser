# Discard instant columns of a dataset

Discard instant columns of a dataset. Makes use of
`is.instant <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))`
of `lubridate` package.

## Usage

``` r
discard_col_instant(data)
```

## Arguments

- data:

  input dataset

## Value

A selection of columns from the input dataset that do not have an
instant format, as intended in
[`lubridate::is.instant()`](https://lubridate.tidyverse.org/reference/is.instant.html).

## Examples

``` r
# discard instant columns
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 factor = c("non", "oui"),
 na_col = rep(NA_real_, times = 2),
 date = lubridate::make_date(year = c(2019L, 2021L))
) %>%
 discard_col_instant()
#>    num  dummy   char factor na_col 
#>  FALSE  FALSE  FALSE  FALSE  FALSE 
```
