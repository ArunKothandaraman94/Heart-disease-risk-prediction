############################################################
# HEART DISEASE RISK PREDICTION PROJECT


############################################################
# 1. SET WORKING DIRECTORY
############################################################
getwd()
setwd("D:/kaggle datasets/project 3- healthcare dataset")
list.files()


############################################################
# 2. LOAD DATASET
############################################################

heart_data = read.csv("heart_disease_uci.csv")
View(heart_data)

############################################################
# 3. CHECK DATA QUALITY
############################################################

head(heart_data)
str(heart_data)
dim(heart_data)

#missing values by column
colSums(is.na(heart_data))

#duplicate rows
sum(duplicated(heart_data))

#summary statistics
summary(heart_data)


############################################################
# 4. DATA CLEANING
############################################################

#create a copy of the original dataset
heart_clean <- heart_data

############################################################
# 4.1 REMOVE UNNECESSARY COLUMNS
############################################################

#remove patient id because it does not help predict heart disease
heart_clean$id <- NULL

# Remove ca because more than half of the values are missing
heart_clean$ca <- NULL

############################################################
# 4.2 CONVERT BLANK TEXT VALUES TO NA
############################################################

# Remove extra spaces from categorical columns
heart_clean$sex      = trimws(heart_clean$sex)
heart_clean$dataset  = trimws(heart_clean$dataset)
heart_clean$cp       = trimws(heart_clean$cp)
heart_clean$restecg  = trimws(heart_clean$restecg)
heart_clean$slope    = trimws(heart_clean$slope)
heart_clean$thal     = trimws(heart_clean$thal)

# convert blank strings to NA
heart_clean$restecg[heart_clean$restecg == ""] <- NA
heart_clean$slope[heart_clean$slope == ""] <- NA
heart_clean$thal[heart_clean$thal == ""] <- NA



############################################################
# 4.3 HANDLE NUMERIC MISSING VALUES
############################################################

heart_clean$trestbps[is.na(heart_clean$trestbps)] <-
  median(heart_clean$trestbps, na.rm = TRUE)

heart_clean$chol[is.na(heart_clean$chol)] <-
  median(heart_clean$chol, na.rm = TRUE)

heart_clean$thalch[is.na(heart_clean$thalch)] <-
  median(heart_clean$thalch, na.rm = TRUE)

heart_clean$oldpeak[is.na(heart_clean$oldpeak)] <-
  median(heart_clean$oldpeak, na.rm = TRUE)

heart_clean$fbs[is.na(heart_clean$fbs)] <- FALSE

heart_clean$exang[is.na(heart_clean$exang)] <- FALSE

# Find the most common restecg category
restecg_mode <- names(
  sort(table(heart_clean$restecg), decreasing = TRUE)
)[1]

# Replace missing restecg values with the mode
heart_clean$restecg[is.na(heart_clean$restecg)] <- restecg_mode

heart_clean$slope[is.na(heart_clean$slope)] <- "Unknown"

heart_clean$thal <- NULL
############################################################
# 4.4 FINAL DATA QUALITY CHECK
############################################################

str(heart_clean)
summary(heart_clean)
colSums(is.na(heart_clean))

# Structure of cleaned dataset
str(heart_clean)

# Summary statistics
summary(heart_clean)

# Missing values
colSums(is.na(heart_clean))

# Duplicate rows
sum(duplicated(heart_clean))

# Dimensions
dim(heart_clean)

#4.5 CREATE TARGET VARIABLE # Convert num into a binary target:
# 0 = No heart disease
# 1 to 4 = Heart disease

heart_clean$heart_disease <- ifelse(
  heart_clean$num == 0,
  "No",
  "Yes"
)

heart_clean$num <- NULL

head(heart_clean)
############################################################
# 4.6 EXPORT CLEAN DATASET
############################################################

write.csv(
  heart_clean,
  "heart_clean.csv",
  row.names = FALSE
)

############################################################
# 5.1 HEART DISEASE DISTRIBUTION
############################################################

# Count patients with and without heart disease
table(heart_clean$heart_disease)

# Percentage
round(prop.table(table(heart_clean$heart_disease)) * 100, 2)

# Bar Chart
barplot(
  table(heart_clean$heart_disease),
  main = "Heart Disease Distribution",
  xlab = "Heart Disease",
  ylab = "Number of Patients",
  col = c("lightgreen", "tomato")
)

table(heart_clean$heart_disease)

round(prop.table(table(heart_clean$heart_disease)) * 100, 2)

############################################################
# 5.2 HEART DISEASE BY GENDER
############################################################

# Frequency table
table(heart_clean$sex, heart_clean$heart_disease)

# Percentage by gender
round(prop.table(table(heart_clean$sex,
                       heart_clean$heart_disease), 1) * 100, 2)

# Stacked Bar Chart
barplot(
  table(heart_clean$sex, heart_clean$heart_disease),
  beside = FALSE,
  col = c("lightgreen", "tomato"),
  legend = TRUE,
  main = "Heart Disease by Gender",
  xlab = "Gender",
  ylab = "Number of Patients"
)

############################################################
# 5.3 AGE DISTRIBUTION
############################################################

# Summary statistics
aggregate(age ~ heart_disease,
          data = heart_clean,
          summary)

# Mean age
aggregate(age ~ heart_disease,
          data = heart_clean,
          mean)

# Boxplot
boxplot(
  age ~ heart_disease,
  data = heart_clean,
  col = c("lightgreen", "tomato"),
  main = "Age vs Heart Disease",
  xlab = "Heart Disease",
  ylab = "Age"
)


