###Librairies

library(rsvd)
library(factoMineR)
library(explor)
library(psych)
library(imager)

###Imporation des donn�es

data <- read.csv('audit_risk.csv', sep=',')
data <- drop_na(data)#Suppression des valeurs manquantes
data <- data[, -c(2)]#Suppression de variable contenant des valeurs qualitatives

###D�coupe des donn�es

X <- subset(data, select = -c(Risk))
X <- as.matrix(X)
y <- data$Risk

###Standardisation des donn�es

X_Centered <- scale(X, center = T)#Centrage des donn�es
X_Centered <- as.data.frame(X_Centered)#Consversion de la matrice en dataframe
X_Centered <- subset(X_Centered, select = -c(24))#Suppression de la colonne de valeurs manquantes g�n�r�es

###Recherche des composantes principales

SVDecomp <- svd(X_Centered)#D�composition en valeurs singuli�res
c1 <- t(SVDecomp$v[,0])#Premi�re composante principale
c2 <- t(SVDecomp$v[,1])#Deuxi�me composante principale

###Projection dimensionnelle

X_d <- t(SVDecomp$v[1:9,])#On r�cup�re les d = 9 premi�res composantes principales
X_Centered <- as.matrix(X_Centered)#Conversion en matrice
X_proj <- X_Centered %*% X_d#Projection des donn�es d'entrainement sur l'espace � d dimension

###Construction du mod�le de r�duction

model <- PCA(data, ncp = 25, scale = TRUE)#Cr�ation du mod�le avec centrage des donn�es et d�finition du nombre de composantes � prendre en compte

barplot(model$eig[,3])#Variance expliqu�e en fonction du nombre de variables

#Vous pouvez aussi utiliser la commande suivante, offrant plus de possibilit�s d'observations.

explor(model)#Ouverture d'une fen�tre permettant de visualiser les variables importantes


####Traitement d'images

###D�compression des donn�es

X_decompressed <- X_proj %*% t(X_d)#Produit matriciel d'inversion de la m�thode ACP

###Importation de l'image

img <- load.image("raton_laveur.png")
plot(img)

###D�termination du nombre de composantes

model <- PCA(img, ncp = 768, scale = T)#Cr�ation du mod�le avec centrage des donn�es
barplot(model$eig[,3]>=95)#Variance expliqu�e en fonction du nombre de variables

model <- PCA(img, ncp = 150, scale = T)#Cr�ation du mod�le avec centrage des donn�es

###Affichage graphique

decomposition_svd <- svd(img)#D�composition en valeur singuli�re
composantes_pr <- 150#D�finition du nombre de composantes principales � conserver
img.svd <- decomposition_svd$u[,1:composantes_pr] %*% diag(decomposition_svd$d[1:composantes_pr]) %*% t(decomposition_svd$v[,1:composantes_pr])#Produit matricielle

####Crit�re de Kaiser

summary(model, ncp = 25)#Affichage des valeurs propres des variables du dataset

##Autre m�thode 

cormat <- cor(data)
cormat <- cormat[, -c(24)]#Suppression de variable contenant des valeurs qualitatives
scree(cormat)