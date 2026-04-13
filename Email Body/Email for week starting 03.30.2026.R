# Email for week starting 03.30.2026  

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

explanations <- c("Job Mngt" = "Daily planning; weekly log; UAIR meetings", 
                  "Predict Math Success" = "Optimizing models without caret; deep dive report",
                  "PI Turnover" = "",
                  "Gray DI" = "Training series and notes",
                  "Prof Dev" = "",
                  "Vacation" = "vacation",
                  "Explore Completion Predictors" = "Brain-storming drivers; examining COMBINED_DEGREE_V column by column; down-selecting columns for modeling; writing report"
)  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Add two appendices: Sneak Preview and comparing predictions without test scores 
* Write up a brief summary of student course feedback work  
* Review conferences and possible submission titles for papers, prioritizing student course feedback  
* Review Roles & Responsibilities and HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist
"

agendaItems <- 
  "
  * See next email
"

nextSteps <- 
  "
* Complete Phase 2 (Course Guide and Estimate Academic Impact)  
* PI Turnover:  Review snapshot query from HR and write summary before pausing project      
* Develop Gray DI analytical approach based on internal objectives and data availability IN PROGRESS   
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email (To Luis).R"))