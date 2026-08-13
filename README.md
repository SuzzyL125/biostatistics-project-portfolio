# Biostatistics & Healthcare Data Science Portfolio

Applied projects in clinical-trial design, clinical data analysis, health-services research, survival analysis, and causal inference. Each numbered folder is a standalone work sample with code, data, outputs, and documentation.

## Featured projects

| No. | Project | Research question | Methods and deliverables |
|---:|---|---|---|
| 01 | [Clinical Trial Design & Power Simulation](01-clinical-trial-design-simulation/) | How many participants are required under different effects, variability, allocation ratios, and dropout assumptions? | Analytical sample size, Monte Carlo power, ANCOVA, sensitivity analysis, tested R functions, HTML report |
| 02 | [CGM Randomized Trial Analysis](02-cgm-randomized-trial-analysis/) | Does continuous glucose monitoring improve six-month HbA1c compared with standard care? | Trial-data simulation, baseline table, adjusted ANCOVA, results table, clinical visualization |
| 03 | [Provider Variation & Fixed-Effects Analysis](03-provider-variation-fixed-effects/) | How much variation in early palliative-care billing is associated with physicians and organizations? | Hierarchical healthcare data, physician and organization fixed effects, clustered inference, marginal effects |
| 04 | [Longitudinal Clinical Data Analysis](04-longitudinal-clinical-data-analysis/) | How does treatment change outcomes over 12 weeks with incomplete follow-up? | Repeated-measures engineering, week-12 ANCOVA, random-intercept mixed model, MAR missingness |
| 05 | [Survival & Competing-Risk Analysis](05-survival-and-competing-risks/) | Is treatment associated with time to disease event when another event can occur first? | Kaplan–Meier, adjusted Cox regression, PH diagnostics, Fine–Gray model |
| 06 | [Causal Inference in Observational Health Data](06-causal-inference-observational-health-data/) | What is the treatment effect after addressing measured confounding? | Propensity scores, matching, stabilized IPTW, trimming, balance diagnostics, ATE and ATT |

## Portfolio strengths

- Converts research questions into documented estimands and analysis workflows.
- Performs data-quality checks and produces reviewable tables, figures, and reports.
- Uses reproducible pipelines rather than manual one-off output generation.
- Distinguishes randomized-trial, longitudinal, time-to-event, multilevel, and observational causal methods.
- Communicates assumptions and interpretation limits alongside numerical results.

## Technology

R, statistical simulation, regression modeling, mixed models, survival analysis, propensity-score methods, Git, GitHub, and browser-ready HTML reporting.

## Data and interpretation policy

All portfolio datasets are synthetic or explicitly redistributable. Results demonstrate analytical methods and are not clinical evidence. Each project documents the assumptions that limit interpretation.

## Reproducing the work

Enter a numbered project folder and follow its README. Reviewers can inspect the committed outputs without installing software; technical reviewers can rerun each pipeline from its source code.
