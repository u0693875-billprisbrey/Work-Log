# Blastula Trial One script

# PURPOSE:  Send an rmarkdown as an e-mail from my university account.

library(blastula)
library(glue)

create_smtp_creds_key(
  id = "outlook",
  user = "u0693875@utah.edu",
  host = "smtp.utah.edu",
  port = 587,
  use_ssl = TRUE,
  overwrite = TRUE
)

# specify.options <- list(params = list(uid = identifier))

# rmarkdown::render(
#  input = here::here("Sandbox", "Blastula Trial One.Rmd")
# )

render_email(input = here::here("Sandbox", "Blastula Trial One.Rmd")
              ) |>
  smtp_send(
    from = "u0693875@utah.edu",  
    to=  "bill.prisbrey@utah.edu",
    subject = "Blastula Attempt One from Outlook",
    credentials = creds_anonymous(
      host = "smtp.utah.edu", 
      port = 587,
      use_ssl = TRUE
    )  
    
  )

# Let's try just sending something in another script




