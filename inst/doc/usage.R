## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7L,
  fig.height = 5L
)

## -----------------------------------------------------------------------------
library(pmrm)
set.seed(0)
simulation <- pmrm_simulate_decline_proportional(
  patients = 500,
  visit_times = c(0, 1, 2, 3, 4),
  tau = 0.25,
  alpha = c(0, 0.7, 1, 1.4, 1.6),
  beta = c(0, 0.2, 0.35),
  gamma = c(-1, 1)
)

## -----------------------------------------------------------------------------
simulation$y[c(2L, 3L, 12L, 13L, 14L, 15L)] <- NA_real_

## -----------------------------------------------------------------------------
simulation[, c("y", "t", "patient", "visit", "arm")]

## -----------------------------------------------------------------------------
system.time(
  fit <- pmrm_model_decline_proportional(
    data = simulation,
    outcome = "y",
    time = "t",
    patient = "patient",
    visit = "visit",
    arm = "arm",
    covariates = ~ w_1 + w_2,
    visit_times = c(0, 1, 2, 3, 4)
  )
)

## -----------------------------------------------------------------------------
print(fit)

## -----------------------------------------------------------------------------
names(fit)

## -----------------------------------------------------------------------------
str(fit$estimates)

## -----------------------------------------------------------------------------
str(fit$final)

## -----------------------------------------------------------------------------
fit$optimization$convergence

## -----------------------------------------------------------------------------
str(fit$estimates)

## -----------------------------------------------------------------------------
str(fit$standard_errors)

## -----------------------------------------------------------------------------
knots <- fit$constants$spline_knots
curve(fit$spline(x), min(knots), max(knots))

## -----------------------------------------------------------------------------
initial <- fit$initial
initial$alpha <- c(0, 0.5, 1, 1.5, 2)

fit2 <- pmrm_model_decline_proportional(
  data = simulation,
  outcome = "y",
  time = "t",
  patient = "patient",
  visit = "visit",
  arm = "arm",
  covariates = ~ w_1 + w_2,
  visit_times = c(0, 1, 2, 3, 4),
  initial = initial # with hand-picked initial alpha
)

## -----------------------------------------------------------------------------
initial <- fit$final # true parameters from the last fit
initial$theta[2] <- 0 # reset a scalar parameter that may have diverged

fit3 <- pmrm_model_decline_proportional(
  data = simulation,
  outcome = "y",
  time = "t",
  patient = "patient",
  visit = "visit",
  arm = "arm",
  covariates = ~ w_1 + w_2,
  visit_times = c(0, 1, 2, 3, 4),
  initial = initial # with the modified parameter values
)

## ----eval = FALSE-------------------------------------------------------------
# library(dplyr)
# library(tmbstan)
# library(posterior)
# 
# # Fit a Bayesian version of the same model.
# # Increase the number of chains for the Rhat diagnostic to be valid.
# mcmc <- tmbstan(fit$model, chains = 1, refresh = 10)
# 
# # Extract the MCMC draws.
# draws <- as_draws_df(mcmc) |>
#   select(starts_with("alpha"), any_of(c("theta", "phi")))
# 
# # Plot pairwise correlations among MCMC draws.
# # Pairs of parameters should not be strongly correlated.
# # Tight correlations and funneling indicate problems,
# # such as non-identifiability if you have too many knots.
# pairs(draws)
# 
# # Alternatively, if you have many parameters, you can look at
# # pairwise linear correlations. However, this may miss
# # important pathologies.
# correlations <- cor(samples)[lower.tri(cor(samples))]
# hist(correlations)

## -----------------------------------------------------------------------------
pmrm_estimates(fit, parameter = "theta")

## -----------------------------------------------------------------------------
pmrm_estimates(fit, parameter = "sigma", confidence = 0.9)

## -----------------------------------------------------------------------------
summary(fit)

## -----------------------------------------------------------------------------
pmrm_marginals(fit, type = "outcome")

## -----------------------------------------------------------------------------
pmrm_marginals(fit, type = "change")

## -----------------------------------------------------------------------------
pmrm_marginals(fit, type = "effect")

## -----------------------------------------------------------------------------
predict(fit, data = head(simulation, 5))

## -----------------------------------------------------------------------------
plot(
  fit,
  show_predictions = TRUE # Defaults to FALSE because predictions take extra time.
)

## -----------------------------------------------------------------------------
plot(
  fit,
  confidence = 0.9,
  show_data = FALSE,
  show_predictions = TRUE, # Defaults to FALSE because predictions take extra time.
  facet = FALSE,
  alpha = 0.5
)

