
# devtools::install.github("jjchern/fips@v0.0.2")

library(tidyverse)

tidy_up = . %>%
    docxtractr::mcga() %>%
    rename(state = location) %>%
    right_join(fips::state) %>%
    select(state, fips, usps, everything()) %>%
    gather(var, value, -c(state, fips, usps)) %>%
    separate(var, c("year", "var"), sep = "_", extra = "merge") %>%
    spread(var, value) %>%
    print()

# Hospital Beds per 1,000 Population by Ownership Type --------------------
# https://www.kff.org/other/state-indicator/beds-by-ownership

read_csv("data-raw/hosp_beds.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hosp_beds

# Hospital Admissions per 1,000 Population by Ownership Type ----------
# https://www.kff.org/other/state-indicator/admissions-by-ownership/

read_csv("data-raw/hosp_admissions.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hosp_admissions

# Hospital Emergency Room Visits per 1,000 Population by Ownership --------
# https://www.kff.org/other/state-indicator/emergency-room-visits-by-ownership/

read_csv("data-raw/hosp_em_visits.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hosp_em_visits

# Hospital Inpatient Days per 1,000 Population by Ownership Type ----------
# https://www.kff.org/other/state-indicator/inpatient-days-by-ownership/

read_csv("data-raw/hosp_ip_days.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hosp_ip_days

# Hospital Outpatient Visits per 1,000 Population by Ownership Type -------
# https://www.kff.org/other/state-indicator/outpatient-visits-by-ownership/

read_csv("data-raw/hosp_op_visits.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hosp_op_visits

# Health Care Expenditures per Capita by State of Residence ---------------
# https://www.kff.org/other/state-indicator/health-spending-per-capita

read_csv("data-raw/hc_eee_pc.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hc_eee_pc

# Health Care Expenditures per Capita by Service by State of Resid --------
# https://www.kff.org/other/state-indicator/health-spending-per-capita-by-service

read_csv("data-raw/hc_eee_pc_by_srvc.csv", skip = 2, na = "N/A") %>%
    tidy_up() -> hc_eee_pc_by_srvu

# Percent of Adults Who Have Ever Been Told by a Doctor that They  --------
# https://www.kff.org/other/state-indicator/adults-with-diabetes/

read_csv("data-raw/pct_diabetes.csv", skip = 2, na = "N/A") %>%
    select(-Footnotes) %>%
    tidy_up() -> pct_diabetes


# Percent of Adults Who are Overweight or Obese ---------------------------
# https://www.kff.org/other/state-indicator/adult-overweightobesity-rate

read_csv("data-raw/pct_overweight_obesity.csv", skip = 2, na = "N/A") %>%
    select(-Footnotes) %>%
    tidy_up() -> pct_overweight_obesity

# Save them! --------------------------------------------------------------

devtools::use_data(hosp_beds,
                   hosp_admissions,
                   hosp_em_visits,
                   hosp_ip_days,
                   hosp_op_visits,
                   hc_eee_pc,
                   hc_eee_pc_by_srvu,
                   pct_diabetes,
                   pct_overweight_obesity)
