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

# Subset data
# Claude was used to help me with understanding what columns, that did not have
# AI in the name, could inadvertently be a response variable that would 
# then predict AISelect which would be bad for the model as there would be
# a response predicting a response. 

survey <- survey |> 
  select(-c(
    "LearnAI", "LearnAIHow", "EntSearchAdmired", "SecOpsAdmired",
    "JobEaseAI_1", "JobEaseAI_2", "JobEaseAI_3", "JobEaseAI_4", "JobEaseAI_5",
    "JobEaseAI_6", "JobEaseAI_7", "JobEaseAI_8", "JobEaseAI_9", "JobEaseAI_10",
    "JobDifficultyAI_1", "JobDifficultyAI_2", "JobDifficultyAI_3", 
    "JobDifficultyAI_4", "JobDifficultyAI_5", "JobDifficultyAI_6", 
    "JobDifficultyAI_7", "JobDifficultyAI_8", "JobDifficultyAI_9", 
    "JobDifficultyAI_10", "LanguagesUsedAI", "KnowMgmtUsedInAgenticWorkflows", 
    "EntSearchUsedInAgenticWorkflows", "SecOpsUsedInAgenticWorkflows",
    "LLMHaveWorkedWith", "LLMWantToWorkWith", "LLMUsedInAgents", "LLMAdmired",
    "BuildToolAI", "Disruption", "SOChange", "AIFreq_1", "AIFreq_2", 
    "AIFreq_3", "AIFreq_4", "AIDaily", "AISentiment", "AIComplex", "AITrust",
    "AIWorkCurrentlyUse", "AIWorkExpectMore", "AIWorkExpectLess", 
    "AIWorkDoNotPlanToUse", "AIWorkNotInWorkflow", "AIWorkNext", "AIToolCount", 
    "AIToolSwitch", "AIImpact_1", "AIImpact_2", "AIImpact_3", "AIImpact_4", 
    "AIImpact_5", "AIImpact_6", "AIImpact_7", "AISat_1", "AISat_2", "AISat_3", 
    "AISat_4", "AISat_5", "AISat_6", "AISat_7", "AIRetain",
    "AIMemHaveWorkedWith", "AIMemWantToUseNext6Months", "AIMemAdmired",
    "AIOrchHaveWorkedWith", "AIOrchWantToUseNext6Months", "AIOrchAdmired",
    "AIObsHaveWorkedWith", "AIObsWantToUseNext6Months", "AIObsAdmired",
    "AICodeAgentHaveWorkedWith", "AICodeAgentWantToUseNext6Months", 
    "AICodeAgentAdmired", "AINoCodeHaveWorkedWith", 
    "AINoCodeWantToUseNext6Months", "AINoCodeAdmired",
    "AIAutomateHaveWorkedWith", "AIAutomateWantToUseNext6Months", 
    "AIAutomateAdmired", "AIUse", "AIAvoid", "AITry", "AIAdopt", "AIToken", 
    "AICost", "AICostPrompt", "KnowledgeSourceAI", "KnowAgentDelegate", 
    "KnowAgentTrust","Answers", "CommunitySkills", "ContextWork", 
    "ContextProblems", "LanguagesAdmired", "KnowMgmtAdmired",
    "LearnCodeHow", "CommunityGap", "TechDropDown", "DevIDEHaveWorkedWith",
    "DevIDEWantToWorkWith", "DevIDEAdmired", "CodeTestHaveWorkedWith", 
    "CodeTestWantToWorkWith", "CodeTestAdmired", "Currency", "Compensation" 
  )) |> 
  drop_na("AISelect") |> 
  mutate(AISelect = ifelse(AISelect == "I don’t use AI tools", "No", "Yes"),
         AISelect = as.factor(AISelect),
         # Codex helped come up with this code for looping to remove NAs from
         # non-numeric columns and set them to "Unanswered"
         across(where(~ is.character(.x) || is.factor(.x)),~ {
             x <- as.character(.x)
             x[is.na(x) | trimws(x) == ""] <- "Unanswered"
             x
           })) 

dim(survey)

# Split Multi-Select Columns into their own respective columns to allow for
# easier modeling
# GPT-6.1-Sol was used to help with this R code on splitting multi-select
# columns. 

multi_select_cols <- c(
  "EmploymentAddl", "RoleFunctions", "PurchasePower",
  "LanguagesHaveWorkedWith", "LanguagesWantToWorkWith",
  "DatabasesHaveWorkedWith", "DatabasesWantToWorkWith", "DatabasesAdmired",
  "CloudPlatHaveWorkedWith", "CloudPlatWantToWorkWith", "CloudPlatAdmired",
  "WebFrameworkHaveWorkedWith", "WebFrameworkWantToWorkWith",
  "WebFrameworkAdmired",
  "CommPlatHaveWorkedWith", "CommPlatWantToWorkWith", "CommPlatAdmired",
  "KnowMgmtHaveWorkedWith", "KnowMgmtWantToWorkWith",
  "EntSearchHaveWorkedWith", "EntSearchWantToWorkWith",
  "SecOpsHaveWorkedWith", "SecOpsWantToWorkWith",
  "BuildTool", "AnswersTrust", "CommunityType",
  "KnowledgeQ", "TrustReason", "ContextSelect"
)

survey_clean <- survey


for (column in multi_select_cols) {
  
  # Split each person's answers at the semicolons
  answers <- strsplit(as.character(survey[[column]]), ";", fixed = TRUE)
  answers <- lapply(answers, trimws)
  
  # Find all possible answer choices
  choices <- unique(unlist(answers))
  choices <- choices[!is.na(choices) & choices != ""]
  
  for (choice in choices) {
    
    # Create a column name, such as LanguagesHaveWorkedWith_Python
    new_column <- paste(column, choice, sep = "_")
    
    # Record 1 if selected and 0 if not selected
    survey_clean[[new_column]] <- sapply(
      answers, function(x) as.integer(choice %in% x)
    )
  }
  
  # Remove the original column after splitting it
  survey_clean[[column]] <- NULL
}










