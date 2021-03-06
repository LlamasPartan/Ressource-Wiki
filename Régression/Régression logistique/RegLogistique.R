##Librairies g�n�rales
library(tidyr)

##Librairies r�gression logistique binomiale et multinomiale
library(glmnet)
library(MLmetrics)

##Librairies r�gression logistique ordinale
library(MASS)


##La fonction logistique

###Importation des donn�es

data = read.csv('audit_risk.csv', sep = ',')
data <- drop_na(data)#Suppression des valeurs manquantes
data <- data[, -c(2)]#Suppression de variable contenant des valeurs qualitatives

###D�coupe du dataset

set.seed(0)#D�finition de la r�p�tabilit� de l'al�atoire
dt = sort(sample(nrow(data), nrow(data)*.8))#D�finition de la quantit� de donn�es � r�partir
data_train <- data[dt,]#Donn�es d'entrainement
data_test <- data[-dt,]#Donn�es de test

X_train <- data_train[, -c(26)]#Variables explicatives entrainement
y_train <- data_train$Risk#Variable cible entrainement
X_test <- data_test[, -c(26)]#Variables explicatives test
y_test <- data_test$Risk#Variable cible test

####Mod�le de pr�diction : r�gression logistique

model <- glm(Risk~., family = 'binomial', data = data_train)#Entrainement de l'estimateur, en pr�cisant
#family = binomial pour la r�gression logistique binaire
y_prob <- predict(model, newdata = X_test, type = 'response')#Calcul des probabilit�s d'appartenance � la classe positive, sur les donn�es de test
y_pred <- ifelse(y_prob > 0.5, 1, 0)#Pr�diction sur les donn�es X de test

##Evaluation de mod�le
LogLoss(y_pred, y_test)#Perte logistique
table(y_test, y_pred)#Construction de la matrice de confusion

####R�gularisation

X_train <- as.matrix(X_train)
X_test <- as.matrix(X_test)

model <- glmnet(X_train, y_train, family = 'binomial', alpha = 0, lambda = 0.05)#Entrainement du classificateur avec 
#une r�gularisation L2 avec alpha = 0, un coefficient de r�gularisation lambda et family qui d�finit la r�gression logistique
y_prob <- predict(model, newx = X_test, type = 'response')#Pr�diction des probabilit�s sur les donn�es de test
y_pred <- ifelse(y_prob > 0.5, 1,0)#Pr�diction de l'�tat de la fraude


##Evaluation de mod�le
LogLoss(y_pred, y_test)#Perte logistique
table(y_test, y_pred)#Construction de la matrice de confusion

####Mod�le de pr�diction : r�gression softmax

##Importation des donn�es

data = read.csv('wine_data.csv', sep = ',')

##D�coupe du dataset

set.seed(0)
dt = sort(sample(nrow(data), nrow(data)*.8))
data_train<-data[dt,]
data_test<-data[-dt,]

X_train <- data_train[, -c(1)]
y_train <- data_train$Wine
X_test <- data_test[, -c(1)]
y_test <- data_test$Wine


##Mod�le de pr�diction

X_train <- as.matrix(X_train)
X_test <- as.matrix(X_test)

model <- glmnet(X_train, y_train, family = 'multinomial', type.logistic = "Newton" ,alpha = 0, lambda = 0.6000000000000001)
y_pred <- predict(model, newx = X_test, type = 'class')#Pr�diction des classes 
y_prob <- predict(model, newx = X_test, type = 'response')#Pr�diction des probabilit�s d'appartenance

##Evaluation mod�le

table(y_pred, y_test)#Matrice de confusion
y_pred <- as.numeric(y_pred)
LogLoss(y_pred,y_test)#Perte logistique


####Mod�le de pr�diction : regression logistique ordinale

model <- polr(as.factor(Wine)~ Alcohol + Malic.acid + Ash + Acl + Mg, data = data_test, method = 'logistic')#Entrainement du mod�le
y_pred <- predict(model, X_test)#Pr�diction sur les donn�es X
y_prob <- predict(model, X_test, type='p')#Pr�diction des probabilit�s d'appartenance
table(y_test,y_pred)#Matrice de confusion

##Evaluation mod�le

table(y_pred, y_test)#Matrice de confusion
y_pred <- as.numeric(y_pred)
LogLoss(y_pred,y_test)#Perte logistique