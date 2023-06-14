# DATA LOADING
setwd("path/to/directory")
data <- read.csv("data.csv")
head(data)
attach(data)

#1 Descriptive Statistics
summary(data)
hist(wait)
hist(lastyear)
hist(dirty)
sd(dirty)
sd(lastyear)
d1 <- data.frame(good, dirty, wait, lastyear, usa)
cor(d1)

#2 Visualization of ‘wait’ and ‘usa’ , highlighting the observations where the binary outcome was positive
data$usa <- ifelse(data$usa == 0, "International", "Local")
data$good <- ifelse(data$good == 0, "Bad", "Good")


library(ggplot2)
ggplot(subset(data, good == 1), aes(x = wait, fill = usa)) +
  geom_histogram(stat = "bin", position = "identity", color = "black") +
  facet_grid(usa ~ .) +
  geom_text(aes(label = ..count..), stat = "bin", position = "stack", vjust=-0.5) +
  scale_fill_manual(values = c("blue", "red")) +
  ggtitle("Histogram of Wait Time for Positive Outcome (Good = 1) ") +
  xlab("Wait Time (hours)") +
  ylab("Number of Flights")+
  scale_fill_discrete(name = "USA", labels = c("0 = International", "1 = Local"))

hist_data <- ggplot_build(ggplot())$data[[1]]

# View the data as a table
hist_data

#3 A logistic regression model using the predictor variables dirty, wait, last year and usa.
logregmodel1 <- glm(good ~ dirty + wait + lastyear + usa, data = data, family = "binomial")
summary(logregmodel1)


# 4 Your chosen ‘best’ model if different from the one above with a brief explanation of how/why you have chosen this. 
# Include comparison of the AIC between models where appropriate.

# LINEAR REGRESSION
linmodel1 <- glm(good ~ dirty + wait + lastyear + usa, data = data, family = binomial(link = "logit"))
summary(linmodel1)$aic

linmodel2 <- glm(good ~ dirty + wait, data = data, family = binomial(link = "logit"))
summary(linmodel2)$aic


# POISSON REGRESSION
data$good <- as.numeric(data$good)
pmodel <- glm(good ~ dirty + wait + lastyear + usa, data = data, family = poisson())
summary(pmodel)$aic


# GMM
library(mclust)
gmm_model <- Mclust(data, G = 4)
summary(gmm_model)
AIC(gmm_model)


# HMM
library(depmixS4)
hmm_model <- depmix(good ~ 1, data = data, nstates = 4, type = "gaussian")
summary(hmm_model)
AIC(hmm_model)


# NORMAL GAUSSIAN
normalmodel <- glm(good ~ dirty + wait + lastyear + usa, data = data, family = gaussian())
summary(normalmodel)$aic

# NEGATIVE BINOMIAL
library(MASS)
nbmodel <- glm.nb(good ~ dirty + wait + lastyear + usa, data = data)
summary(nbmodel)

# WAIT + DIRTY BEST MODEL
logregmodel2 <- glm(good ~ wait+dirty, family = "binomial")
summary(logregmodel2)



# 5 Provide the odds ratio and 95% confidence interval for all predictor models in your chosen ‘best’ model. 
# Explain what these mean, you may want to discuss how a change in the value of the predictor variable impacts the predicted ‘risk’
coefs <- coef(logregmodel2)
se <- sqrt(diag(vcov(logregmodel2)))

# Calculate the odds ratio for each predictor variable
exp(coefs)

# Calculate the lower and upper bounds of the 95% confidence interval for each predictor variable
exp(coefs - 1.96 * se)
exp(coefs + 1.96 * se)


# 6 a classification table (confusion matrix), obtained based on classifying outcomes as “good" if the predicted risk is over 50%, and "bad" otherwise.
# Make predictions using the model
predictions <- predict(logregmodel2, newdata = data, type = "response")

# Create a binary variable based on the predictions
predictions_binary <- ifelse(predictions > 0.5, 1, 0)

# Create a confusion matrix
table(predictions_binary, data$good)

# create a pie chart of 'good'
ggplot(data, aes(x = "", y = (..count../sum(..count..)), fill = factor(good))) +
  geom_bar(width = 1, stat = "count", color = "black", alpha = 0.5) +
  ggtitle("Percentage of outcomes being 'good'") +
  xlab("") +
  ylab("") +
  scale_fill_manual(values = c("red", "green"), name = "Good") +
  guides(fill = guide_legend(title = "Outcome")) +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste0(scales::percent(..count../sum(..count..)))), stat = "count", position = position_stack(vjust = 0.5),size=4)

# create a histogram of 'dirty'
library(ggplot2)

mean_dirty <- mean(data$dirty)
sd_dirty <- sd(data$dirty)

ggplot(data, aes(x = dirty)) +
  geom_histogram(fill = "brown", alpha = 0.5, color = "black") +
  geom_errorbar(aes(x = mean_dirty, ymax = mean_dirty + sd_dirty, ymin = mean_dirty - sd_dirty), width = 0.5) +
  ggtitle("Histogram showcasing the distribution of 'dirty'") +
  xlab("Dirty (Number of Places)") +
  ylab("Frequency")

 
# create a box plot of 'wait'
median <- median(data$wait)
q1 <- quantile(data$wait, 0.25)
q3 <- quantile(data$wait, 0.75)

# create a box plot of 'wait' and add median and quartiles labels
ggplot(data, aes(x = "", y = wait)) +
  geom_boxplot() +
  geom_text(x = 1.1, y = median, label = paste0("Median: ", round(median, 2)), color = "red", position = "stack", vjust=-0.5) +
  geom_text(x = 1.1, y = q1, label = paste0("Q1: ", round(q1, 2)), color = "black", position = "identity", vjust=-0.5) +
  geom_text(x = 1.1, y = q3, label = paste0("Q3: ", round(q3, 2)), color = "black",  position = "identity", vjust=-0.5) +
  ggtitle("Boxplot of 'wait' with Median and Quartiles") +
  xlab("") +
  ylab("Wait (hours)")

# Bimodal Distribution of 'wait'
library(ggplot2)
ggplot(data, aes(x = wait)) + 
  geom_histogram(aes(y = ..density..), binwidth = 0.2, fill = "brown", alpha = 0.7, color = "black") + 
  geom_density(color = "black", size = 1) +
  ggtitle("Bimodal Distribution of 'wait'") +
  xlab("Wait (hours)") +
  ylab("Density")

# create a bar chart of 'lastyear'
ggplot(data, aes(x = lastyear)) +
  geom_histogram(aes(y = ..density..), binwidth = 1, fill = "#008080", color = "black") +
  ggtitle("Histogram showing the number of flights taken in the 'lastyear'") +
  xlab("Number of flights taken in the previous 12 months") +
  ylab("Density")

# create a pie chart of 'usa'
ggplot(data, aes(x = "", y = (..count../sum(..count..)), fill = factor(usa))) +
  geom_bar(width = 1, stat = "count", alpha = 0.4, color = "black") +
  ggtitle("% of passengers flying from & within 'usa'") +
  xlab("") +
  ylab("") +
  scale_fill_manual(values = c("#F18F01", "#ADCAD6"), name = "USA") +
  guides(fill = guide_legend(title = "Type of Flight")) +
  coord_polar(theta = "y") +
  geom_text(aes(label = scales::percent(..count../sum(..count..))), stat = "count", position = position_stack(vjust = 0.5))+
  geom_text(aes(label = paste0(scales::percent(..count../sum(..count..)))), stat = "count", position = position_stack(vjust = 0.5),size=4)
