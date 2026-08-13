analytical_sample_size <- function(effect, sd, power = 0.80, alpha = 0.05,
                                   dropout = 0, allocation_ratio = 1) {
  stopifnot(effect > 0, sd > 0, power > 0, power < 1,
            alpha > 0, alpha < 1, dropout >= 0, dropout < 1,
            allocation_ratio > 0)
  z_alpha <- qnorm(1 - alpha / 2)
  z_power <- qnorm(power)
  r <- allocation_ratio
  n_control_complete <- ((z_alpha + z_power)^2 * sd^2 * (1 + 1 / r)) / effect^2
  n_treatment_complete <- r * n_control_complete
  n_control <- ceiling(n_control_complete / (1 - dropout))
  n_treatment <- ceiling(n_treatment_complete / (1 - dropout))
  c(control = n_control, treatment = n_treatment,
    total = n_control + n_treatment)
}

simulate_one_trial <- function(n_total, effect = 5, sd = 15,
                               baseline_correlation = 0.60,
                               dropout = 0.10, allocation_ratio = 1,
                               alpha = 0.05) {
  stopifnot(n_total >= 20, abs(baseline_correlation) < 1)
  p_treatment <- allocation_ratio / (1 + allocation_ratio)
  treatment <- rbinom(n_total, 1, p_treatment)
  baseline <- rnorm(n_total, mean = 140, sd = sd)
  residual_sd <- sd * sqrt(1 - baseline_correlation^2)
  followup <- 140 + baseline_correlation * (baseline - 140) -
    effect * treatment + rnorm(n_total, 0, residual_sd)

  # Missing completely at random for the primary design scenario.
  observed <- rbinom(n_total, 1, 1 - dropout) == 1
  dat <- data.frame(treatment, baseline, followup, observed)
  fit <- lm(followup ~ treatment + baseline, data = dat[dat$observed, ])
  estimate <- unname(coef(fit)["treatment"])
  ci <- confint(fit, "treatment", level = 1 - alpha)
  p_value <- coef(summary(fit))["treatment", "Pr(>|t|)"]
  c(estimate = estimate, ci_low = ci[1], ci_high = ci[2],
    p_value = p_value, significant = as.integer(p_value < alpha),
    analyzed_n = sum(observed))
}

simulate_power <- function(n_total, nsim = 1000, effect = 5, sd = 15,
                           baseline_correlation = 0.60, dropout = 0.10,
                           allocation_ratio = 1, alpha = 0.05, seed = 2026) {
  set.seed(seed)
  sims <- replicate(nsim, simulate_one_trial(
    n_total = n_total, effect = effect, sd = sd,
    baseline_correlation = baseline_correlation, dropout = dropout,
    allocation_ratio = allocation_ratio, alpha = alpha
  ))
  sims <- as.data.frame(t(sims))
  power <- mean(sims$significant)
  mcse <- sqrt(power * (1 - power) / nsim)
  data.frame(
    n_total = n_total, nsim = nsim, effect = effect, sd = sd,
    baseline_correlation = baseline_correlation, dropout = dropout,
    allocation_ratio = allocation_ratio, empirical_power = power,
    mcse = mcse, mean_estimate = mean(sims$estimate),
    bias = mean(sims$estimate) + effect,
    mean_analyzed_n = mean(sims$analyzed_n)
  )
}

simulate_trial_dataset <- function(n_total = 200, effect = 5, sd = 15,
                                   baseline_correlation = 0.60,
                                   dropout = 0.10, seed = 2026) {
  set.seed(seed)
  treatment <- rbinom(n_total, 1, 0.5)
  baseline <- rnorm(n_total, 140, sd)
  followup <- 140 + baseline_correlation * (baseline - 140) -
    effect * treatment + rnorm(n_total, 0, sd * sqrt(1 - baseline_correlation^2))
  observed <- rbinom(n_total, 1, 1 - dropout) == 1
  data.frame(
    participant_id = seq_len(n_total),
    treatment = ifelse(treatment == 1, "Treatment A", "Placebo"),
    baseline_sbp = round(baseline, 1),
    week12_sbp = ifelse(observed, round(followup, 1), NA),
    completed_week12 = observed
  )
}

