############################################################
# Simulate Dr. Hu-style provider / organization FE analysis
# Outcome: early palliative care billing within 3 months
############################################################

install.packages(c("fixest", "marginaleffects", "broom"))

library(dplyr)
library(fixest)
library(marginaleffects)
library(broom)

set.seed(2026)

############################################################
# 1. Simulate organization and physician structure
############################################################

n_org <- 120
n_phys <- 900
n_patients <- 20000

org_df <- data.frame(
  org_id = 1:n_org,
  org_size = sample(c("1-5", "6-50", "51+"), n_org, replace = TRUE,
                    prob = c(0.25, 0.45, 0.30)),
  hpm_specialist = rbinom(n_org, 1, 0.35),
  org_random_effect = rnorm(n_org, mean = 0, sd = 0.45)
)

phys_df <- data.frame(
  physician_id = 1:n_phys,
  org_id = sample(1:n_org, n_phys, replace = TRUE),
  phys_age_group = sample(c("<=40", "41-50", "51+"), n_phys, replace = TRUE,
                          prob = c(0.25, 0.40, 0.35)),
  phys_sex = sample(c("Female", "Male"), n_phys, replace = TRUE),
  integrated_status = rbinom(n_phys, 1, 0.45),
  past_year_pc_referral = rbinom(n_phys, 1, 0.30),
  physician_random_effect = rnorm(n_phys, mean = 0, sd = 0.75)
) %>%
  left_join(org_df, by = "org_id")

############################################################
# 2. Simulate patient-level data
############################################################

patient_df <- data.frame(
  patient_id = 1:n_patients,
  physician_id = sample(1:n_phys, n_patients, replace = TRUE),
  age = round(runif(n_patients, 66, 90), 1),
  sex = sample(c("Female", "Male"), n_patients, replace = TRUE),
  race_ethnicity = sample(
    c("NH White", "NH Black", "Hispanic", "Asian/PI", "Other"),
    n_patients, replace = TRUE,
    prob = c(0.65, 0.15, 0.10, 0.07, 0.03)
  ),
  married = rbinom(n_patients, 1, 0.55),
  yost_quintile = sample(1:5, n_patients, replace = TRUE),
  dual_medicaid = rbinom(n_patients, 1, 0.18),
  cancer_type = sample(
    c("Breast", "Colorectal", "NSCLC", "SCLC", "Pancreatic", "Prostate"),
    n_patients, replace = TRUE,
    prob = c(0.12, 0.18, 0.30, 0.10, 0.15, 0.15)
  ),
  diagnosis_year = sample(2010:2019, n_patients, replace = TRUE),
  nci_comorbidity = rpois(n_patients, lambda = 1.2),
  metropolitan = rbinom(n_patients, 1, 0.82)
) %>%
  left_join(phys_df, by = "physician_id")

############################################################
# 3. Simulate early PC billing outcome
############################################################

linear_predictor <- with(patient_df,
                         -2.7 +
                           0.02 * (age - 75) +
                           0.20 * dual_medicaid +
                           0.10 * (married == 0) +
                           0.25 * (cancer_type == "Pancreatic") +
                           0.30 * (cancer_type == "SCLC") +
                           0.20 * (cancer_type == "NSCLC") +
                           0.08 * nci_comorbidity +
                           0.25 * hpm_specialist +
                           0.20 * integrated_status +
                           0.55 * past_year_pc_referral +
                           org_random_effect +
                           physician_random_effect
)

prob_early_pc <- plogis(linear_predictor)

patient_df$early_pc_billing <- rbinom(n_patients, 1, prob_early_pc)

mean(patient_df$early_pc_billing)

############################################################
# Physician FE LPM
############################################################

lpm_phys_fe <- feols(
  early_pc_billing ~
    age + sex + race_ethnicity + married + factor(yost_quintile) +
    dual_medicaid + cancer_type + factor(diagnosis_year) +
    nci_comorbidity + metropolitan |
    physician_id,
  cluster = ~ physician_id,
  data = patient_df
)

summary(lpm_phys_fe)

############################################################
# Organization FE LPM
############################################################

lpm_org_fe <- feols(
  early_pc_billing ~
    age + sex + race_ethnicity + married + factor(yost_quintile) +
    dual_medicaid + cancer_type + factor(diagnosis_year) +
    nci_comorbidity + metropolitan |
    org_id,
  cluster = ~ org_id,
  data = patient_df
)

summary(lpm_org_fe)

############################################################
# ICC-like variance share from FE models
############################################################

base_lpm <- feols(
  early_pc_billing ~
    age + sex + race_ethnicity + married + factor(yost_quintile) +
    dual_medicaid + cancer_type + factor(diagnosis_year) +
    nci_comorbidity + metropolitan,
  data = patient_df
)

resid_base <- resid(base_lpm)
resid_phys_fe <- resid(lpm_phys_fe)
resid_org_fe <- resid(lpm_org_fe)

var_base <- var(resid_base)
var_phys_fe <- var(resid_phys_fe)
var_org_fe <- var(resid_org_fe)

icc_physician <- (var_base - var_phys_fe) / var_base
icc_organization <- (var_base - var_org_fe) / var_base

icc_physician
icc_organization

############################################################
# Logistic regression with marginal effects
############################################################

logit_model <- glm(
  early_pc_billing ~
    age + sex + race_ethnicity + married + factor(yost_quintile) +
    dual_medicaid + cancer_type + factor(diagnosis_year) +
    nci_comorbidity + metropolitan +
    phys_age_group + phys_sex + integrated_status +
    past_year_pc_referral + org_size + hpm_specialist,
  family = binomial(link = "logit"),
  data = patient_df
)

summary(logit_model)

avg_slopes(logit_model)