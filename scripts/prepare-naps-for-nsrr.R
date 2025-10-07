#prepare-wsc-for-nsrr

library(dplyr)
library(readxl)

version <- "0.1.0.pre"

naps_dir <- "/Volumes/bwh-sleepepi-nsrr-staging/20230918-naps/original-data/NAPS1demographicsNSRRtransfer.xlsx"

releasepath <- "/Volumes/bwh-sleepepi-nsrr-staging/20230918-naps/nsrr-prep/_releases/"

###-------Create the main dataset------
naps <- read_excel(naps_dir, na = "NA") |>
  rename_with(tolower)

write.csv(naps, file.path(releasepath, paste0(version, "/naps-dataset-", version, ".csv")), na = "", row.names = F)

###-------Create NSRR harmonized dataset------
naps_nsrr <- naps |>
  select(-`study type`)|>
  rename(nsrrid = naps_id,
         nsrr_age = age,
         nsrr_sex = sex) |>
  mutate(nsrr_visit = 1,
         nsrr_age_gt89 = case_when(
           nsrr_age > 89  ~ "yes",
           nsrr_age <= 89 ~ "no"),
         nsrr_sex = case_match(nsrr_sex,
                               1 ~ "male",
                               2 ~ "female"
                               ))|>
  relocate(nsrr_visit, .after = "nsrrid")

write.csv(naps_nsrr, file.path(releasepath, paste0(version, "/naps-dataset-harmonized-", version, ".csv")), na = "", row.names = F)
