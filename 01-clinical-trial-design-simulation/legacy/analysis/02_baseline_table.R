library(tidyverse)
library(gtsummary)
library(dplyr)
library(gt)

trial <- read_csv("data/trial_data.csv")

table1 <- trial %>%
  
  select(
    treatment,
    age,
    sex,
    hba1c_bl,
    hba1c_3m,
    hba1c_6m
  ) %>%
  
  tbl_summary(
    
    by = treatment,
    
    label = list(
      age ~ "Age, years",
      sex ~ "Sex",
      hba1c_bl ~ "Baseline HbA1c (%)",
      hba1c_3m ~ "HbA1c at 3 Months (%)",
      hba1c_6m ~ "HbA1c at 6 Months (%)"
    ),
    
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    
    digits = list(
      all_continuous() ~ 2
    ),
    
    missing = "no"
    
  ) %>%
  
  add_p() %>%
  
  bold_labels() %>%
  
  modify_header(
    label ~ "**Characteristic**"
  ) %>%
  
  modify_caption(
    "**Table 1. Baseline Characteristics by Treatment Group**"
  )
table1
