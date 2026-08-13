library(tidyverse)

trial <- read_csv("data/trial_data.csv")

plot1 <- ggplot(
  trial,
  aes(
    x = treatment,
    y = hba1c_6m
  )
) +
  geom_boxplot() +
  labs(
    title = "6-Month HbA1c by Treatment Group",
    x = "Treatment",
    y = "HbA1c"
  )

ggsave(
  "figures/hba1c_boxplot.png",
  plot1,
  width = 7,
  height = 5
)