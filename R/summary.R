#' @title Summarize a PMRM.
#' @export
#' @family model comparison
#' @description Summarize a progression model for repeated measures (PMRM).
#' @return A `tibble` with one row and columns with the following columns:
#'
#'   * `model`: `"decline"` or `"slowing"`.
#'   * `parameterization`: `"proportional"` or `"nonproportional"`.
#'   * `n_observations`: number of non-missing observations in the data.
#'   * `n_parameters`: number of true model parameters.
#'   * `log_likelihood`: maximized log likelihood of the model fit.
#'   * `deviance`: deviance of the fitted model, defined here as
#'     `-2 * log_likelihood`.
#'   * `aic`: Akaike information criterion.
#'   * `bic`: Bayesian information criterion.
#'
#'   This format is designed for easy comparison of multiple fitted models.
#' @param object A fitted model object of class `"pmrm_fit"`.
#' @param ... Not used.
#' @examples
#'   set.seed(0L)
#'   simulation <- pmrm_simulate_decline_proportional(
#'     visit_times = seq_len(5L) - 1,
#'     gamma = c(1, 2)
#'   )
#'   fit <- pmrm_model_decline_proportional(
#'     data = simulation,
#'     outcome = "y",
#'     time = "t",
#'     patient = "patient",
#'     visit = "visit",
#'     arm = "arm",
#'     covariates = ~ w_1 + w_2
#'   )
#'   summary(fit)
summary.pmrm_fit <- function(object, ...) {
  glance(x = object, ...)
}
