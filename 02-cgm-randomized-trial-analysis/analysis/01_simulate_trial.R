library(tidyverse)

set.seed(2026)

n = 200

trial <- tibble(
  id = 1:n,

  treatment = sample(
    c("CGM", "Standard Care"),
    n,
    replace = TRUE
  ),

  age = round(rnorm(n, 60, 8)),

  sex = sample(
    c("Male", "Female"),
    n,
    replace = TRUE
  ),

  hba1c_bl = round(
    rnorm(n, 8.5, 1),
    1
  )
)

trial <- trial %>%
  mutate(

    hba1c_3m =
      hba1c_bl -
      ifelse(
        treatment == "CGM",
        rnorm(n, 0.8, 0.4),
        rnorm(n, 0.4, 0.4)
      ),

    hba1c_6m =
      hba1c_bl -
      ifelse(
        treatment == "CGM",
        rnorm(n, 1.3, 0.5),
        rnorm(n, 0.7, 0.5)
      )
  )

write_csv(
  trial,
  "data/trial_data.csv"
)

print(head(trial))