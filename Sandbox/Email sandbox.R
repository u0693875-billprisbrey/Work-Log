# Email sandbox

# Pull in the log

##########
## LOAD ##
##########

log_path <- "C:/Users/u0693875/Documents/Project Management/Work log/Notepad logs/Weekly Logs"

log_files <- list.files(path = log_path, pattern = "\\.txt$", full.names = TRUE) |>
  (\(x){x[!grepl("^~\\$", basename(x))] })()

log_data <- lapply(log_files, function(f) { 
  
  read.table(f, 
             header = TRUE,
             sep = "|",
             stringsAsFactors = FALSE,
             strip.white = TRUE,
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

summaryAgg <- aggregate(diff ~ CATEGORY, data = log_data[[1]], sum, na.rm=TRUE)

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
    
    Let's see if this table works.
    
    {kbl(summaryAgg)}
    
    And I want to talk about  
    
    * Lucy
    * In the sky
    * with Diamonds
    
    Thanks,
    - Bill
    "
    
  ))

footer_text <- glue("Sent on {sending_date}.")

create_smtp_creds_key(
  id = "outlook",
  user = "u0693875@utah.edu",
  host = "smtp.utah.edu",
  port = 587,
  use_ssl = TRUE,
  overwrite = TRUE
)

# The system key store has been updated with the "blastula-v1-outlook" key with the `id` value "outlook".
# * Use the `view_credential_keys()` function to see all available keys
# * You can use this key within `smtp_send()` with `credentials = creds_key("outlook")`



compose_email(
  body = body_text,
  footer = footer_text
) |>
  smtp_send(
    from = "u0693875@utah.edu",  
    to=  "bill.prisbrey@utah.edu",
    subject = "Blastula Attempt One from Outlook",
    credentials = creds_key("outlook")
  )
