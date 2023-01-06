## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.height = 4,
  fig.width = 7
)

## ----pkgs, message = FALSE, warning=FALSE-------------------------------------
library(epocakir)
library(dplyr)
library(units)

## ----clinical_data------------------------------------------------------------
# Example workflow: clinical_obvs <- read.csv("cohort.csv")
glimpse(clinical_obvs)

tidy_obvs <- clinical_obvs %>%
  combine_date_time_cols() %>%
  mutate(
    Age = dob2age(`Date of Birth`),
    Height = as_metric(height = set_units(as.numeric(Height), "cm"))
  ) %>%
  binary2factor(Male, Surgery)

glimpse(tidy_obvs)

## ----aki----------------------------------------------------------------------
# Example workflow: aki_pt_data <- read.csv("aki.csv")
head(aki_pt_data)

aki_staging(aki_pt_data,
  SCr = "SCr_", bCr = "bCr_", UO = "UO_",
  dttm = "dttm_", pt_id = "pt_id_"
)

aki_pt_data %>%
  mutate(aki = aki_staging(
    SCr = SCr_, bCr = bCr_, UO = UO_,
    dttm = dttm_, pt_id = pt_id_
  )) %>%
  select(pt_id_, SCr_:dttm_, aki)

aki_pt_data %>%
  mutate(aki = aki_SCr(
    SCr = SCr_, dttm = dttm_, pt_id = pt_id_
  )) %>%
  select(pt_id_, SCr_:dttm_, aki)

## ----eGFR---------------------------------------------------------------------
# Example workflow: aki_pt_data <- read.csv("aki.csv")
head(eGFR_pt_data)

eGFR(eGFR_pt_data,
  SCr = "SCr_", SCysC = "SCysC_",
  Age = "Age_", height = "height_", BUN = "BUN_",
  male = "male_", black = "black_", pediatric = "pediatric_"
)

eGFR_pt_data %>%
  dplyr::mutate(eGFR = eGFR(
    SCr = SCr_, SCysC = SCysC_,
    Age = Age_, height = height_, BUN = BUN_,
    male = male_, black = black_, pediatric = pediatric_
  )) %>%
  select(SCr_:pediatric_, eGFR)

eGFR_pt_data %>%
  dplyr::mutate(eGFR = eGFR_adult_SCr(
    SCr = SCr_, Age = Age_, male = male_, black = black_
  )) %>%
  select(SCr_:pediatric_, eGFR)

