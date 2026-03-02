# Email for week starting 02.23.2026  

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

summaryAgg <- recentCategory[recentCategory$CATEGORY != "Break",]

checkTime <- function(){
  sum(summaryAgg$diff)
}

# mostRecent[mostRecent$CATEGORY == "Job Mngt",]
# mostRecent[mostRecent$CATEGORY == "Study Causal Inference",]

explanations <- c("Job Mngt" = "UAIR meetings; updating weekly Jira; sending weekly log", "Predict Math Success" = "Final combined report; adjustments; cleaning up vH4 deep dive; rendering multiple formats on old laptop",
                  "PI Turnover" = "Catch-up meeting with Brian Gelsinger")  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Work with Rahul on a complete Jira submission (ABANDONED; following Teams outline instead)  
* Review Roles & Responsibilities and HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist
"

agendaItems <- 
  "
  * Promotion plan and conferences  
  * HR analytics given additional headcount loss  
  * Discuss bi-weekly Kronos replacement 
      * No more reminders?    
      * Sick hours for doctor's appointments? 
"

nextSteps <- 
  "
* Complete Phase 2 (Course Guide) and Phase 3 (Estimate Academic Impact)  
* Update all reports using 'xg.boost' class model instead of 'caret' class model (due to versioning issues) (ABANDONED; reports rendered in old laptop instead)   
* Update select models using 'tidymodels' and 'xg.boost' instead of 'caret' class model
* Add all reports as appendices to Word document (DONE) 
* PI Turnover:  Review snapshot query from HR and write summary before pausing project      
"

################
## SEND EMAIL ##
################

source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
# source(here::here("Send Email", "Send Email (To Luis).R"))