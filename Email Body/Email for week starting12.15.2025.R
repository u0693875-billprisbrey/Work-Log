# Email for week starting 12.15.2025

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

explanations <- c("Job Mngt" = "Daily planning; resolving computer crash", 
                  "Predict Math Success" = "Course guide report (course clusters and course scatter plot); training and evaluating model vH3 using distance features; counterfactuals with vH3",
                  "Prof Dev" = "Study causal inference")

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

# summaryAgg$exp <- c("Daily log; UAIR lunch; laptop write-up", "Deeper dive into vH2, comparing to vK0, adding and improving visualizations", "Directed acyclic graphs; matching", "UAIR lunch" )



####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Develop course guide (80% DONE) 	
* Develop section on individual predictions (IN PROGRESS) 
* Review HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist
"

agendaItems <- 
  "
  * Laptop and VMWare 
  * Review Course Guide (clusters, distance, and individual predictions)
  * Membership in AIR, HEDW, Educause 
  * Presenting at conferences  
"

nextSteps <- 
  "
* Summarize predictive models and key findings so far for general audience unfamiliar with both math courses and machine learning (IN PROGRESS) 
* Recommendations and guidelines:   
*    Refine effect of course selection / course recommendation (DONE)  
*    Develop heuristics / general guidelines (DONE)
*    Develop demonstration of individualized predictions (REVISING)  
* Develop 'W' grade prediction model for first math courses (DONE)  
* PI Turnover:  Review snapshot query from HR and write summary before pausing project    
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R"))
source(here::here("Send Email", "Send Email (To Luis).R"))