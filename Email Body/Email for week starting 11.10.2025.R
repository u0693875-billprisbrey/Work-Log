# Email for week starting 11.10.2025

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

summaryAgg$exp <- c("Daily log and planning; re-booting computer; time card training; internal networking", "Improving multiple reports (grades, courses, and predictors over time); Reviewing with Luis", "Directed acyclic graphs" )



####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Send e-mail describing problems with laptop.  
* Predict 'W' with current variables.   	
* Review HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist 
"

agendaItems <- 
  "
  * Review latest progress on math placement guidelines and individualized predictions
"

nextSteps <- 
  "
* Summarize predictive models and key findings so far for general audience unfamiliar with both math courses and machine learning (IN PROGRESS) 
* Proceed to recommendations  
*    Refine effect of course selection / course recommendation  
*    Develop heuristics / general guidelines  
*    Develop demonstration of individualized predictions  
* Develop 'W' grade prediction model for first math courses   
* PI Turnover:  Review snapshot query from HR and write summary before pausing project    
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R"))
 source(here::here("Send Email", "Send Email (To Luis).R"))