# Check if a vector is only NA elements

Check if a vector is only NA elements. This function has 2 direct
applications on data structures in the package:

1.  spot empty columns using data %\>% purrr::keep(\\x)
    cln_is_only_na(x)) %\>% names() 1.b it could be used in function
    `cln_discard_col_empty`, even though it is not the case yet

2.  get an accurate result when spoting col types, like for instance in
    the `cln_keep_col_numeric` function: columns with only NA will
    otherwise return o positive result...

## Usage

``` r
cln_is_only_na(x)
```

## Arguments

- x:

  a vector of any type

## Value

a logical indicating if there is only NA in the input vector.

## Examples

``` r
c(1, 7, NA_real_) %>%
  cln_is_only_na()
#> [1] FALSE
c(NA_real_, NA_real_, NA_real_) %>%
  cln_is_only_na()
#> [1] TRUE
data.frame(
 num = c(1, 2),
 char = c("a", NA_character_),
 na_col = rep(NA_real_, times = 2)
) %>%
 purrr::keep(\(x) cln_is_only_na(x)) %>%
 names()
#> [1] "na_col"
```
