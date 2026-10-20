# Keep instant columns of a dataset

Keep instant columns of a dataset. Makes use of
`is.instant <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))`
of `lubridate` package.

## Usage

``` r
keep_col_instant(data)
```

## Arguments

- data:

  input dataset

## Value

A selection of columns from the input dataset that have an instant
format, as intended in
[`lubridate::is.instant()`](https://lubridate.tidyverse.org/reference/is.instant.html).

## Examples

``` r
# keep only instant columns
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 factor = c("non", "oui"),
 na_col = rep(NA_real_, times = 2),
 date = lubridate::make_date(year = c(2019L, 2021L))
) %>%
 keep_col_instant()
#> date 
#> TRUE 
```
