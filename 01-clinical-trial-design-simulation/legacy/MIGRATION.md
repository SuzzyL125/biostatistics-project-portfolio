# Backup migration record

Source: `clinical-trial-simulation-backup-20260813`

| Backup content | Integrated location |
|---|---|
| Original README | `ORIGINAL_README.md` |
| Four R analysis scripts | `analysis/` |
| Trial dataset | `data/trial_data.csv` |
| Primary results | `outputs/primary_analysis_results.csv` |
| HbA1c figure | `figures/hba1c_boxplot.png` |
| Fixed-effects simulation | `provider-fixed-effects/provider_fixed_effects_simulation.R` |

SHA-1 comparisons on 2026-08-13 confirmed that the migrated scripts, dataset, and fixed-effects program match the backup exactly.

Excluded: `.git/` (the portfolio owns version history), `.DS_Store` (macOS metadata), and `cmd_history.md` (an incomplete HTML/CSS fragment rather than usable analysis or command history).

The source backup remains unchanged until the GitHub copy is independently verified.
