# Notepad Email
# Load and Prep

library(lubridate)

##########
## LOAD ##
##########

# log_path <- "C:/Users/u0693875/Documents/Project Management/Work log/Notepad logs/Weekly Logs"

log_files <- list.files(path = here::here("Notepad Logs"), pattern = "\\.txt$", full.names = TRUE) |>
  (\(x){x[!grepl("^~\\$", basename(x))] })()

## PRE-CHECK MOST RECENT FILE ##

# Conduct a line-by-line check for five pipes
# I only want to do this for the last one / most recent one

# Identify most recent file
most_recent_file <- log_files |>
  file.info() |>
  (\(x){log_files[which.max(x$mtime)] })()

# Read as raw lines
lines <- readLines(most_recent_file)

# Count number of pipes in each line
pipe_counts <- sapply(gregexpr("\\|", lines), function(x) sum(x > 0))

# incorrect pipe counts

if(any(pipe_counts > 0 & pipe_counts < 5 )) {
  
  stop(
    
    paste(
      "Pipe count error:\n",
    paste(lines[which(pipe_counts != 5)], collapse = "\n")
    )
    
  )
  
}



# Inspect
# length(pipe_counts)
# table(pipe_counts)   # frequency table of pipe counts
# which(pipe_counts != 5)  # row numbers that aren't 5
# lines[which(pipe_counts != 5)]  # the actual problematic lines


# Conduct a row-wise test that all "STOP" is after all "START"

chron_check <- sapply(lines, function(x) {strsplit(x, "\\|")[[1]] } ) |>
  
  # (\(x){x[-1]})() |> # remove first line (header)
(\(x){
  
  chron_check_intermediate <- sapply(x[-1],
         function(y){
           
           parse_date_time(y[2], orders = "I:M p") <
             parse_date_time(y[3], orders = "I:M p")
           
         });
  
  return(chron_check_intermediate)
  
})()  

if(!all(chron_check, na.rm = TRUE)) {
  
  stop(
    
    paste(
      "Chronology error:\n",
      paste(names(chron_check)[!chron_check], collapse = "\n")
    )
    
  )
  
}


## READ FILES ##

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

###########
## CHECK ##
###########

mostRecent <- log_data[[basename(most_recent_file)]]

if(any(mostRecent$diff > 12) | any(mostRecent$diff < 0 ) ) {
 
  stop(
    
    paste("Time diff error",
  paste(mostRecent[mostRecent$diff > 12 | 
                     mostRecent$diff < 0,],
        collapse = "\n"
  ))
  )
} 

# shift column order
mostRecent <- mostRecent[,c("diff", colnames(mostRecent)[!colnames(mostRecent) %in% "diff"])]


###############
## AGGREGATE ##
###############

# different aggregatations
# recentCategory <- aggregate(diff ~ CATEGORY, data = mostRecent, sum, na.rm=TRUE)
# recentDay <- aggregate(diff ~ DATE, data = mostRecent, sum, na.rm=TRUE)
# recentWeek <- aggregate(diff ~ week(DATE), data = mostRecent, sum, na.rm=TRUE)

# dailyRowCount <- aggregate(diff ~ DATE, data = mostRecent, length)

###########
## CHECK ##
###########

# Check that START_dt and STOP_dt columns progress chronologically (each row is after the row preceding)




