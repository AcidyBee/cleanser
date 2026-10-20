# General unit conversion function

Transforms a vector into a same length vector after applying a
conversion factor (CF) the relation can be inverted with argument
`inverse = TRUE`

## Usage

``` r
convert_linear(x, CF, inverse = FALSE)
```

## Arguments

- x:

  a numeric vector

- CF:

  a numeric constant conversion factor

- inverse:

  does the conversion factor should be used to invert the direction of
  the conversion ?

## Value

a converted vector the same length as `x`

## Examples

``` r
# convert a human size from meters to cm
convert_linear(c(1.50, 1.82, NA_real_), CF = 100)
#> [1] 150 182  NA
```
