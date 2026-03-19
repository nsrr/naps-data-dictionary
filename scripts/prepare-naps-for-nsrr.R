#prepare-wsc-for-nsrr

library(dplyr)
library(readxl)

version <- "0.1.0"

naps_dir <- "/Volumes/bwh-sleepepi-nsrr-staging/20230918-naps/original-data/NAPS1demographicsNSRRtransfer.xlsx"
naps_dir_1 <- '/Volumes/bwh-sleepepi-nsrr-staging/20230918-naps/original-data/Copy of NAPS1demographicsNSRRtransfer_with_FILE IDS.xlsx'

releasepath <- "/Volumes/bwh-sleepepi-nsrr-staging/20230918-naps/nsrr-prep/_releases/"

###-------Create the main dataset------
naps <- read_excel(naps_dir_1, na = "NA") |>
  rename_with(tolower) |>
  rename(
    file_id = `file id`,
    study_type = `study type`)|>
  mutate(visit = 1)

write.csv(naps, file.path(releasepath, paste0(version, "/naps-dataset-", version, ".csv")), na = "", row.names = F)

###-------Create NSRR harmonized dataset------
naps_nsrr <- naps |>
  select(-study_type)|>
  rename(nsrrid = file_id,
         nsrr_age = age,
         nsrr_sex = sex) |>
  mutate(nsrr_visit = visit,
         nsrr_sex = case_match(nsrr_sex,
                               1 ~ "male",
                               2 ~ "female",
                               NA ~ "not reported"
                               ),
         nsrr_file_prefix = str_replace(nsrrid, " ", "_"))|>
  relocate(nsrr_visit, .after = "nsrrid") |>
  relocate(visit, .after = nsrr_visit)

write.csv(naps_nsrr, file.path(releasepath, paste0(version, "/naps-dataset-harmonized-", version, ".csv")), na = "", row.names = F)
