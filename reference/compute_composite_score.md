# Computes a composite score

Computes a composite score

## Usage

``` r
compute_composite_score(
  ...,
  na.rm = FALSE,
  score_fun = c("rowMeans", "rowSums")
)
```

## Arguments

- ...:

  ellipsis to allow for an undefinied number of vectors to add

- na.rm:

  logical. Should missing values (including `NaN`) be omitted from the
  calculations?

- score_fun:

  matching function used to compute the score: either rowMeans or
  rowSums.

## Value

data with the same properties as the input data, with the columns having
all the levels specified in the `levels` argument recoded

## Examples

``` r
expand.grid(
  g = c(NA_real_, 0, NA_real_),
  ptc = c(NA_real_, 0, 1)
) %>%
  dplyr::mutate(is_na_score = compute_composite_score(g, ptc, na.rm = TRUE),
    score_fun = "rowSums") %>%
  dplyr::arrange(g, ptc)
#>    g ptc is_na_score score_fun
#> 1  0   0         0.0   rowSums
#> 2  0   1         0.5   rowSums
#> 3  0  NA         0.0   rowSums
#> 4 NA   0         0.0   rowSums
#> 5 NA   0         0.0   rowSums
#> 6 NA   1         1.0   rowSums
#> 7 NA   1         1.0   rowSums
#> 8 NA  NA         NaN   rowSums
#> 9 NA  NA         NaN   rowSums
```
