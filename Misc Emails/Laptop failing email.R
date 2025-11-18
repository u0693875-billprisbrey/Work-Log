# Laptop problems

# PURPOSE:  This document pulls in all notepad logs, examines the logs related to
# laptop problems, summarizes, and send via e-mail. 



##########
## LOAD ##
##########

library(lubridate)

# Because each log has been individually inspected, I should be able to read them all in

log_files <- list.files(path = here::here("Notepad Logs"), pattern = "\\.txt$", full.names = TRUE) |>
  (\(x){x[!grepl("^~\\$", basename(x))] })()

log_data <- lapply(log_files, function(f) { 
  
  read.table(f, 
             header = TRUE,
             sep = "|",
             stringsAsFactors = FALSE,
             strip.white = TRUE,
             quote = "",
             na.strings = c("", " "),
             fill = TRUE)
  
})

names(log_data) <- basename(log_files)

##########
## PREP ##
##########

log_data <- lapply(log_data, function(df) {
  
  # Replace empty strings and whitespace-only strings with NA
  df[df == "" | grepl("^\\s*$", df)] <- NA
  
  # convert to date
  df$DATE <- as.Date(df$DATE, format = "%m/%d/%Y")  
  
  df$START_dt <- parse_date_time(paste(df$DATE, df$START),
                                 orders = "ymd I:M p")
  df$STOP_dt  <- parse_date_time(paste(df$DATE, df$STOP),
                                 orders = "ymd I:M p")
  # calculate time difference
  df$diff <- as.numeric(difftime(df$STOP_dt, df$START_dt, units =  "mins"))/60
  
  df
  
})

log_frame <- do.call(rbind, log_data) 

#################
## INVESTIGATE ##
#################

searchPhrase <- "lapt|re-boot"

log_frame$laptop_problems <- NA
log_frame$laptop_problems[grepl(searchPhrase, tolower(log_frame$ACTIVITIES)) |
                          grepl(searchPhrase, tolower(log_frame$NOTES ))] <- TRUE

# View(log_frame[log_frame$laptop_problems & !is.na(log_frame$laptop_problems),]) 
  # a lot of these are fine
  # I missed some of them
  # not bad for an estimate

lost_hours <- sum(log_frame$diff[log_frame$laptop_problems & !is.na(log_frame$laptop_problems)]) 

signature <- add_image(file = here::here("Signatures", "Signature vB0.png"))

problem_summary <- 
"
* Computer fails to start up (in the morning, after re-start, or after force-quit) 
* Search window cycles without summoning a menu; no programs can be opened   
* Computer becomes non-responsive; mouse is movable but nothing interacts  
* Computer runs slowly  
* Computer re-boots overnight, interupting programs that require several hours and that slow the laptop if run while working during the day  
"

history <- 
  "
  * 9/9/2025: Slow computer noted for INC2107673 (45min to install 9 updates and 15-20min to re-start)
  * 9/23/2025: For TASK1250380, Zhaoyi Yang recorded: 'Observed slowness; . . . proposed for a rebuild.'  Loaner laptop obtained.
  * 9/24/2025: Laptop re-imaged; kept loaner in case the re-imaged laptop failed.  
  * 10/8/2025: Returned loaner. 
  * 10/23/2025: Re-imaged laptop failed to start after several re-boots; took downtown for re-configuring 
  * 11/13/2025: Re-imaged and re-configured laptop required three re-boots before starting    
"
  
impact <- glue(
  "An estimated {lost_hours} hours of directly lost productivity has been spent since 9/9/2025 on 
  setting up the loaner and then the re-imaged laptop; re-configuring the re-imaged laptop downtown after it failed; and travel. 
  A greater impact could be calculated by estimating lost time due to slowness and
  re-starting lengthy programs that fail overnight. 
"
)

body_text <- 
  md(glue(
    
"
Hi Luis,

Following is a brief summary of my laptop that has recently started to fail.

Thank you,  
  
Bill  

{signature}

## **LAPTOP IS SLOW AND SPORADICALLY FAILS**

### *PROBLEM SUMMARY* 
{problem_summary}

### *HISTORY* 
{history}

### *IMPACT* 
{impact}


"    
    
    
)
)

sending_date <-
  paste0(
    format(Sys.time(), "%A, %B "),
    format(Sys.time(), "%d") %>% as.numeric(),
    ", ",
    format(Sys.time(), "%Y")
  )

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
    to =  "luis.oquendo@utah.edu",
    cc =  "bill.prisbrey@utah.edu",
    bcc = "bill.prisbrey@gmail.com",
    subject = "Laptop recently started failing",
    credentials = creds_key("outlook")
  )



