# Detect dummy elements in a vector

Detect dummy elements in a vector

## Usage

``` r
detect_dummy(x, na_valid = TRUE, negate = FALSE)
```

## Arguments

- x:

  A vector of any type. `x` is coerced to a character vector before it
  is checked: i.e. do the elements of the vector corresponds to "0" &
  "1". Logical TRUE/FALSE vectors are not coerced to 0 or 1 (which is
  the expected behavior).

- na_valid:

  Is NA a valid element to be added to the dummy values 0/1, defaults to
  TRUE.

- negate:

  If TRUE, inverts the resulting boolean vector, defaults to FALSE

## Value

detect_dummy() returns a logical vector with TRUE for each element of
string that matches pattern and FALSE otherwise.

## Examples

``` r
c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = FALSE)
#> [1]  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE
c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = TRUE)
#> [1]  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE
c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(negate = TRUE)
#> [1] FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE
```
