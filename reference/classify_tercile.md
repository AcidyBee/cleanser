# Classify a numeric vector in terciles

Classify a numeric vector in tercile categories

## Usage

``` r
classify_tercile(x, labels = c("low", "medium", "high"), na.rm = TRUE)
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

a vector the same length as x, with the 3 corresponding tercile
categories.

## Examples

``` r
# classify in terciles
classify_tercile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#>  [1] low    medium medium medium high   high   high   low    low    low   
#> [11] high  
#> Levels: low medium high
# Default with na.rm = FALSE
if (FALSE) { # \dontrun{
classify_tercile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
} # }
```
