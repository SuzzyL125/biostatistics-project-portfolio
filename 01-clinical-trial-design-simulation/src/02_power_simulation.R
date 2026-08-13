source("src/functions.R")

scenarios <- expand.grid(
  effect = c(3, 5, 7),
  sd = 15,
  dropout = c(0.05, 0.10, 0.20),
  allocation_ratio = c(1, 2),
  baseline_correlation = c(0.30, 0.60),
  KEEP.OUT.ATTRS = FALSE
)

results <- vector("list", nrow(scenarios))
for (i in seq_len(nrow(scenarios))) {
  s <- scenarios[i, ]
  n_total <- analytical_sample_size(
    effect = s$effect, sd = s$sd, power = 0.80,
    dropout = s$dropout, allocation_ratio = s$allocation_ratio
  )["total"]
  results[[i]] <- simulate_power(
    n_total = n_total, nsim = 1000, effect = s$effect, sd = s$sd,
    baseline_correlation = s$baseline_correlation,
    dropout = s$dropout, allocation_ratio = s$allocation_ratio,
    seed = 2026 + i
  )
}
simulation_results <- do.call(rbind, results)
write.csv(simulation_results, "output/tables/simulation_power_results.csv", row.names = FALSE)

