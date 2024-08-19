
# بارگذاری کتابخانههای مورد نیاز
library(rpart)
library(fpc)
library(cluster)
library(randomForest)
library(fmsb)
library(MASS)

# بارگذاری دادهها
data(kyphosis)

# *پیشپردازش دادهها*
data <- kyphosis
data$Kyphosis <- NULL  # حذف ستون Kyphosis برای خوشهبندی

# بررسی نرمال بودن دادهها
shapiro.test(data$Age)
shapiro.test(data$Number)
shapiro.test(data$Start)

# نرمالسازی دادهها با استفاده از تبدیل log
data$Age <- log(data$Age + 1)  # اضافه کردن 1 برای جلوگیری از log(0)
data$Number <- log(data$Number + 1)
data$Start <- log(data$Start + 1)

# *خوشهبندی K-means*
set.seed(123)  # برای بازتولید پذیری
km <- kmeans(data, 3)  # خوشهبندی به 3 خوشه
print(km)

# جدول مقایسه خوشهها با Kyphosis
if ("Kyphosis" %in% colnames(kyphosis)) {
table(kyphosis$Kyphosis, km$cluster)
} else {
warning("Column 'Kyphosis' not found in dataset.")
}

# نمایش نتایج خوشهبندی
plot(kyphosis[c("Age", "Number")], col = km$cluster, main = "K-means Clustering")
points(km$centers[, c("Age", "Number")], col = 1:3, pch = 8, cex = 2)

# *خوشهبندی PAM*
pr <- pamk(data)
print(pr$nc)  # تعداد خوشهها

# نمایش نمودار PAM
layout(matrix(c(1, 2), 1, 2))
plot(pr$pamobject)
layout(matrix(1))

# خوشهبندی با PAM
pam.result <- pam(data, 3)
if ("Kyphosis" %in% colnames(kyphosis)) {
table(pam.result$clustering, kyphosis$Kyphosis)
} else {
warning("Column 'Kyphosis' not found in dataset.")
}

# *خوشهبندی Hierarchical*
idx <- sample(1:dim(data)[1], 40)  # انتخاب تصادفی 40 نمونه
kyphosissample <- data[idx,]
kyphosissample$Kyphosis <- NULL
hc <- hclust(dist(kyphosissample), method = 'ave')
plot(hc, hang = -1, labels = kyphosis$Kyphosis[idx])  # نمایش درخت خوشهبندی
rect.hclust(hc, k = 3)  # مشخص کردن 3 خوشه
groups <- cutree(hc, k = 3)  # برش خوشهها

# *خوشهبندی DBSCAN*
# Ensure all columns are numeric
data <- data.frame(lapply(data, as.numeric))

# DBSCAN clustering
v <- dbscan(data, eps = 0.42, MinPts = 5)

# Check if 'Kyphosis' column exists in the original dataset
if ("Kyphosis" %in% colnames(kyphosis)) {
print(table(v$cluster, kyphosis$Kyphosis))
} else {
warning("Column 'Kyphosis' not found in dataset.")
}

# Display DBSCAN results
plotcluster(data, v$cluster)

# *پیشبینی با دادههای جدید*
set.seed(435)
idx <- sample(1:nrow(kyphosis), 5)  # انتخاب 5 نمونه تصادفی
nd <- kyphosis[idx, -5]  # حذف ستون Kyphosis
nd <- nd + matrix(runif(10 * 4, min = 0, max = 0.2), nrow = 10, ncol = 4)
mypred <- predict(v, data)

# نمایش نتایج پیشبینی
plot(data[c(1, 2)], col = 1 + v$cluster, main = "DBSCAN Clustering with Predictions")
points(nd[c(1, 2)], pch = "*", col = 1 + mypred, cex = 3)
if ("Kyphosis" %in% colnames(kyphosis)) {
table(mypred, kyphosis$Kyphosis)
} else {
warning("Column 'Kyphosis' not found in dataset.")
}

# *مدلسازی با درخت تصمیمی*
set.seed(1234)
var <- sample(2, nrow(kyphosis), replace = TRUE, prob = c(0.7, 0.3))
trd <- kyphosis[var == 1, ]  # دادههای آموزشی
tsd <- kyphosis[var == 2, ]  # دادههای تست

frm1 <- Kyphosis ~ Age + Number + Start
kyphosisct <- ctree(frm1, data = trd)
print(table(predict(kyphosisct), trd$Kyphosis))  # جدول مقایسه

# نمایش درخت تصمیم
print(kyphosisct)
plot(kyphosisct, type = "simple")

# پیشبینی با مدل درخت تصمیم
tsp <- predict(kyphosisct, newdata = tsd)
if ("Kyphosis" %in% colnames(tsd)) {
table(tsp, tsd$Kyphosis)
} else {
warning("Column 'Kyphosis' not found in test dataset.")
}

########
# Data preparation
data <- kyphosis
data$Kyphosis <- as.factor(data$Kyphosis)  # Ensure Kyphosis is a factor for classification

# *مدلسازی جنگل تصادفی*
set.seed(5678)
var <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
trd <- data[var == 1, ]  # دادههای آموزشی
tsd <- data[var == 2, ]  # دادههای تست

x <- randomForest(Kyphosis ~ ., data = trd, ntree = 100, proximity = TRUE)
print(table(predict(x), trd$Kyphosis))  # جدول مقایسه
print(x)  # نمایش مدل جنگل تصادفی
print(attributes(x))  # نمایش ویژگیهای مدل
plot(x)  # نمایش گرافیک جنگل تصادفی

# *مدلسازی رگرسیونی*
data <- kyphosis
Age <- data[, 2]
Number <- data[, 3]
Start <- data[, 4]

model1 <- lm(Age ~ Number + Start)
summary(model1)  # نمایش خلاصه مدل رگرسیونی

# بررسی VIF
library(fmsb)
VIF(model1)

# محاسبه همبستگی
# Calculate correlation
cor_matrix <- cor(cbind(data$Kyphosis, Age, Number, Start))
print(cor_matrix)

# نمودارهای باقیمانده
par(mfrow = c(2, 2))
boxcox(model1)
par(mfrow = c(2, 2))
plot(model1)
anova(model1) 

# تجزیه و تحلیل باقیماندهها
residual1 <- resid(model1)
par(mfrow = c(1, 3))
hist(residual1, main = "Histogram of Residuals", xlab = "Residuals", col = "lightblue")
boxplot(residual1, main = "Boxplot of Residuals")
qqnorm(residual1)
qqline(residual1, lwd = 2, col = "red")
shapiro.test(residual1)  # آزمون شاپیرو-ویلک برای نرمال بودن باقیماندهها
