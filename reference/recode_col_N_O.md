# Automated recoding of N/O factors

Automated recoding of N/O factors

## Usage

``` r
recode_col_N_O(...)
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

a function that automatically recodes N/Y factors

## Examples

``` r
data.frame(
  x = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
  y = c("N", "O", "Non", "Oui", "Oui", NA_character_),
  z = c("Non", "Oui", "Non", "Oui", "+", NA_character_)
) %>%
recode_col_N_O()
#>      x    y    z
#> 1  Non    N  Non
#> 2  Oui    O  Oui
#> 3  Non  Non  Non
#> 4  Oui  Oui  Oui
#> 5  Oui  Oui    +
#> 6 <NA> <NA> <NA>
```
