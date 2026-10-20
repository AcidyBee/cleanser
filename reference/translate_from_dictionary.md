# Translate data libs to syntaxic var code

This function allows to transform non-syntaxic libs to syntaxic var
code. Using it in conjonction of dplyr rename_with it allows for direct
dataframe names modification (see example).

## Usage

``` r
translate_from_dictionary(x, dictionary, old, new)
```

## Arguments

- x:

  Vector of names

- dictionary:

  Dictionary linking var libs to codes

- old:

  lib col of the dictionary

- new:

  code col of the dictionary

## Value

Vector of names of the same size as x

## Examples

``` r
if (FALSE) { # \dontrun{
dict <- data.frame(
  lib_raw = c("date evenement", "uti\'l"),
  code = c("date_evt", "util")
)
data <- tibble::tibble(
  `date evenement` = c("01/01/1974", "01/01/1989"),
  `uti\'l` = c("oui", "non")
)
translate_from_dictionary(names(data), dict, lib_raw, code)
dplyr::rename_with(data, .fn = \(x) translate_from_dictionary(x, dict, lib_raw, code))
} # }
```
