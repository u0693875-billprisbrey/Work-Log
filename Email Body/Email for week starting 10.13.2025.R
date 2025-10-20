# Email for week starting 10.13.2025

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

# category_by_day <- aggregate(diff ~ DATE + CATEGORY, data = mostRecent, sum, na.rm = TRUE)

category_by_day <- xtabs(diff ~ DATE + CATEGORY, 
                    data = aggregate(diff ~ DATE + CATEGORY, data = mostRecent, sum, na.rm = TRUE))

# category_by_day |> addmargins() # useful for double-checking

# For display
# library(kableExtra)
# category_by_day |>
#  addmargins() |>
#  as.data.frame.matrix() |>
#  kable() |>
#  kable_styling(bootstrap_options = c("striped", "hover"))

summaryAgg <- recentCategory[recentCategory$CATEGORY != "Break",]

summaryAgg$exp <- c("Daily planning; log; computer maintenance", 
                    "Adjusting functions for 'brute force' fit approximation", 
                    "Trained multiple models toggling filters and features; created visualizations, especially the heatmap; wrote reports; studied causal inference; review meeting")

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Use the new re-imaged laptop for a week and let Luis know about performance (DONE)	
* Focus on the predictive decision tree for grades; can add features later (DONE)	
* Compare notes with Whitney on Friday's meeting; discuss UBox folders organization (DONE)
* Briefly take UBox training or familiarize on them (DONE)
* Send Luis a summary of my work on student course feedback (POSTPONED)
"

agendaItems <- 
  "
* Causal inference  
* Reporting formats 
* Laptop replacement or alternatives   
* Role progression
"

nextSteps <- 
  "
* Review Whitney's data and team results (logistic regression (Whitney) and catboost (Sara))
* Proceed to causal inference / recommendations in a two-step approach:     
  * Predict courses 
  * Predict grades in those courses 
  * Develop counter-factual tables  
  * Focus on predictions and model accuracy for years since Fall 2021
* Develop 'W' grade prediction model for math  
* PI Turnover:  
  * Modify functions to accept 'brute force' fit estimate  
  * Summarize progress 
  * Report to team  
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R"))
source(here::here("Send Email", "Send Email (To Luis).R"))