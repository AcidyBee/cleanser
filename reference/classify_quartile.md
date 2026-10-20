# Classify a numeric vector in quartiles

Classify a numeric vector in quartile categories

## Usage

``` r
classify_quartile(x, labels = c("Q1", "Q2", "Q3", "Q4"), na.rm = TRUE)
```

## Arguments

- x:

  a numeric vector which is to be converted to a factor by cutting.

- labels:

  labels for the levels of the resulting category. By default, labels
  are constructed using `"(a,b]"` interval notation. If
  `labels = FALSE`, simple integer codes are returned instead of a
  factor.

- na.rm:

  logical; if true, any [`NA`](https://rdrr.io/r/base/NA.html) and
  `NaN`'s are removed from `x` before the quantiles are computed.

## Value

a vector the same length as x, with the 4 corresponding quartile
categories.

## Examples

``` r
# classify in quartiles
classify_quartile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#>  [1] Q2 Q2 Q2 Q3 Q3 Q4 Q4 Q1 Q1 Q1 Q4
#> Levels: Q1 Q2 Q3 Q4
# Default with na.rm = FALSE
if (FALSE) { # \dontrun{
classify_quartile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
} # }
```
