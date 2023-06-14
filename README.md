# Statistical Modelling: SFO Passenger Survey Analysis

This GitHub repository contains the code and resources for analyzing a passenger survey dataset from San Francisco airport (SFO) in the R programming language. The dataset is adapted from a 2012 survey and includes variables such as "good" (the outcome variable indicating passenger approval of the airport), "dirty" (count of locations perceived as dirty), "wait" (hours spent at the airport), "lastyear" (number of times flown from SFO in the previous 12 months), and "usa" (binary variable indicating domestic or international destination).

## Project Overview
The client, SFO, requested an investigation of the dataset and a concise summary report outlining the findings and proposing a predictive model for future use. The report, provided as a PDF file, encompasses a descriptive analysis of the variables, visualization of "wait" and "usa" with respect to the positive binary outcome, and a logistic regression model using the predictor variables "dirty," "wait," "lastyear," and "usa."

## Descriptive Statistics
For each variable in the dataset, appropriate descriptive statistics were computed and interpreted within context. The summary report includes measures such as mean, standard deviation, median, quartiles, and percentages to provide a comprehensive understanding of the data.

## Visualization
A visualization was created to highlight the relationship between "wait" and "usa" variables, focusing on observations where the binary outcome was positive ("good"). The visual representation allows for interpretation and understanding of the observed patterns and trends.

## Logistic Regression Model
A logistic regression model was developed using the predictor variables "dirty," "wait," "lastyear," and "usa." This model was chosen as the best fit for the dataset based on comparison with other models, including linear regression, Poisson regression, GMM, HMM, normal Gaussian, and negative binomial. The selection process considered factors such as model performance and AIC values, ultimately identifying logistic regression as the most suitable model for this analysis.

## Odds Ratio and Confidence Intervals
The "best" model, which is the logistic regression model, provides odds ratios and their corresponding 95% confidence intervals for all predictor variables. The report explains the interpretation of these values and discusses how changes in predictor variable values impact the predicted "risk" (in this case, the likelihood of a positive outcome).

## Classification Table
A classification table, also known as a confusion matrix, was generated based on classifying outcomes as "good" if the predicted risk exceeds 50%, and "bad" otherwise. This table helps evaluate the performance of the logistic regression model and provides insights into the accuracy of predictions.

## Contents
This repository includes the following resources:

data.csv: The dataset file containing the SFO passenger survey data.

analysis.R: The R script containing the code for data analysis, including descriptive statistics, visualization, and logistic regression modeling.

SFO_Survey_Report.pdf: A PDF report summarizing the findings of the analysis, including descriptive statistics, visualizations, logistic regression model details, odds ratios, and the classification table.
