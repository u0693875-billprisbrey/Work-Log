# Email for week starting 9.29.2025

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

summaryAgg$exp <- c("Daily planning & log", "Evaluted and reported on five models", "External networking and continuing education","Travel" )

####################
## EMAIL SECTIONS ##
####################

assignments <- 
  "
* Use the new re-imaged laptop for a week and let Luis know about performance (IN PROGRESS)	
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
* Train new models on first-math-class-only data using regression; other adjustments per meeting notes 
* Add features and feature engineering to tree models, esp course load
* Possibly proceed to causal inference 
* Improve 'W' grade prediction model
"
###########
## EMAIL ##
###########

sending_date <-
  paste0(
    format(Sys.time(), "%A, %B "),
    format(Sys.time(), "%d") %>% as.numeric(),
    ", ",
    format(Sys.time(), "%Y")
  )

body_text <- 
  md(glue(
    
    "
    Hi Luis,
    
    Here is a summary of time spent on projects last week, assignments, discussion items, and possible next steps.
    
    Projects worked on:
    
    {kbl(summaryAgg,
    col.names = c('Category', 'Hrs', 'Activities'),
    row.names = FALSE)}
    
    Assignments:  
    
    {assignments} 
    
    To discuss: 
    
    {agendaItems}
    
    Next steps: 
    
    {nextSteps}
    
    Thanks,
     -Bill
    "
    
  ))

footer_text <- glue("Sent on {sending_date}.")

# Mail

create_smtp_creds_key(
  id = "outlook",
  user = "u0693875@utah.edu",
  host = "smtp.utah.edu",
  port = 587,
  use_ssl = TRUE,
  overwrite = TRUE
)

compose_email(
  body = body_text,
  footer = footer_text
) |>
  smtp_send(
    from = "u0693875@utah.edu",  
    to = "luis.oquendo@utah.edu",
    cc =  "bill.prisbrey@utah.edu",
    bcc = "bill.prisbrey@gmail.com",
    subject = "Weekly activity and meeting preparation",
    credentials = creds_key("outlook")
  )