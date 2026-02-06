# Notepad Email
# Multiple week prep

n_files <- 4 # number of recent files to process

library(lubridate)

##########
## LOAD ##
##########

# log_path <- "C:/Users/u0693875/Documents/Project Management/Work log/Notepad logs/Weekly Logs"

log_files <- list.files(path = here::here("Notepad Logs"), pattern = "\\.txt$", full.names = TRUE) |>
  (\(x){x[!grepl("^~\\$", basename(x))] })()

# Identify most recent n files
most_recent_files <- log_files |>
  file.info() |>
  (\(x){log_files[order(x$mtime, decreasing = TRUE)[1:n_files] ]})()

######################  
## CHECK LINE ENTRY ## 
######################

# Process in a loop

for (log in most_recent_files) {
  
  print(log)
  
  # Read as raw lines
  lines <- readLines(log)
  
  # Count number of pipes in each line
  pipe_counts <- sapply(gregexpr("\\|", lines), function(x) sum(x > 0))
  
  # incorrect pipe counts
  
  if(any(pipe_counts > 0 & pipe_counts < 5 )|any(pipe_counts > 5)) {
    
    stop(
      
      paste(
        "Pipe count error:\n",
        log,
        "\n",
        paste(lines[which(pipe_counts != 5)], collapse = "\n")
      )
      
    )
    
  }
  
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
        log,
        "\n",
        paste(names(chron_check)[!chron_check], collapse = "\n")
      )
      
    )
    
  }
  
}

##########
## READ ##
##########

log_lines <- setNames(vector("list", length(most_recent_files)), most_recent_files)


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

# In case of a warning:
# sapply(log_data, function(df) sum(is.na(df$START_dt)))

# log_data[basename(most_recent_file)]
# log_data[basename(most_recent_files)[2]]

################
## CHECK LOGS ##
################

# mostRecent <- log_data[[basename(most_recent_file)]]

counter <- 0
for(log in log_data[basename(most_recent_files)] ) {
counter <- counter + 1
  
if(any(log$diff > 12) | any(log$diff < 0 ) ) {
  
  stop(
    
    paste("Time diff error",
          basename(most_recent_files)[counter],
          paste(log[log$diff > 12 | 
                             log$diff < 0,],
                collapse = "\n"
          ))
  )
} 

}

#################
## PRE_PROCESS ##
#################

counter <- 0
log_data[basename(most_recent_files)] <- lapply(log_data[basename(most_recent_files)], function(df) {
  counter <- counter + 1
  
  # shift column orders
  df <- df[, c("diff", colnames(df)[colnames(df) != "diff"])]  
  
  # correct category capitalization
  categories <- unique(df$CATEGORY)
  
  if(length(unique(tolower(categories))) != length(categories)  ) {
    print(paste("Correcting capitalization error", basename(most_recent_files)[counter]))
    
    df$CATEGORY <- df$CATEGORY |>
      tolower() |>
      tools::toTitleCase() 
    
  }
  
  # confirm
  updatedCategories <-  unique(df$CATEGORY)
  if(length(updatedCategories) != length(unique(tolower(df$CATEGORY)))){
    stop(
      "Capitalization error persists; manually inspect and correct."
    )
  }
  
  return(df)
  
})

# Skipping the column shift for now

# shift column order
# mostRecent <- mostRecent[,c("diff", colnames(mostRecent)[!colnames(mostRecent) %in% "diff"])]


##########################
## CHRONOLOGICAL CHECKS ##
##########################

for(log in log_data[basename(most_recent_files)]) {
  
  # Date discontinuity
  
  if(any(diff(log$DATE) < 0 | diff(log$DATE) > 1 )){
    
    stop(
      paste("Date discontinuity error:\n", 
            log$DATE[diff(log$DATE) < 0 | diff(log$DATE) > 1  ],
            collapse = "\n"
      )
    )
    
  }
  
  # Chronological progression
  # Check that START_dt and STOP_dt columns progress chronologically (each row is after the row preceding)
  
  startChron <- diff(order(log$START_dt))
  stopChron <- diff(order(log$STOP_dt))
  
  column_chron_check <- all(startChron == 1) & all(stopChron == 1)
  
  
  if(!column_chron_check) {
    
    stop(
      
      paste("Column chronology error:\n",
            paste(capture.output(print(log[startChron !=1 | 
                                                    stopChron !=1, c("diff","DATE","START","STOP") ])),
                  collapse = "\n"
            ))
    )
  } 
  
}
