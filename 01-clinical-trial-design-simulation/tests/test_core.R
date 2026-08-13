source("src/functions.R")

n <- analytical_sample_size(effect = 5, sd = 15, power = 0.80, dropout = 0.10)
stopifnot(n["control"] == n["treatment"], n["total"] > 0)

n_low <- analytical_sample_size(effect = 3, sd = 15, power = 0.80)["total"]
n_high <- analytical_sample_size(effect = 7, sd = 15, power = 0.80)["total"]
stopifnot(n_low > n_high)

n_80 <- analytical_sample_size(effect = 5, sd = 15, power = 0.80)["total"]
n_90 <- analytical_sample_size(effect = 5, sd = 15, power = 0.90)["total"]
stopifnot(n_90 > n_80)

trial <- simulate_trial_dataset(n_total = 100, seed = 1)
stopifnot(nrow(trial) == 100, length(unique(trial$participant_id)) == 100,
          all(trial$treatment %in% c("Treatment A", "Placebo")))

quick <- simulate_power(n_total = 200, nsim = 100, seed = 2)
stopifnot(quick$empirical_power >= 0, quick$empirical_power <= 1,
          is.finite(quick$mean_estimate))

message("All core tests passed.")

