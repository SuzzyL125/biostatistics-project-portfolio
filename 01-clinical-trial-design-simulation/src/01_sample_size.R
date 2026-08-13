source("src/functions.R")

grid <- expand.grid(
  effect = c(3, 5, 7),
  sd = c(10, 15, 20),
  power = c(0.80, 0.90),
  dropout = c(0.05, 0.10, 0.20),
  KEEP.OUT.ATTRS = FALSE
)

sizes <- t(mapply(
  analytical_sample_size,
  effect = grid$effect, sd = grid$sd, power = grid$power,
  dropout = grid$dropout
))
sample_sizes <- cbind(grid, as.data.frame(sizes))
sample_sizes <- sample_sizes[order(sample_sizes$effect, sample_sizes$sd,
                                   sample_sizes$power, sample_sizes$dropout), ]
write.csv(sample_sizes, "output/tables/analytical_sample_size_grid.csv", row.names = FALSE)

curve_grid <- expand.grid(
  n_total = seq(40, 600, by = 10), effect = c(3, 5, 7), sd = 15
)
curve_grid$power <- with(curve_grid, {
  1 - pnorm(qnorm(0.975) - effect / (sd * sqrt(4 / n_total)))
})
write.csv(curve_grid, "output/tables/analytical_power_curves.csv", row.names = FALSE)