############################################################
# 5.4 CHEST PAIN TYPE
############################################################

table(heart_clean$cp,
      heart_clean$heart_disease)

round(
  prop.table(
    table(heart_clean$cp,
          heart_clean$heart_disease),
    1
  ) * 100,
  2
)

barplot(
  table(heart_clean$cp,
        heart_clean$heart_disease),
  beside = TRUE,
  col = c("lightgreen","tomato"),
  legend = TRUE,
  main = "Chest Pain Type vs Heart Disease",
  xlab = "Chest Pain Type",
  ylab = "Number of Patients"
)

############################################################
# 5.5 CHOLESTEROL VS HEART DISEASE
############################################################

aggregate(chol ~ heart_disease,
          data = heart_clean,
          summary)

aggregate(chol ~ heart_disease,
          data = heart_clean,
          mean)

boxplot(
  chol ~ heart_disease,
  data = heart_clean,
  col = c("lightgreen", "tomato"),
  main = "Cholesterol vs Heart Disease",
  xlab = "Heart Disease",
  ylab = "Cholesterol"
)

############################################################
# 5.6 RESTING BLOOD PRESSURE
############################################################

aggregate(trestbps ~ heart_disease,
          data = heart_clean,
          summary)

aggregate(trestbps ~ heart_disease,
          data = heart_clean,
          mean)

boxplot(
  trestbps ~ heart_disease,
  data = heart_clean,
  col = c("lightgreen", "tomato"),
  main = "Resting Blood Pressure vs Heart Disease",
  xlab = "Heart Disease",
  ylab = "Resting Blood Pressure"
)

############################################################
# 5.7 MAXIMUM HEART RATE
############################################################

aggregate(thalch ~ heart_disease,
          data = heart_clean,
          summary)

aggregate(thalch ~ heart_disease,
          data = heart_clean,
          mean)

boxplot(
  thalch ~ heart_disease,
  data = heart_clean,
  col = c("lightgreen", "tomato"),
  main = "Maximum Heart Rate vs Heart Disease",
  xlab = "Heart Disease",
  ylab = "Maximum Heart Rate"
)

############################################################
# 5.8 CORRELATION ANALYSIS
############################################################

# Select only numeric columns
numeric_data <- heart_clean[, sapply(heart_clean, is.numeric)]

# Correlation matrix
cor_matrix <- cor(numeric_data)

# Display correlations
round(cor_matrix, 2)


############################################################
# 6.1 CONVERT CATEGORICAL VARIABLES TO FACTORS
############################################################

heart_clean$sex <- as.factor(heart_clean$sex)
heart_clean$dataset <- as.factor(heart_clean$dataset)
heart_clean$cp <- as.factor(heart_clean$cp)
heart_clean$fbs <- as.factor(heart_clean$fbs)
heart_clean$restecg <- as.factor(heart_clean$restecg)
heart_clean$exang <- as.factor(heart_clean$exang)
heart_clean$slope <- as.factor(heart_clean$slope)
heart_clean$heart_disease <- as.factor(heart_clean$heart_disease)

str(heart_clean)

############################################################
# 6.2 TRAIN TEST SPLIT
############################################################

library(caret)

set.seed(123)

train_index <- createDataPartition(
  heart_clean$heart_disease,
  p = 0.80,
  list = FALSE
)

train_data <- heart_clean[train_index, ]
test_data  <- heart_clean[-train_index, ]

dim(train_data)
dim(test_data)

# 6.3 TRAIN LOGISTIC REGRESSION MODEL
############################################################

heart_model <- glm(
  heart_disease ~ .,
  data = train_data,
  family = binomial
)

summary(heart_model)

############################################################
# 6.4 PREDICT ON TEST DATA
############################################################

pred_prob <- predict(
  heart_model,
  newdata = test_data,
  type = "response"
)

# 6.5 CONVERT PROBABILITIES TO CLASS LABELS
############################################################

pred_class <- ifelse(
  pred_prob >= 0.5,
  "Yes",
  "No"
)

pred_class <- factor(
  pred_class,
  levels = levels(test_data$heart_disease)
)

head(pred_prob)
head(pred_class)

############################################################
# 6.6 CONFUSION MATRIX
############################################################

conf_matrix <- table(
  Actual = test_data$heart_disease,
  Predicted = pred_class
)

conf_matrix

############################################################
# 6.7 MODEL EVALUATION METRICS
############################################################

TN <- conf_matrix["No", "No"]
FP <- conf_matrix["No", "Yes"]
FN <- conf_matrix["Yes", "No"]
TP <- conf_matrix["Yes", "Yes"]

accuracy <- (TP + TN) / sum(conf_matrix)

precision <- TP / (TP + FP)

recall <- TP / (TP + FN)

specificity <- TN / (TN + FP)

f1_score <- 2 * ((precision * recall) / (precision + recall))

round(
  c(
    Accuracy = accuracy,
    Precision = precision,
    Recall = recall,
    Specificity = specificity,
    F1_Score = f1_score
  ) * 100,
  2
)

install.packages("pROC")
library(pROC)
############################################################
# 6.8 ROC CURVE & AUC
############################################################

roc_curve <- roc(
  response = test_data$heart_disease,
  predictor = pred_prob,
  levels = c("No", "Yes")
)

plot(
  roc_curve,
  main = "ROC Curve - Logistic Regression",
  col = "blue",
  lwd = 2
)

auc(roc_curve)