# Email for week starting 04.20.2026  

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

explanations <- c("Job Mngt" = "UAIR meetings; support tickets; planning and logs", 
                  "Travel" = "To/from UAIR Connect",
                  "Prof Dev" = "Survival Analysis",
                  "Forecast Completion Rates" = "Learning IR definitions and reports; tracking sample EMPLIDs across databases; examining FTF Demo outliers and anomalies" 
)  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Review conferences and possible submission titles for papers, prioritizing student course feedback  
* Discuss data defintions with Whitney/Sara DONE
* Attend IR meetings and learn about reporting definitions IN PROGRESS
* Develop forecast from FTF Demo data, disregarding other data sources 
"

agendaItems <- 
  "
  No agenda items at this time.
"

nextSteps <- 
  "
* Develop baseline forecast using historical proportions (stratifying by gender and declared major)
* Develop forecast using extreme gradient boosting 
* Develop forecast using survival analysis 
* Combine all forecasts as an ensemble forecast
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email (To Luis).R"))