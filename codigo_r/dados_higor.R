library(tidyverse)
library(stringr)
library(zoo)

`%notin%` <- Negate(`%in%`)

########## Leitura e Limpeza do banco ##################

dados <- read.csv2("D:/Users/Mathews/Documents/GIAPS_Jupyter/dados_novos/SISAB.csv", encoding = 'UTF-8', dec = ',', header = F)

dados$indicador_escrito <- NA
  
dados$indicador_escrito[str_detect(string = dados$V1, pattern = 'Indicador')] <- dados$V1[str_detect(string = dados$V1, pattern = 'Indicador')]

dados$V1[str_detect(string = dados$V1, pattern = 'Indicador')] %>% unique()

dados <- dados %>% filter(indicador_escrito%notin%c("Painel Indicador","Pontuação dos Indicadores de Pagamento por Desempenho"))

dados <- dados[-c(1:6),]

dados$indicador_escrito <- na.locf(dados$indicador_escrito)
###########################

dados$tempo <- NA

dados$tempo[str_detect(string = dados$V7, pattern = '%')] <- dados$V7[str_detect(string = dados$V7, pattern = '%')]

dados$tempo[-c(1:3)] <- na.locf(dados$tempo[-c(1:3)])


dados <- dados %>% filter(V2!='')

names(dados)[1:8] <- c('uf','ibge','nome_mun','numerador','denominador_informado',
                      'denominador_estimado','indicador_calculado','indicador')

dados <- dados %>% filter(uf!='Uf')

############# Criação dos fatores dos indicadores ################
unique(dados$indicador_escrito)

dados$indicador <- factor(dados$indicador_escrito, 
                              levels=unique(dados$indicador_escrito),
                              labels=c('GEPRE','GEDST','GEODO','CITO','POLI','HIPER','DIA'))


###### Criação da região de saúde ######

regiao_saude <- read.csv(file='D:/Users/Mathews/Downloads/tableExport2.csv', encoding = 'UTF-8')

names(regiao_saude)[2] <-'uf' 

names(regiao_saude)[4:6] <- c('ibge','cod_reg_saude','reg_saude')

dados$ibge <- as.integer(dados$ibge)

Dados_Mun <- left_join(dados %>% select(-c(indicador_escrito)), regiao_saude %>% select(ibge,cod_reg_saude,reg_saude))



#### Criando Demonimador Utilizado #####

Dados_Mun$denominador_utilizado <- c()

for(j in 1:nrow(Dados_Mun)){
  Dados_Mun$denominador_utilizado[j] <- max(Dados_Mun$denominador_informado[j],
                                            Dados_Mun$denominador_estimado[j])
}

Dados_Mun$indicador_calculado <- as.numeric(Dados_Mun$indicador_calculado) 

summary(Dados_Mun$indicador_calculado)

#### Colocando Indicador Calculado na Escala de 0 a 1, em porcentagem #####

Dados_Mun$indicador_calculado <- Dados_Mun$indicador_calculado/100

##### Criando ano e quadrimestre #####

Dados_Mun$ano <- str_sub(Dados_Mun$tempo,1,4)

Dados_Mun$quadrimestre <- str_sub(Dados_Mun$tempo,6,7)

Dados_Mun$tempo <- paste0(Dados_Mun$ano, Dados_Mun$quadrimestre)


##### Fazendo aquele select #####

Dados_Mun <- Dados_Mun %>% select(c('uf','ibge','nome_mun','numerador','denominador_informado',
                       'denominador_estimado','indicador_calculado','indicador',
                       'tempo','denominador_utilizado','cod_reg_saude','reg_saude',
                       'ano','quadrimestre'))



save(Dados_Mun, file='D:/Users/Mathews/Documents/Git/semana_extensao_est/dados muncipio/Dados_Mun.rdata')

write.csv(Dados_Mun, file = 'D:/Users/Mathews/Documents/Git/semana_extensao_est/dados muncipio/Dados_Mun.csv', sep=',', row.names = F)
