## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7L,
  fig.height = 5L
)

## ----message = FALSE----------------------------------------------------------
library(dplyr)
library(ggplot2)
library(knitr)
library(readr)
library(scales)

## ----include = FALSE----------------------------------------------------------
version <- read_csv(file.path("validation", "version.csv"), col_types = cols())

## ----message = FALSE----------------------------------------------------------
read_csv(file.path("validation", "convergence.csv")) |>
  mutate(convergence = label_percent()(convergence)) |>
  kable()

## -----------------------------------------------------------------------------
include_graphics(file.path("validation", "coverage.png"))

