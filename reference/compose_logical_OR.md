# Compute the OR logical composition of any number of vectors

Fonction obtenue à partir de
[`base::Reduce`](https://rdrr.io/r/base/funprog.html) (pas d'appel à des
libraries extérieures) elle est compatible tidyverse...

## Usage

``` r
compose_logical_OR(...)
```

## Arguments

- ...:

  raw, logical or ‘number-like’ vectors (i.e., of types double (class
  numeric), integer and complex), or objects for which methods have been
  written. compatible: One or more unquoted expressions separated by
  commas. Variable names can be used as if they were positions in the
  data frame, so expressions like x:y can be used to select a range of
  variables.

## Value

A logical or raw vector of the same length as `...` If involving a
zero-length vector the result has length zero. Otherwise, the elements
of shorter vectors are recycled as necessary (with a warning when they
are recycled only fractionally). The rules for determining the
attributes of the result are rather complicated. Most attributes are
taken from the longer argument, the first if they are of the same
length. Names will be copied from the first if it is the same length as
the answer, otherwise from the second if that is. For time series, these
operations are allowed only if the series are compatible, when the class
and tsp attribute of whichever is a time series (the same, if both are)
are used. For arrays (and an array result) the dimensions and dimnames
are taken from first argument if it is an array, otherwise the second.
Numeric and complex vectors will be coerced to logical values, with zero
being false and all non-zero values being true. Raw vectors are handled
without any coercion for !, &, \| and xor, with these operators being
applied bitwise (so ! is the 1s-complement).

## Examples

``` r
compose_logical_OR(c(0, 1, FALSE, TRUE, NA), c(0, 1, FALSE, TRUE, NA))
#> [1] FALSE  TRUE FALSE  TRUE    NA
if (FALSE) { # \dontrun{
compose_logical_OR(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE))
compose_logical_OR(c(0, 1, FALSE, TRUE, NA), c(F, T, F, FALSE, TRUE), c(NA, F, T, F, F))
compose_logical_OR(c("a", 1, FALSE, TRUE, NA))
} # }
```
