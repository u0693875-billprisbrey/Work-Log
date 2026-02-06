# Email for month starting 01.12.2026  

# Load and Prep

library(kableExtra)
library(blastula)
library(glue)
library(purrr)

source(here::here("Prep", "Notepad Email Multiple Week Prep.R"))


##################
## Aggregations ##
##################

# put files in chronological, not saved, order

file_order <- most_recent_files |>
  basename() |>
  (\(x){ gsub("Week starting |.txt", "", basename(most_recent_files)) })() |>
  mdy() |>
  order()

activities <- lapply(log_data[basename(most_recent_files[file_order])], function(log){
  
  recentCategory <- aggregate(diff ~ CATEGORY, data = log, sum, na.rm=TRUE)
  dailyActivity <- aggregate(diff ~ DATE, data = log, sum, na.rm = TRUE)
  
  category_by_day <- xtabs(diff ~ DATE + CATEGORY, 
                           data = aggregate(diff ~ DATE + CATEGORY, data = log, sum, na.rm = TRUE))
  
  return(list(category = recentCategory,
              activity = dailyActivity,
              daily = category_by_day
              ))
  
})





# recentCategory <- aggregate(diff ~ CATEGORY, data = mostRecent, sum, na.rm=TRUE)
# dailyActivity <- aggregate(diff ~ DATE, data = mostRecent, sum, na.rm = TRUE)
# category_by_day <- xtabs(diff ~ DATE + CATEGORY, 
#                         data = aggregate(diff ~ DATE + CATEGORY, data = mostRecent, sum, na.rm = TRUE))

# category_by_day |> addmargins() # useful for double-checking

dailyDisplay <- function(category_by_day) {
  # For display
  
  category_by_day |>
    addmargins() |>
    as.data.frame.matrix() |>
    kable() |>
    kable_styling(bootstrap_options = c("striped", "hover"))
  
}  

# dailyDisplay(activities[[1]][["daily"]])

summaryAgg <- lapply(activities, function(act){
  
  # print(act[["category"]] )
  
  act[["category"]][act[["category"]]["CATEGORY"] != "Break", ]
  
})

# summaryAgg <- recentCategory[recentCategory$CATEGORY != "Break",]

checkTime <- function(agg){
  sum(agg$diff)
}

sapply(summaryAgg, checkTime)

# mostRecent[mostRecent$CATEGORY == "Job Mngt",]
# mostRecent[mostRecent$CATEGORY == "Study Causal Inference",]

explanations <- list( 
   "Week starting 01.12.2026.txt" = c(
     "Job Mngt" =  "Jira training; Draft of development plan",
       "Predict Math Success" = "Counterfactuals; Quarto report; Mahalonobis & PCA"
   ),
     
   "Week starting 01.26.2026.txt" = c("Job Mngt" = "Jira; computer crashes; networking", "Predict Math Success" = "Training on PCA components; grades over time with z-score distances"),
   "Week starting 02.02.2026.txt" = c("Job Mngt" = "Jira; UAIR training; four weekly logs" , "Predict Math Success" = "Courses over time with z-score distances", "Vacation" = "Vacation"),
   "Week starting 01.19.2026.txt" = c("Job Mngt" = "Laptop repair", "Predict Math Success" = "Wrangling with PCA", "Travel" = "Travel", "Prof Dev" = "Causal Inference", "Holiday" = "Holiday")
)

summaries <- setNames(vector("list", length = n_files), basename(most_recent_files))

summaries <- lapply(names(summaryAgg), function(agnm){ 
  
  summary <- merge(summaryAgg[[agnm]], as.data.frame(explanations[[agnm]]), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )
  colnames(summary)[colnames(summary) == "explanations[[agnm]]" ] <- "description"
  return(summary)
  } )
names(summaries) <- names(summaryAgg)

# summaryAgg <- merge(summaryAgg, as.data.frame(explanations), by.x = "CATEGORY", by.y = "row.names", all.x = TRUE )


####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Complete training using distance derived from z-scores (DONE)
* Complete the write-up
* Review Roles & Responsibilities and HR guidelines and put together a plan for title change to Senior/Lead/Principal Data Scientist 
"

agendaItems <- 
  "
  * Laptop replacement and VM progress    
  * Possible vacation time error  
  * Jira  
    * Track hours there ?
    * Create epic ?
    * Entries complete ?  
  * Promotion plan and conferences  
  * HR analytics given additional headcount loss  
  * Simulations in Excel  
  * Discuss bi-weekly Kronos replacement 
      * No more reminders?    
      * Sick hours for doctor's appointments?  
"

nextSteps <- 
  "
* Update sections with z-score distance 
* Write summaries and main summary  
* PI Turnover:  Review snapshot query from HR and write summary before pausing project    
"

################
## SEND EMAIL ##
################

# source(here::here("Send Email", "Send Email  Multiple Weeks (To Prisbrey Only).R")) 
source(here::here("Send Email", "Send Email Multiple Weeks (To Luis).R"))
