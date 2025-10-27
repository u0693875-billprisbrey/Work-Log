# Email for week starting 10.20.2025

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

# For display
# library(kableExtra)
# category_by_day |>
#  addmargins() |>
#  as.data.frame.matrix() |>
#  kable() |>
#  kable_styling(bootstrap_options = c("striped", "hover"))

summaryAgg <- recentCategory[recentCategory$CATEGORY != "Break",]

summaryAgg$exp <- c("Daily log and report; managing crashed laptop", "Wrote reports on 'brute force' algorithm; modified functions and improved visualizations; met with sponsor and HR", "Wrote minority class proposal; reviewed logistic regression and catboost models; studied causal inference", "Travel (handing laptop to IT; internal networking)" )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Complete proposal to focus on the minority class and send to team to discuss on the 27th (DONE)
* Predict 'W' with current variables  	
* Review HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist 
* Spend max of four hours a week on causal inference 
"

agendaItems <- 
  "
* Laptop replacement and virtual machine alternative  
* Title change to Senior/Principal/Lead Data Scientist  
"

nextSteps <- 
  "
* Summarize predictive models and key findings so far for general audience unfamiliar with both math courses and machine learning 
* Proceed to recommendations  
*    Experiment with prediction thresholds and the precision/recall tradeoff    
*    Develop counter-factuals   
*    Explore predicting courses 
*    Explore changes over time in predictors  
* Develop 'W' grade prediction model for first math courses 
* PI Turnover:  Review snapshot query to be provided by HR and compare to 'brute force' algorithm 
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R"))
 source(here::here("Send Email", "Send Email (To Luis).R"))