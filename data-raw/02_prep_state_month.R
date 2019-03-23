
#' This script prepares datasets that are arranged at the state-month level
#'
#' Install the fips package for adding common state-level identifiers
#' intall.packages("remotes")
#' remotes::install_github("jjchern/fips@v0.0.2")
#' To update, go to the source link at the beginning of each code block, select
#' "Trend Graph", timeframe, geographic units, and download the raw data.

library(tidyverse)

# Total monthly Medicaid and CHIP enrollment ------------------------------
# https://www.kff.org/health-reform/state-indicator/total-monthly-medicaid-and-chip-enrollment/

# Helper function to clean months
replace_w_deci = function(x) {
    x = as.character(x)
    x[grepl("(?i)((^(Jan)(\\.)?$)|(^(Janurary)$))|(^(0)?(1)$)", x)]      = "01"
    x[grepl("(?i)((^(Feb)(\\.)?$)|(^(February)$))|(^(0)?(2)$)", x)]      = "02"
    x[grepl("(?i)((^(Mar)(\\.)?$)|(^(March)$))|(^(0)?(3)$)", x)]         = "03"
    x[grepl("(?i)((^(Apr)(\\.)?$)|(^(April)$))|(^(0)?(4)$)", x)]         = "04"
    x[grepl("(?i)((^(May)(\\.)?$)|(^(May)$))|(^(0)?(5)$)", x)]           = "05"
    x[grepl("(?i)((^(Jun)(\\.)?$)|(^(June)$))|(^(0)?(6)$)", x)]          = "06"
    x[grepl("(?i)((^(Jul)(\\.)?$)|(^(July)$))|(^(0)?(7)$)", x)]          = "07"
    x[grepl("(?i)((^(Aug)(\\.)?$)|(^(August)$))|(^(0)?(8)$)", x)]        = "08"
    x[grepl("(?i)((^(Sep)(t)?(\\.)?$)|(^(September)$))|(^(0)?(9)$)", x)] = "09"
    x[grepl("(?i)((^(Oct)(\\.)?$)|(^(October)$))|(^(10)$)", x)]          = "10"
    x[grepl("(?i)((^(Nov)(\\.)?$)|(^(November)$))|(^(11)$)", x)]         = "11"
    x[grepl("(?i)((^(Dec)(\\.)?$)|(^(December)$))|(^(12)$)", x)]         = "12"
    x
}

read_csv("data-raw/medicaid_chip_enrollment.csv", skip = 2, na = "N/A") %>%
    docxtractr::mcga() %>%
    rename(state = location) %>%
    right_join(fips::state) %>%
    select(state, fips, usps, everything()) %>%
    select(-footnotes) %>%
    gather(var, value, -c(state, fips, usps)) %>%
    separate(var, c("month", "year", "var"), sep = "_", extra = "merge") %>%
    mutate(month = replace_w_deci(month)) %>%
    arrange(fips, year, month) %>%
    spread(var, value) %>%
    select(state, fips, usps, year, month,
           pre_aca_average_monthly_enrollment,
           total_monthly_medicaid_chip_enrollment,
           percent_change) %>%
    print() -> medicaid_chip_enrollment

usethis::use_data(medicaid_chip_enrollment, overwrite = TRUE)
