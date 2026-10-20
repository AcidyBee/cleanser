# Classify a numeric vector in quantiles

Classify a numeric vector in quantiles. Default is quartile through
argument `probs = seq(0, 1, 0.25)`.

## Usage

``` r
split_quantile(
  x,
  labels = NULL,
  probs = seq(0, 1, 0.25),
  na.rm = FALSE,
  names = TRUE,
  type = 7,
  ...
)
```

## Arguments

- x:

  a numeric vector which is to be converted to a factor by cutting.

- labels:

  labels for the levels of the resulting category. By default, labels
  are constructed using `"(a,b]"` interval notation. If
  `labels = FALSE`, simple integer codes are returned instead of a
  factor.

- probs:

  numeric vector of probabilities with values in \\\[0,1\]\\. (Values up
  to `2e-14` outside that range are accepted and moved to the nearby
  endpoint.)

- na.rm:

  logical; if true, any [`NA`](https://rdrr.io/r/base/NA.html) and
  `NaN`'s are removed from `x` before the quantiles are computed.

- names:

  logical; if true, the result has a
  [`names`](https://rdrr.io/r/base/names.html) attribute. Set to `FALSE`
  for speedup with many `probs`.

- type:

  an integer between 1 and 9 selecting one of the nine quantile
  algorithms detailed below to be used.

- ...:

  further arguments passed to or from other methods.

## Value

a vector the same length as x, with the 3 corresponding tercile
categories.

## Examples

``` r
# Default quartile classification
split_quantile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#>  [1] (14,19]    (14,19]    (14,19]    (19,33.5]  (19,33.5]  (33.5,108]
#>  [7] (33.5,108] [3,14]     [3,14]     [3,14]     (33.5,108]
#> Levels: [3,14] (14,19] (19,33.5] (33.5,108]
# Default with na.rm = FALSE
if (FALSE) { # \dontrun{
split_quantile(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
} # }
```
