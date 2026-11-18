# main.R
# STAT 172 Final Project
# 2026 Stack Overflow Developer Survey on AI Usage
# Copyright (c) 2026 Louie Bloomberg
# SPDX-License-Identifier: GPL-3.0-only

rm(list = ls())

# Load Packages
library(tidyverse)
library(rpart)
library(rpart.plot)
library(pROC)
library(randomForest)
library(tidymodels)

# Load Data
survey <- read.csv("data/survey_results_public.csv", 
                 stringsAsFactors = TRUE)

# Source rhe dataprep file
source("dataprep.R", local = TRUE)











