# Email for week starting 08.03.2026  

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

explanations <- c("Job Mngt" = "Planning; logs; UAIR meetings",
                  # "Holiday" = "Memorial Day",
                  "Vacation" = "Vacation",
                  #  "Sick" = "Dr Appt",
                  #  "Travel" = "Internal networking",
                  "Forecast Completion Rates" = "Iterating on Forecast Drivers report; Adjusting text on all reports to reflect factor model; Final review and render", 
                  "Forecast Drivers" = "Examining increased risk for elite students; clustering fixed- and in-play SHAP variables"
)  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Review conferences and possible submission titles for papers
* Develop forecast from FTF Demo data, disregarding other data sources DONE
"

agendaItems <- 
  "
* Discuss Forecast Drivers report
* Discuss next project focusing on causal drivers
"

nextSteps <- 
  "
* Develop forecast using extreme gradient boosting DONE
* Develop forecast using cohort-level aggregations ABANDONED
* Develop forecast using survival analysis ABANDONED
* Combine all forecasts as an ensemble forecast ABANDONED
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email (To Luis).R"))
