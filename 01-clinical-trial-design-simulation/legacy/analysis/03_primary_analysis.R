library(tidyverse)
library(broom)

trial <- read_csv("data/trial_data.csv")

model <- lm(
  hba1c_6m ~
    treatment +
    hba1c_bl +
    age +
    sex,
  data = trial
)

summary(model)

results <- tidy(model)
results
write_csv(
  results,
  "outputs/primary_analysis_results.csv"
)

print(results)