## ****************************************************************************
## clr_detect_levels()
test_that("clr_detect_levels() works for vectors, even for regex special characters", {
  has_lvl_expected <- function(levels, negate = FALSE, ignore_case = FALSE) {
    vec <- c("+", "-", "Oui", "oui", "Non", "non", "NON", "ouistiti", NA_character_)
    clr_detect_levels(vec, levels =  levels, negate = negate, ignore_case = ignore_case)
  }
  testthat::expect_equal(has_lvl_expected(levels =  c("Non", "Oui")), c(FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, NA))
  testthat::expect_equal(has_lvl_expected(levels =  c("Non", "Oui"), negate = TRUE), c(TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, NA))
  testthat::expect_equal(has_lvl_expected(levels =  c("Non", "Oui"), ignore_case = TRUE), c(FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, NA))
  testthat::expect_equal(has_lvl_expected(levels =  c("+", "-")), c(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NA))
})

## ****************************************************************************
## cure_single_level_case()
test_that("cure_single_level_case() works for vectors, even for regex special characters", {
  cure_single_level_case_expected <- function(single_level) {
    case <- c("OUI", "Non", "non", "oui", "+", NA_character_)
    cure_single_level_case(string = case, single_level = single_level)
  }
  testthat::expect_equal(cure_single_level_case_expected(single_level =  "oui"), c("oui", "Non", "non", "oui", "+", NA))
  testthat::expect_equal(cure_single_level_case_expected(single_level =  "non"), c("OUI", "non", "non", "oui", "+", NA))
  testthat::expect_equal(cure_single_level_case_expected(single_level =  "OUI"), c("OUI", "Non", "non", "OUI", "+", NA))
  testthat::expect_equal(cure_single_level_case_expected(single_level =  "+"), c("OUI", "Non", "non", "oui", "+", NA))
})
test_that("cure_single_level_case() is pipe friendly", {
  case <- c("OUI", "Non", "non", "oui", "+", NA_character_)
  testthat::expect_equal(case %>%
                           cure_single_level_case(single_level =  "oui") %>%
                           cure_single_level_case(single_level =  "non"),
                         c("oui", "non", "non", "oui", "+", NA))
})
