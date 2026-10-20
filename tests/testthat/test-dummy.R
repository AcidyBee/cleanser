## ****************************************************************************
## is_dummy()

test_that("is_dummy() works for vectors containing at least one dummy values (0/1): return TRUE", {
  testthat::expect_true(c(0, 1, 0, 1)  %>%  is_dummy())
  testthat::expect_true(c(0, 0, 0) %>% is_dummy())
  testthat::expect_true(c(1, 1, 1) %>% is_dummy())
})

test_that("is_dummy() works for vectors containing at least one dummy values (0/1) and NA: return TRUE", {
  testthat::expect_true(c(0, 1, NA_real_, 1) %>% is_dummy())
  testthat::expect_true(c(0, NA_real_, 0) %>% is_dummy())
  testthat::expect_true(c(1, NA_real_, 1) %>% is_dummy())
})

test_that("is_dummy() works for vectors containing character type dummy values: return TRUE", {
  testthat::expect_true(c("0", "1", NA_character_) %>% is_dummy())
  testthat::expect_true(c("0", NA_character_, "0") %>% is_dummy())
  testthat::expect_true(c("1", NA_character_, "1") %>% is_dummy())
  testthat::expect_true(c("0", "1", NA_character_) %>% factor() %>% is_dummy())
})

test_that("is_dummy() works for vectors containing no dummy values (0/1): return FALSE", {
  testthat::expect_false(c(8, 7, NA_real_) %>% is_dummy())
  testthat::expect_false(c("8", "7", NA_character_) %>% is_dummy())
  testthat::expect_false(c("a", "b", NA_character_) %>% is_dummy())
  testthat::expect_false(c("a", "b", NA_character_) %>% factor() %>% is_dummy())
})

test_that("is_dummy() works for vectors containing at the same time dummy values (0/1) as well as other values: return FALSE", {
  testthat::expect_false(c(0, 1, NA_real_, 5, 0, 1) %>% is_dummy())
})

## TODO: coherce logical to numeric, or not ?
test_that("is_dummy works for vectors of logical: return FALSE", {
  testthat::expect_false(c(FALSE, TRUE, NA, TRUE) %>% is_dummy())
  testthat::expect_false(c(FALSE, NA, FALSE) %>% is_dummy())
  testthat::expect_false(c(TRUE, NA, TRUE) %>% is_dummy())
})

test_that("is_dummy works for vectors containing only NA: return FALSE", {
  testthat::expect_false(c(NA_real_, NA_real_, NA_real_) %>% is_dummy())
})

## ****************************************************************************
## detect_dummy()

test_that("detect_dummy() finds dummy elements (0/1) in a vector: return TRUE & FALSE", {
  testthat::expect_equal(
    c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = TRUE),
    c(TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE)
  )
  testthat::expect_equal(
    c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = TRUE, negate = TRUE),
    c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE)
  )
  testthat::expect_equal(
    c(0, 1, NA, 5, 0, 1, 0.0000000001, 1.0000000001) %>% detect_dummy(na_valid = FALSE),
    c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE)
  )
})

## ****************************************************************************
## dummify()

test_that("dummify works for columns of datasets of any type", {
  dataset <- data.frame(
    id = 1:6,
    char = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_),
    factor = c("Non", "Oui", "Non", "Oui", "Oui", NA_character_) %>% factor(levels = c("Oui", "Non")),
    numeric = c(3, 2, 2, 1, 3, NA_real_),
    logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA)
  )
  testthat::expect_equal(
    dummify(dataset, "char"),
    structure(list(
      id = 1:6,
      char = c("Non", "Oui", "Non", "Oui", "Oui", NA),
      char.Non = c(1, 0, 1, 0, 0, 0),
      char.Oui = c(0, 1, 0, 1, 1, 0), char.NA = c(0, 0, 0, 0, 0, 1),
      factor = structure(c(2L, 1L, 2L, 1L, 1L, NA), levels = c("Oui", "Non"), class = "factor"),
      numeric = c(3, 2, 2, 1, 3, NA),
      logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA)),
      class = "data.frame", row.names = c(NA, -6L))
  )
  testthat::expect_equal(
    dummify(dataset, "factor"),
    structure(list(
      id = 1:6,
      char = c("Non", "Oui", "Non", "Oui", "Oui", NA),
      factor = structure(c(2L, 1L, 2L, 1L, 1L, NA), levels = c("Oui", "Non"), class = "factor"),
      factor.Oui = c(0, 1, 0, 1, 1, 0),
      factor.Non = c(1, 0, 1, 0, 0, 0),
      factor.NA = c(0, 0, 0, 0, 0, 1),
      numeric = c(3, 2, 2, 1, 3, NA),
      logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA)),
      class = "data.frame", row.names = c(NA, -6L))
  )
  testthat::expect_equal(
    dummify(dataset, "numeric"),
    structure(list(
      id = 1:6,
      char = c("Non", "Oui", "Non", "Oui",  "Oui", NA),
      factor = structure(c(2L, 1L, 2L, 1L, 1L, NA), levels = c("Oui", "Non"), class = "factor"),
      numeric = c(3, 2, 2, 1, 3, NA),
      numeric.1 = c(0, 0, 0, 1, 0, 0),
      numeric.2 = c(0, 1, 1, 0, 0, 0),
      numeric.3 = c(1, 0, 0, 0, 1, 0),
      numeric.NA = c(0, 0, 0, 0, 0, 1),
      logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA)),
      class = "data.frame", row.names = c(NA, -6L))
  )
  testthat::expect_equal(
    dummify(dataset, "logical"),
    structure(list(
      id = 1:6,
      char = c("Non", "Oui", "Non", "Oui", "Oui", NA),
      factor = structure(c(2L, 1L, 2L, 1L, 1L, NA), levels = c("Oui", "Non"), class = "factor"),
      numeric = c(3, 2, 2, 1, 3, NA),
      logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA),
      logical.FALSE = c(1, 0, 1, 0, 0, 0),
      logical.TRUE = c(0, 1, 0, 1, 1, 0),
      logical.NA = c(0, 0, 0, 0, 0, 1)),
      class = "data.frame", row.names = c(NA, -6L))
    )
  testthat::expect_equal(
    dummify(dataset, "logical", dummy_code = c("non", "oui")),
    structure(list(
      id = 1:6,
      char = c("Non", "Oui", "Non", "Oui", "Oui", NA),
      factor = structure(c(2L, 1L, 2L, 1L, 1L, NA), levels = c("Oui", "Non"), class = "factor"),
      numeric = c(3, 2, 2, 1, 3, NA),
      logical = c(FALSE, TRUE, FALSE, TRUE, TRUE, NA),
      logical.FALSE = c("oui", "non", "oui", "non", "non", "non"),
      logical.TRUE = c("non", "oui", "non", "oui", "oui", "non"),
      logical.NA = c("non", "non", "non", "non", "non", "oui")),
      class = "data.frame", row.names = c(NA, -6L))
  )
})
