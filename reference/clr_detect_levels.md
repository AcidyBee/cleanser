# Check if elements of a vector have expected levels

Check if elements of a vector have expected levels. This function is
used for instance in the `keep_col_w_levels` function to select specific
factor columns, even in case of case issues.

## Usage

``` r
clr_detect_levels(string, levels, negate = FALSE, ignore_case = FALSE)
```

## Arguments

- string:

  Input vector. Either a character vector, or something coercible to
  one.

- levels:

  Complete set of specific levels seeked for the variables.

- negate:

  If `TRUE`, inverts the resulting boolean vector.

- ignore_case:

  Should case differences be ignored in the match? For fixed(), this
  uses a simple algorithm which assumes a one-to-one mapping between
  upper and lower case letters.

## Value

a vector of logical indicating if elements have a strict numeric
scripture, includig `,` or `.` as a decimal separator.

## Examples

``` r
## Default: ignore_case = FALSE
vec <- c("Oui", "oui", "Non", "non", "NON", "ouistiti", NA_character_)
clr_detect_levels(vec, levels =  c("Non", "Oui"))
#> [1]  TRUE FALSE  TRUE FALSE FALSE FALSE    NA
## negate = TRUE
clr_detect_levels(vec, levels =  c("Non", "Oui"), negate = TRUE)
#> [1] FALSE  TRUE FALSE  TRUE  TRUE  TRUE    NA
## ignore_case = TRUE
clr_detect_levels(vec, levels =  c("Non", "Oui"), ignore_case = TRUE)
#> [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE    NA
## Default: ignore_case = FALSE pour +/-
vec <- c("+", "-", "Non", "non", "NON", "ouistiti", NA_character_)
clr_detect_levels(vec, levels =  c("+", "-"))
#> [1]  TRUE  TRUE FALSE FALSE FALSE FALSE    NA
```
