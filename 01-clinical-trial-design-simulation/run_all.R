dirs <- c("data", "output/tables", "output/figures", "docs")
invisible(lapply(dirs, dir.create, recursive = TRUE, showWarnings = FALSE))

source("src/functions.R")
write.csv(simulate_trial_dataset(), "data/simulated_trial.csv", row.names = FALSE)
source("src/01_sample_size.R")
source("src/02_power_simulation.R")
source("src/03_figures.R")

if (file.exists("/Applications/quarto/bin/tools/aarch64/pandoc")) {
  # Standard macOS Quarto installation path; rmarkdown reads this variable.
  Sys.setenv(RSTUDIO_PANDOC = "/Applications/quarto/bin/tools/aarch64")
}
rmarkdown::render(
  "report/analysis-report.Rmd",
  output_file = "index.html",
  output_dir = "docs",
  quiet = TRUE,
  envir = new.env(parent = globalenv())
)
capture.output(sessionInfo(), file = "output/session-info.txt")
message("Project 01 pipeline complete. Open docs/index.html.")
