# Automated recoding of -/+ factors

Automated recoding of -/+ factors

## Usage

``` r
recode_col_neg_pos(...)
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
  x = c("-", "+", "+", NA_character_),
  y = c("-", "O", "+", NA_character_)
) %>%
recode_col_neg_pos() %>%
purrr::map_chr(class)
#>           x           y 
#>    "factor" "character" 
```
