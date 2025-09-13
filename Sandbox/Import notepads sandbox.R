# Import notepads sandbox

# SITUATION:  I tried using Excel Workbooks, but I kept having "recovery"
# issues where I had to carefully select the "ver 2" workbook, delete the original,
# and re-name.

# So I am going back to Notepad with triple-pipe deliminated fields 
# (instead of comma-separated values.)

# This sandbox will try to bring it in.

log_path <- "C:/Users/u0693875/Documents/Project Management/Work log/Notepad logs/Weekly Logs"

log_files <- list.files(path = log_path, pattern = "\\.txt$", full.names = TRUE) |>
  (\(x){x[!grepl("^~\\$", basename(x))] })()

df <- read.table("yourfile.txt", header = TRUE, sep = "|||", stringsAsFactors = FALSE)

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

library(lubridate)

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

# o.k., nice!

aggregate(diff ~ CATEGORY, data = log_data2[[1]], sum, na.rm=TRUE)

# ok, nice!

# before I do the report, I need to see if I can e-mail it.
# ...and maybe I just e-mail it from my gmail account?
# why not?


