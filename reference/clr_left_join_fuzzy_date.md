# Fuzzy left join including a jon specification on a date

Fuzzy left join including a jon specification on a date

## Usage

``` r
clr_left_join_fuzzy_date(
  x,
  y,
  by_date_x,
  by_date_y = by_date_x,
  by_not_fuzzy = NULL,
  suffix = c(".x", ".y"),
  num = 1,
  units = "days"
)
```

## Arguments

- x, y:

  A pair of data frames, data frame extensions (e.g. a tibble), or lazy
  data frames (e.g. from dbplyr or dtplyr). See *Methods*, below, for
  more details.

- by_date_x, by_date_y:

  A join specification with the name of the date variable of dataset x &
  y invalved in the fuzzy date join. If only `by_date_x` is provided,
  `by_date_y` will default to `by_date_x`.

- by_not_fuzzy:

  A regular join specification.

- suffix:

  If there are non-joined duplicate variables in `x` and `y`, these
  suffixes will be added to the output to disambiguate them. Should be a
  character vector of length 2.

- num:

  a numeric or character vector. A character vector can specify periods
  in a convenient shorthand format or ISO 8601 specification. All
  unambiguous name units and abbreviations are supported, "m" stands for
  months, "M" for minutes unless ISO 8601 "P" modifier is present (see
  examples). Fractional units are supported but the fractional part is
  always converted to seconds.

- units:

  a character vector that lists the type of units to be used. The units
  in units are matched to the values in num according to their order.
  When `num` is character, this argument is ignored.

## Value

An object of the same type as x (including the same groups), with the
same number of rows as x. The order of the rows and columns of x is
preserved as much as possible.

## Examples

``` r
clr_left_join_fuzzy_date(
data.frame(
  id = 1:5,
  sexe = c("F", "H", "F", "F", "H"),
  date_nais = c("1923/01/01", "1924/01/01", "1925/01/01", "1926/01/01", "1927/01/01") %>%
  lubridate::ymd(),
  DB = c("oui", "non", "non", "oui", NA_character_)
),
data.frame(
  id = 1:5,
  sexe = c("F", "H", "F", "F", "H"),
  date_nais = c("1923/01/01", "1924/01/02", "1924/12/31", "1926/01/03", "1926/12/30") %>%
  lubridate::ymd(),
  DB = c("oui", "non", "non", "oui", NA_character_)
), by_date_x = "date_nais", by_not_fuzzy = "id"
)
#>   id sexe.x date_nais.x DB.x sexe.y date_nais.y DB.y
#> 1  1      F  1923-01-01  oui      F  1923-01-01  oui
#> 2  2      H  1924-01-01  non      H  1924-01-02  non
#> 3  3      F  1925-01-01  non      F  1924-12-31  non
#> 4  4      F  1926-01-01  oui   <NA>        <NA> <NA>
#> 5  5      H  1927-01-01 <NA>   <NA>        <NA> <NA>
```
