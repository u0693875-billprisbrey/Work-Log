# Import Notebooks Sandbox

# PURPOSE:  Import and combine the Excel workbooks in my worklob folder.

library(readxl)

log_path <- "C:/Users/u0693875/Documents/Project Management/Work log/Excel logs/Weekly Logs"

list.files(path = log_path, pattern = "\\.xlsx$", full.names = TRUE)


C:\Users\u0693875\Documents\Project Management\Work log\Excel logs\Weekly Logs

log_files <- list.files(path = log_path, pattern = "\\.xlsx$", full.names = TRUE) |>
  (\(x){x[!grepl("^~\\$", basename(x))] })()


# let's read it

log_data <- lapply(log_files, function(f) {
  
  # Get all sheet names in the workbook
  sheets <- excel_sheets(f)
  
  # Read each sheet into a list
  sheet_list <- lapply(sheets, function(s) read_excel(path = f, sheet = s))
  
  # Name each sheet in the list
  names(sheet_list) <- sheets
  
  # Return the list of sheets for this workbook
  sheet_list
})

# Name the top-level list by workbook name
names(log_data) <- basename(log_files)

# Collapse into data frames
murray <- lapply(log_data, function(x){do.call(rbind, x)})

# Collapse all of them into a data frame
johnmeyer <- do.call(rbind, murray)

# process dates and times

johnmeyer$start_time <- hms::as_hms(johnmeyer$Start)
johnmeyer$end_time <- hms::as_hms(johnmeyer$Stop)

# Make sure Date column is Date class
johnmeyer$Date <- as.Date(johnmeyer$Date)

# Combine Date + Time into proper POSIXct
johnmeyer$Start_datetime <- as.POSIXct(johnmeyer$Date) + as.numeric(johnmeyer$start_time)
johnmeyer$End_datetime   <- as.POSIXct(johnmeyer$Date) + as.numeric(johnmeyer$end_time)

# ok, this is looking promising

johnmeyer$diff <- johnmeyer$End_datetime - johnmeyer$Start_datetime 

aggregate(diff ~ Category, johnmeyer, sum)

aggregate(diff ~ Category, johnmeyer, function(x) {sum(as.numeric(x, units =  "mins"))/60} )

# o.k. that more or less works.

# Now I need an rmarkdown report that does this
# And then I need to e-mail it


