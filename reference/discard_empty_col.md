# Discard empty columns

Discard empty columns

## Usage

``` r
discard_empty_col(data)
```

## Arguments

- data:

  A dataset where empty columns are to be discarded

## Value

a data frame with the same number of rows as the imput data, but without
the empty columns that were discarded.

## Examples

``` r
if (FALSE) { # \dontrun{
data_D_raw %>%
  discard_empty_col()
} # }
```
