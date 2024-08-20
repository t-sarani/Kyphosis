# Kyphosis Disease Data Mining Project

## Project Overview

This project aims to analyze the data pertaining to the disease kyphosis through various clustering and modeling techniques to identify patterns and relationships within the data, enabling accurate predictions.

**فارسی**: 
این پروژه هدفش بررسی و تحلیل داده‌های مربوط به بیماری کیفوزیس از طریق استفاده از روش‌های مختلف خوشه‌بندی و مدلسازی است تا الگوها و روابط موجود در داده‌ها شناسایی شده و پیش‌بینی‌های دقیقی انجام شود.

---

## Contents

- [Introduction](#introduction)
- [Data Description](#data-description)
- [Methodology](#methodology)
- [Random Forest Model](#random-forest-model)
- [Results](#results)
- [References](#references)
  
## Introduction

Kyphosis (hunchback) is a spinal deformity characterized by an excessive curvature of the upper spine. This project employs data mining techniques to assess and classify kyphosis patients, providing insights into its factors and potential predictions regarding health outcomes.

**فارسی**: 
کیفوزیس (قوز) نوعی نقص در ستون فقرات است که با انحنای بیش از حد قسمت بالایی ستون فقرات مشخص می‌شود. این پروژه از تکنیک‌های داده‌کاوی برای ارزیابی و طبقه‌بندی بیماران کیفوزیس استفاده می‌کند و به درک عوامل و پیش‌بینی‌های بالقوه در مورد نتایج سلامتی کمک می‌کند.

## Data Description

The dataset used in this project is the `kyphosis` dataset from the R `MASS` package. It contains information on patients' age, number of affected vertebrae, starting vertebra, and whether or not they present with kyphosis.

### Variables
- **Kyphosis**: A factor indicating the presence or absence of kyphosis
- **Age**: Age of the patient
- **Number**: Number of affected vertebrae
- **Start**: The starting vertebra

## Methodology

This project employs several techniques such as:

1. **K-means Clustering**: To partition data into distinct clusters.
2. **PAM Clustering**: For partitioning around medoids.
3. **Hierarchical Clustering**: To create a dendrogram.
4. **DBSCAN**: Density-based clustering to handle noise.
5. **Decision Trees**: For classification based on age, number, and start.
6. **Random Forest**: To build a robust predictive model.
7. **Regression Analysis**: For understanding relationships between variables.

## Random Forest Model

Random forest is used as a key modeling technique due to its high accuracy and ability to handle complex relationships in the data. Here is the relevant code section:

```r
library(randomForest)

# Data preparation
set.seed(5678)
var <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
trd <- data[var == 1, ] # Training data
tsd <- data[var == 2, ] # Test data

# Random Forest Model
x <- randomForest(Kyphosis ~ ., data = trd, ntree = 100, proximity = TRUE)
print(table(predict(x), trd$Kyphosis)) # Confusion Matrix
plot(x) # Visualize Random Forest

Random Forest Plot

![Random Forest](imagerandom_forest_plot.png)


Results

The clustering and modeling results provide significant insights into the factors that influence kyphosis. The random forest model achieved an overall accuracy rate of 81.67% in predicting the presence of kyphosis.


References

Breiman, L. (2001). Random Forests. Machine Learning, 45(1), 5-32.
R Core Team. (2021). R: A language and environment for statistical computing. R Foundation for Statistical Computing.
MASS package documentation for the 
kyphosis
 dataset.
Clustering Methods in R: Practical Guidelines.