# Email Body

# Load and Prep

library(kableExtra)
library(blastula)
library(glue)

source(here::here("Prep", "Notepad Email Prep.R"))

##################
## Aggregations ##
##################

recentCategory <- aggregate(diff ~ CATEGORY, data = mostRecent, sum, na.rm=TRUE)

summaryAgg <- recentCategory[recentCategory$CATEGORY != "Break",]

summaryAgg$exp <- c("Math courses exploratory data analysis", "Learning hour; developing log script", "Business framing and instructor variation reports; kick-off and data review meetings")

####################
## EMAIL SECTIONS ##
####################

assignments <- 
"
* Get onto J drive (DONE)
* Send Luis a summary of my work on student course feedback (DELAYED)
"

agendaItems <- 
"
* How should I organize my folders in UBox?
"

nextSteps <- 
"
* Revise Business Framing per notes and feedback    
* Write Analytical Framing document 
* Write feature engineering and develop first pass decision tree model
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
    
    Here is a summary of time spent on projects this week, assignments, discussion items, and possible next steps.
    
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
