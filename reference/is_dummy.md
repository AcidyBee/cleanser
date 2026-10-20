# Check if a vector is only dummy elements (i.e. 0/1)

Check if a vector is only dummy elements (i.e. 0/1). This function has 2
direct applications on data structures in the package:

1.  spot dummy columns using data %\>% purrr::keep(\\x) is_dummy(x))
    %\>% names()

2.  it could be used to select only dummy columns in a dataset (see
    exemples)

## Usage

``` r
is_dummy(x)
```

## Arguments

- x:

  a vector of any type. `x` has his NA elements discarded before it is
  coerced to a character vector. To check if the vector is made only of
  "0" & "1". Logical TRUE/FALSE vectors are not coerced to 0 or 1 (which
  is the expected behavior).

## Value

a logical indicating if the input vector is dummy.

## Examples

``` r
c(1, 7, NA_real_) %>%
  is_dummy()
#> [1] FALSE
c(0, 1, NA_real_) %>%
  is_dummy()
#> [1] TRUE
# keep only dummy columns names
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 na_col = rep(NA_real_, times = 2)
) %>%
 purrr::keep(\(x) is_dummy(x)) %>%
 names()
#> [1] "dummy"
# keep only numeric columns that are not dummy
data.frame(
 num = c(1, 2),
 dummy = c(1, 0),
 char = c("a", NA_character_),
 na_col = rep(NA_real_, times = 2)
) %>%
 dplyr::select(dplyr::where(is.numeric)) %>%
 dplyr::select(!dplyr::where(is_dummy))
#>   num na_col
#> 1   1     NA
#> 2   2     NA
```
