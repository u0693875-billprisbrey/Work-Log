# Email for week starting 11.03.2025

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

summaryAgg$exp <- c("Daily log and report; improving and sharing 'drawCM' function; headshot", "Reconciled data sets; evaluating prediction accuracy over time", "Travel (headshot)" )

checkTime <- function(){
  sum(summaryAgg$diff)
}

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Summarize work on PI Turnover and pause indefinitely while awaiting direction from new leadership  
* Predict 'W' with current variables  	
* Review HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist 
"

agendaItems <- 
  "
* Computer language roadmap and R   
* Laptop replacement and virtual machine alternative  
* Title change to Senior/Principal/Lead Data Scientist  
"

nextSteps <- 
  "
* Summarize predictive models and key findings so far for general audience unfamiliar with both math courses and machine learning (IN PROGRESS) 
* Proceed to recommendations  
*    Experiment with prediction thresholds and the precision/recall tradeoff (DONE)    
*    Develop counter-factuals   
*    Explore predicting courses (DONE)
*    Explore changes over time in predictors (IN PROGRESS)  
* Develop 'W' grade prediction model for first math courses 
* PI Turnover:  Review snapshot query from HR and write summary before pausing project    
"

################
## SEND EMAIL ##
################

source(here::here("Send Email", "Send Email (To Prisbrey Only).R"))
# source(here::here("Send Email", "Send Email (To Luis).R"))