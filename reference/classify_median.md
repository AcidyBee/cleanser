# Classify a numeric vector at the median

Classify a numeric vector at the median

## Usage

``` r
classify_median(x, labels = c("low", "high"), na.rm = TRUE)
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

a vector the same length as x, with the 2 corresponding categories for a
split at the median.

## Examples

``` r
# split at the median
classify_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#>  [1] low  low  low  high high high high low  low  low  high
#> Levels: low high
# Default with na.rm = FALSE
if (FALSE) { # \dontrun{
classify_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
} # }
```
