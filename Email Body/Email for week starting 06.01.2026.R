# Email for week starting 06.01.2026  

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

category_by_day <- xtabs(diff ~ DATE + CATEGORY, 
                         data = aggregate(diff ~ DATE + CATEGORY, data = mostRecent, sum, na.rm = TRUE))

# category_by_day |> addmargins() # useful for double-checking

dailyDisplay <- function() {
  # For display
  
  category_by_day |>
    addmargins() |>
    as.data.frame.matrix() |>
    kable() |>
    kable_styling(bootstrap_options = c("striped", "hover"))
  
}  

summaryAgg <- recentCategory[!recentCategory$CATEGORY %in% c("Break", "Fitness Challenge"),]

checkTime <- function(){
  sum(summaryAgg$diff)
}

# mostRecent[mostRecent$CATEGORY == "Job Mngt",]
# mostRecent[mostRecent$CATEGORY == "Study Causal Inference",]

explanations <- c("Job Mngt" = "UAIR Meetings; weekly logs; internal networking; Jira",
                  "Holiday" = "Memorial Day",
                  "Sick" = "Dr Appt",
                  "Travel" = "Internal networking",
                  "Forecast Completion Rates" = "Diagnostics and plots, double-checking, and de-bugging" 
)  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Review conferences and possible submission titles for papers  
* Develop forecast from FTF Demo data, disregarding other data sources IN PROGRESS
"

agendaItems <- 
  "
* Discuss draft report of individual level completion forecasts   
* Develop features from Courses data (DELAYED)
"

nextSteps <- 
  "
* Develop forecast using extreme gradient boosting IN PROGRESS
* Develop forecast using cohort-level aggregations
* Develop forecast using survival analysis 
* Combine all forecasts as an ensemble forecast
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email (To Luis).R"))
