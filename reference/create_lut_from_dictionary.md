# Recode from a lut

This function allows to transform non-syntaxic libs to syntaxic var code

## Usage

``` r
create_lut_from_dictionary(dictionary, old, new)
```

## Arguments

- dictionary:

  Dictionary linking lib to a given code

- old:

  lib col of the dictionary

- new:

  code col of the dictionary

## Value

lut linking lib to code

## Examples

``` r
dict <- data.frame(
lib_raw = c("date evenement", "uti'l"),
code = c("date_evt", "util")
)
create_lut_from_dictionary(dict, old = lib_raw, new = code)
#> date evenement          uti'l 
#>     "date_evt"         "util" 
```
