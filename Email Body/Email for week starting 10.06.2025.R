# Email for week starting 10.06.2025

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

summaryAgg <- recentCategory[recentCategory$CATEGORY != "Break",]

summaryAgg$exp <- c("Daily planning & log", "Applied 'brute force' approximation to employees with concurrent jobs", "Trained models on Whitney's data; using feature engineering; and on first math classes", "Travel (returning laptop loaner)" )

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
"

nextSteps <- 
  "
* Review Whitney's data and results
* Possibly proceed to causal inference / recommendations    
  * Predict courses 
* Improve 'W' grade prediction model
* PI Turnover:  Estimate headcount with 'brute force' fit estimate  
* Train new models on first-math-class-only data using regression; other adjustments per meeting notes (DONE)
* Add features and feature engineering to tree models, esp course load (DONE)
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R"))
source(here::here("Send Email", "Send Email (To Luis).R"))