# Cure a single case issue for a factor level in a string

Cure a single case issue for a factor level in a string

## Usage

``` r
cure_single_level_case(string, single_level)
```

## Arguments

- string:

  Input vector. Either a character vector, or something coercible to
  one.

- single_level:

  a single element of the complete set of specific levels seeked for the
  variables

## Value

A selection of columns from the input dataset that have no other levels
than the ones specified in the `levels` argument

## Examples

``` r
case <- c("OUI", "Non", "non", "oui")
## single application
case %>%
cure_single_level_case("oui")
#> [1] "oui" "Non" "non" "oui"
## pipe of several applications of the function
case %>%
cure_single_level_case("oui") %>%
cure_single_level_case("non")
#> [1] "oui" "non" "non" "oui"
```
