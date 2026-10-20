# Check if elements of a vector have a strict numeric format

Check if elements of a vector have a strict numeric format. This
function is used for instance in the `keep_col_numeric` function to
select numeric columns, even in case of parsing issues.

## Usage

``` r
has_strict_numeric_format(string, negate = FALSE, decimal_sep = c(".", ","))
```

## Arguments

- string:

  Input vector. Either a character vector, or something coercible to
  one.

- negate:

  If `TRUE`, inverts the resulting boolean vector.

- decimal_sep:

  vector of expected decimal separators used in the scriptures. Defaults
  is period and comma: `c(".", ",")`.

## Value

a vector of logical indicating if elements have a strict numeric
scripture, includig `,` or `.` as a decimal separator.

## Examples

``` r
vec <- c("1", "09", ".12", "0.12", "2 amis", "test", "< .12", "1.2E-2", "1,5", "2015-05-15")
has_strict_numeric_format(vec)
#>  [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE
```
