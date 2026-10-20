# cleanser

The goal of cleanser is to gather a Set of Utility Functions to Check,
Clean and Prepare a dataset

## Installation

This package is not available on CRAN, to install it please use the
following commands:

From GitHub:

``` r

remotes::install_github("AcidyBee/cleanser")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r

library(cleanser)
## basic example code
```

Computes a composite score on 2 columns:

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
