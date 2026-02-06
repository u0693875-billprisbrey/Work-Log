# Send email script

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

signature <- add_image(file = here::here("Signatures", "Signature vB0.png"))

  
body_text <- 
  md(glue(
    
    "
    Hi Luis,
    
    Here is a summary of time spent on projects the last few weeks, assignments, discussion items, and possible next steps.
    
    Projects worked on:
    
    {map(summaries, ~kbl(.x,
  col.names = c('Category', 'Hrs', 'Activities'),
  row.names = FALSE)) |> 
  paste(collapse = '\n\n')}
    
    Assignments:  
    
    {assignments} 
    
    To discuss: 
    
    {agendaItems}
    
    Next steps: 
    
    {nextSteps}
    
    Thanks,   
     -Bill  
     
     
    {signature}
     
     
    *Daily log:*
    
    {map(activities, ~dailyDisplay(.x[['daily']])) |>
  paste(collapse = '\n\n')}
    
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
    to =  "luis.oquendo@utah.edu",
    cc =  "bill.prisbrey@utah.edu",
    bcc = "bill.prisbrey@gmail.com",
    subject = "Weekly activity and meeting preparation",
    credentials = creds_key("outlook")
  )

