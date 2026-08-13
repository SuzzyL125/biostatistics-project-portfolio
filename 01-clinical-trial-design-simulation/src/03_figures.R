library(ggplot2)

power_curves <- read.csv("output/tables/analytical_power_curves.csv")
p1 <- ggplot(power_curves, aes(n_total, power, color = factor(effect))) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = c(0.80, 0.90), linetype = "dashed", color = "grey45") +
  scale_color_brewer(palette = "Dark2", name = "Effect (mmHg)") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0, 1)) +
  labs(title = "Analytical Power by Total Randomized Sample Size",
       subtitle = "Two-sided alpha = 0.05; outcome SD = 15 mmHg; 1:1 allocation",
       x = "Total randomized sample size", y = "Power") +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom")
ggsave("output/figures/power_curves.png", p1, width = 7.5, height = 4.8, dpi = 180)

sim <- read.csv("output/tables/simulation_power_results.csv")
sim$allocation <- ifelse(sim$allocation_ratio == 1, "1:1", "2:1")
p2 <- ggplot(sim, aes(factor(dropout), empirical_power, color = factor(effect), group = effect)) +
  geom_hline(yintercept = 0.80, linetype = "dashed", color = "grey45") +
  geom_point(size = 2) + geom_line() +
  facet_grid(baseline_correlation ~ allocation,
             labeller = label_both) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0.60, 1)) +
  scale_color_brewer(palette = "Dark2", name = "Effect (mmHg)") +
  labs(title = "Simulation-Estimated Power Under Design Sensitivities",
       x = "Dropout proportion", y = "Empirical power") +
  theme_minimal(base_size = 10) + theme(legend.position = "bottom")
ggsave("output/figures/simulation_power_sensitivity.png", p2, width = 8.2, height = 5.5, dpi = 180)

