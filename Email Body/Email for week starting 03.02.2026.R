# Email for week starting 03.02.2026  

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

explanations <- c("Job Mngt" = "UAIR meetings; updating Jira and log; resolving GitHub and OneDrive conflict", 
                  "Predict Math Success" = "Adjusting report per feedback",
                  "PI Turnover" = "",
                  "Gray DI" = "Setting up account; generating test reports; reviewing presentation by CEO",
                  "Prof Dev" = "Studying functions and formulas for new machine learning workflow (tidyverse, tidymodels, xgboost)",
                  "Travel" = "To UAIR coffee")  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Create Epic for 'Predict Completions' 
* Write up a brief summary of student course feedback work  
* Review conferences and possible submission titles for papers, prioritizing student course feedback  
* Review Roles & Responsibilities and HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist
"

agendaItems <- 
  "
  * Possible conferences  
  * Student course feedback summary
  * Gray DI proposal
  * Completions early findings
"

nextSteps <- 
  "
* Become competent in new training workflow (that doesn't use 'caret')
* Update select models using 'tidymodels' and 'xg.boost' (instead of 'caret')
* Update Phase 1 report per feedback  
* Complete Phase 2 (Course Guide and Estimate Academic Impact)  
* PI Turnover:  Review snapshot query from HR and write summary before pausing project      
* Write up impressions of Gray DI 
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email (To Luis).R"))