# Detects and recode numeric columns

Detects and recode numeric columns

## Usage

``` r
recode_col_numeric(data)
```

## Arguments

- data:

  input dataset

## Value

dataset with the same properties as the input dataset, with the numeric
columns automatically recoded as such, as long as the values of the
vector correspond to a strict numeric scripture as intended in
`has_strict_numeric_format`.

## Examples

``` r
data.frame(
x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
y = c(1, 0, 5, 3, 2, NA_real_),
z = c("1", "0", "5,2", "3.5", "2E-2", NA_character_)
) %>%
  recode_col_numeric()
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `dplyr::across(dplyr::all_of(col_numeric_not_instant),
#>   as.numeric)`.
#> Caused by warning:
#> ! NAs introduced by coercion
#>      x  y    z
#> 1  Non  1 1.00
#> 2  Oui  0 0.00
#> 3  Non  5   NA
#> 4  Oui  3 3.50
#> 5  Oui  2 0.02
#> 6 <NA> NA   NA
```
