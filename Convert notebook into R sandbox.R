# Converting notebook log into R
# 9.5.2025

library(lubridate)

monday <- data.frame(start = hm(c("9:30","10:45")),
                     stop = hm(c("10:45","5:00")),
                     project = c("Job Mngt", "PI Turnover"),
                     notes = c("Writing up last week; setting weekly priorities", "Writing up slow computer issue; setting up and cancelling status update meeting; developing SQL query based on R code; developing queries per diff't 'regimes'; running queries in background; updating individual journey app to operate on the query for a single individual"))

tuesday <- data.frame(start = hm(c("8:30","8:45", "11:45", "1:00", "1:30", "2:30", "3:00", "4:30")),
                      stop = hm(c("8:45", "11:45", "1:00", "1:30", "2:30", "3:00", "4:30", "5:00")),
                      project = c("Job Mngt", "PI Turnover", "Lunch", "Job Mngt", "PI Turnover", "Break", "PI Turnover", "Job Mngt"),
                      notes = c("reviewing and sending emails; setting priorities for the day",
                                "working on Individual Journey app (trying to get query to work)",
                                "Lunch",
                                "reviewed email and attachments on low enrollment/salary; made notes",
                                "app now displays data",
                                "Break",
                                "processing data; plotting data; adding notes input ability",
                                "watching training videos, key concepts 1 & 2"
                                )
                      )

# I should just save this into a csv or spreadsheet, then load it in here
# For today, I'm just going to do the start and stop times.
# Wow even that is hard.
# I think I'll try using a csv going forward.

# This is unwieldy.




