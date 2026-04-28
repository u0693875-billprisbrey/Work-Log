# Email for week starting 04.13.2026  

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

explanations <- c("Job Mngt" = "UAIR meetings; laptop transfer; Jira; career advancement plan", 
                  "Predict Math Success" = "",
                  "PI Turnover" = "",
                  "Student Course Feedback" = "Writing overview of work completed",
                  "Gray DI" = "",
                  "Prof Dev" = "Agentic AI and ellmer package",
                  "Vacation" = "",
                  "Explore Completion Predictors" = "Querying COURSE data by term; comparing to DEGREE data; reviewing prior work on years to graduate",
                  "Forecast Completion Rates" = "Developing approach; simulating data for potential use with LLM" 
)  

summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Add two appendices: Sneak Preview and comparing predictions without test scores POSTPONED
* Write up a brief summary of student course feedback work  DONE
* Review conferences and possible submission titles for papers, prioritizing student course feedback  
* Review Roles & Responsibilities and HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist ADVANCEMENT PLAN WRITTEN; DONE
"

agendaItems <- 
  "
  See next email
"

nextSteps <- 
  "
See next email
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email (To Luis).R"))