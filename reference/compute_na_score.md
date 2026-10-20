# Computes the number of NAs per row in a set of columns

Computes the number of NAs per row in a set of columns.

## Usage

``` r
compute_na_score(...)
```

## Arguments

- ...:

  ellipsis to allow for an undefinied number of vectors to add

## Value

data with the same properties as the input data, with the columns having
all the levels specified in the `levels` argument recoded

## Examples

``` r
expand.grid(
  g = c(NA_real_, 0, NA_real_),
  ptc = c(NA_real_, 0, 1)
) %>%
  dplyr::mutate(na_score = compute_na_score(g, ptc)) %>%
  dplyr::arrange(g, ptc)
#>    g ptc na_score
#> 1  0   0    FALSE
#> 2  0   1    FALSE
#> 3  0  NA     TRUE
#> 4 NA   0     TRUE
#> 5 NA   0     TRUE
#> 6 NA   1     TRUE
#> 7 NA   1     TRUE
#> 8 NA  NA     TRUE
#> 9 NA  NA     TRUE
```
