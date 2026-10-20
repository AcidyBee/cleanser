# Augment a dataset with dummified version of a variable

Augment a dataset with dummified version of a variable obtained from the
combinations of the distinct cell values of the variable. Any type of
character variable is allowed.

## Usage

``` r
dummify(data, names_from, dummy_code = c(0, 1))
```

## Arguments

- data:

  a dataset containing the column to dummify.

- names_from:

  the name of the variable to dummify.

- dummy_code:

  optional length 2 vector giving the dummy coding (i.e. `0` and `1`
  modalities). Defaults to c(0, 1), but can be conveniently switched to
  c("no", "yes") to identify factor categories for instance.

## Value

an augmented dataset with dummy values observations for each unique cell
value of the variable.

## Examples

``` r
dataset <- data.frame(
  id = 1:6,
  char = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
  factor = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_) %>% factor(levels = c("Non", "Oui")),
  numeric = c(3, 2, 2, 1, 3, NA_real_),
  logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA)
)
# char
dummify(dataset, "char")
#>   id char char.Non char.Oui char.NA factor numeric logical
#> 1  1  Non        1        0       0    Non       3   FALSE
#> 2  2  Oui        0        1       0    Oui       2    TRUE
#> 3  3  Non        1        0       0    Non       2   FALSE
#> 4  4  Oui        0        1       0    Oui       1    TRUE
#> 5  5  Oui        0        1       0    Oui       3    TRUE
#> 6  6 <NA>        0        0       1   <NA>      NA      NA
# factor
dummify(dataset, "factor")
#>   id char factor factor.Non factor.Oui factor.NA numeric logical
#> 1  1  Non    Non          1          0         0       3   FALSE
#> 2  2  Oui    Oui          0          1         0       2    TRUE
#> 3  3  Non    Non          1          0         0       2   FALSE
#> 4  4  Oui    Oui          0          1         0       1    TRUE
#> 5  5  Oui    Oui          0          1         0       3    TRUE
#> 6  6 <NA>   <NA>          0          0         1      NA      NA
# numeric
dummify(dataset, "numeric")
#>   id char factor numeric numeric.1 numeric.2 numeric.3 numeric.NA logical
#> 1  1  Non    Non       3         0         0         1          0   FALSE
#> 2  2  Oui    Oui       2         0         1         0          0    TRUE
#> 3  3  Non    Non       2         0         1         0          0   FALSE
#> 4  4  Oui    Oui       1         1         0         0          0    TRUE
#> 5  5  Oui    Oui       3         0         0         1          0    TRUE
#> 6  6 <NA>   <NA>      NA         0         0         0          1      NA
# logical
dummify(dataset, "logical")
#>   id char factor numeric logical logical.FALSE logical.TRUE logical.NA
#> 1  1  Non    Non       3   FALSE             1            0          0
#> 2  2  Oui    Oui       2    TRUE             0            1          0
#> 3  3  Non    Non       2   FALSE             1            0          0
#> 4  4  Oui    Oui       1    TRUE             0            1          0
#> 5  5  Oui    Oui       3    TRUE             0            1          0
#> 6  6 <NA>   <NA>      NA      NA             0            0          1
# with non/oui instead of 0/1
dummify(dataset, "logical", dummy_code = c("non", "oui"))
#>   id char factor numeric logical logical.FALSE logical.TRUE logical.NA
#> 1  1  Non    Non       3   FALSE           oui          non        non
#> 2  2  Oui    Oui       2    TRUE           non          oui        non
#> 3  3  Non    Non       2   FALSE           oui          non        non
#> 4  4  Oui    Oui       1    TRUE           non          oui        non
#> 5  5  Oui    Oui       3    TRUE           non          oui        non
#> 6  6 <NA>   <NA>      NA      NA           non          non        oui
```
