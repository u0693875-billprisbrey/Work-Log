# Email for week starting 01.05.2026  

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

explanations <- c("Job Mngt" = "Daily planning; weekly logs", "Predict Math Success" = "Modifying course guide and individual recommendation; reviewing prior analyses; writing final report outline",
                  "Sick" = "Kid's doctor appointment")  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Publish guidelines for course selection (95% DONE)
* Include a report of individual predictions (95% DONE)  
* Review Roles & Responsibilities and HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist 
"

agendaItems <- 
  "
  * Laptop replacement and VM progress    
  * Review course guide and individual recommendations  
  * Review report outline 
      * Repeat some analyses with 'distance' metric?  
  * Discuss bi-weekly Kronos replacement 
      * No more reminders?    
      * Sick hours for doctor's appointments?  
"

nextSteps <- 
  "
* Summarize predictive models and key findings so far for general audience unfamiliar with both math courses and machine learning (IN PROGRESS) 
* Recommendations and guidelines:   
  *    Refine effect of course selection / course recommendation (DONE)  
  *    Develop heuristics / general guidelines (DONE)
  *    Develop demonstration of individualized predictions (DONE)  
* Develop 'W' grade prediction model for first math courses (DONE)  
* PI Turnover:  Review snapshot query from HR and write summary before pausing project    
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
 source(here::here("Send Email", "Send Email (To Luis).R"))
