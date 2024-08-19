library(rpart)
data=kyphosis
data$Kyphosis=NULL
km=kmeans(data,3)
km
table(kyphosis$Kyphosis,km$cluster)
plot(kyphosis[c("Age" , "Number")],col=km$cluster)
points(km$centers[ , c("Age", "Number")], col=1:3, pch=8, cex=2)
library(fpc)
pr=pamk(data)
pr$nc
layout(matrix(c(1,2),1,2))
plot(pr$pamobject)
layout(matrix(1))
library(cluster)
pam.result=pam(data,3)
table(pam.result$clustering,kyphosis$Kyphosis)
idx=sample(1:dim(data)[1],40)
kyphosissample=data[idx,]
kyphosissample$Kyphosis=NULL
hc=hclust(dist(kyphosissample),method='ave')
plot(hc,hang=-1,labels=data$Kyphosis[idx])
rect.hclust(hc,k=3)
groups=cutree(hc,k=3)
#####
library(fpc)
kyphosis= kyphosis[-5]
v=dbscan(data,eps=0.42,MinPts=5)
data=kyphosis
data$Kyphosis=NULL
table(v$cluster,kyphosis$Kyphosis)
plotcluster(data, v$cluster)
#plot(v,data)در صورتي اين نمودار اجرا ميشودکه متغيرهاي معرفي شده کمي باشند 

set.seed(435)
idx= sample(1:nrow(kyphosis), 5)
nd= kyphosis[idx, -5]
nd= nd+ matrix(runif(10*4, min=0, max=0.2), nrow=10, ncol=4)
mypred= predict(v,data)
plot(data[c(1,2)],col=1+v$cluster)
points(nd[c(1,2)], pch="*" , col=1+mypred, cex=3)
table(mypred,kyphosis$Kyphosis)
######
set.seed(1234)
var= sample(2, nrow(kyphosis), replace=TRUE, prob=c(0.7, 0.3))
trd= kyphosis[var==1, ]
tsd= kyphosis[var==2, ]
library(party)
frm1= Kyphosis ~ Age + Number + Start
kyphosisct=ctree(frm1,data=trd)
table(predict(kyphosisct), trd$Kyphosis)
print(kyphosisct)
plot(kyphosisct, type="simple")
tsp= predict(kyphosisct, newdata=tsd)
table(tsp,tsd$Kyphosis)

#############
data=kyphosis
var=sample(2,nrow(data),replace=T,prob=c(0.7,0.3))
trd=kyphosis[var==1,]
tsd=kyphosis[var==2,]
library(randomForest)
x=randomForest(Kyphosis~.,data=trd,ntree=100,proximity=TRUE)
table(predict(x),trd$Kyphosis)
print(x)
attributes(x)
plot(x)
##########رگرسيون
data=kyphosis
Age=data[,2]
Number=data[,3]
Start=data[,4]
model1=lm(Age~Number+ Start)
summary(model1)
library(fmsb)
VIF(model1)
cor(cbind(Kyphosis, Age, Number, Start))
par(mfrow=c(1,1))
library(MASS)
boxcox(model1)
par(mfrow=c(2,2))
plot(model1)
anova(model1)
residual1=resid(model1)
par(mfrow=c(1,3))
hist(residual1)
boxplot(residual1)
qqnorm(residual1)
qqline(residual1,lwd=2,col="red")
shapiro.test(residual1)
