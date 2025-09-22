# Email for week starting 9.22.2025

# Load and Prep

library(kableExtra)
library(blastula)
library(glue)

source(here::here("Prep", "Notepad Email Prep.R"))

##################
## Aggregations ##
##################

recentCategory <- aggregate(diff ~ CATEGORY, data = mostRecent, sum, na.rm=TRUE)
dailyActivity <- aggregate(diff ~ DATE, data = mostRecent, sum, na.rm = TRUE)