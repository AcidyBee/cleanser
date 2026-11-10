# Discard empty columns

Discard empty columns

## Usage

``` r
cln_discard_col_empty(data)
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
  cln_discard_col_empty()
} # }
```
