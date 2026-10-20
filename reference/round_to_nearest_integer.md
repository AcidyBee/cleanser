# Round to nearest integer

Round to nearest integer

## Usage

``` r
round_to_nearest_integer(x)
```

## Arguments

- x:

  a numeric vector.

## Value

a vector the same length as x, rounded and converted to the nearest
integer.

## Examples

``` r
# Round to nearest integer:
round_to_nearest_integer(c(1.0, 2.1, 2.7, 5.7, NA_real_, NA))
#> [1]  1  2  3  6 NA NA
```
