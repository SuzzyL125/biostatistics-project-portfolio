# Project 03 — Provider Variation & Fixed-Effects Analysis

## Question

How much variation in early palliative-care billing among adults with cancer is associated with treating physicians and healthcare organizations after patient case-mix adjustment?

## Design

The simulation represents patients nested within physicians and organizations. Patient characteristics include age, sex, race and ethnicity, socioeconomic measures, cancer type, diagnosis year, comorbidity, and geography. Provider and organization characteristics are incorporated into the outcome-generating process.

## Methods demonstrated

- Physician and organization fixed-effects linear probability models
- Clustered standard errors
- Case-mix adjustment
- Residual-variance comparison as a descriptive variation measure
- Logistic regression and average marginal effects

## Source

`src/original_simulation.R` preserves the original simulation and modeling program. It is displayed as a standalone project because its health-services research question and multilevel structure are substantively different from the randomized CGM analysis.

The data are entirely synthetic. Estimates are methodological demonstrations and must not be interpreted as real provider performance.
