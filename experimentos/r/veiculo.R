library("caret")
library("e1071")
library("mice")
library("mlbench")

dados = read.csv("/Users/patrick/Studies/iaa_006_007/laboratorio-ia/data_source/Material 02 - 5 - C - Veiculos - Dados.csv")
View(dados)

### Limpando a base
dados$a <- NULL
imp <- mice(dados)
dados <- complete(imp, 1)

### Convertendo tipo para factor
str(dados)
dados$tipo <- as.factor(dados$tipo)
str(dados)

### Particionar a bases em treino (80%) e teste (20%)
set.seed(47)
indices <- createDataPartition(dados$tipo, p=0.80, list=FALSE) 
treino <- dados[indices,]
teste <- dados[-indices,]

### Treinamento do modelo com o conjunto de treino
rna <- train(tipo~., data=treino, method="nnet",trace=FALSE)
rna

### Predi??es dos valores do conjunto de teste
predicoes.rna <- predict(rna, teste)

### Matriz de confus?o
confusionMatrix(predicoes.rna, teste$tipo)

### indica o m?todo cv e numero de folders 10
ctrl <- trainControl(method = "cv", number = 10)

### executa a RNA com esse ctrl
rna <- train(tipo~., data=treino, method="nnet",trace=FALSE, trControl=ctrl)
rna
predict.rna <- predict(rna, teste) 
confusionMatrix(predict.rna, teste$tipo)


### Busca pelo melhor modelo

grid <- expand.grid(size=seq(from=1, to=45, by=10), decay=seq(from=0.1, to=0.9, by=0.3))
set.seed(47)
rna <- train(tipo~., data=treino, method="nnet", tuneGrid=grid, trControl=ctrl, maxit=2000, trace=FALSE)
rna

# Predict
predict.rna <- predict(rna, teste) 
confusionMatrix(predict.rna, teste$tipo)
