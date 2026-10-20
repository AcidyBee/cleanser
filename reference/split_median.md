# Split a numeric vector at the median

Split a numeric vector at the median

## Usage

``` r
split_median(...)
```

## Arguments

- ...:

  named arguments to `.f` that should be partially applied.

  Pass an empty `... = ` argument to specify the position of future
  arguments relative to partialised ones. See
  [`rlang::call_modify()`](https://rlang.r-lib.org/reference/call_modify.html)
  to learn more about this syntax.

  These dots support quasiquotation. If you unquote a value, it is
  evaluated only once at function creation time. Otherwise, it is
  evaluated each time the function is called.

## Value

a splited vector the same length as `x`

## Examples

``` r
# split at the median
split_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108))
#>  [1] low  low  low  high high high high low  low  low  high
#> Levels: low high
# Default with na.rm = FALSE
if (FALSE) { # \dontrun{
split_median(c(16, 18, 19, 26, 31, 36, 41, 12, 5, 3, 108, NA_real_))
} # }
```
