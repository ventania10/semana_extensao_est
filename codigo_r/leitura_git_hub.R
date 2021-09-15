url1<-"https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2020/UFs/AC/AC_Municipios_2020.zip"



library(dplyr)
library(ggplot2)
library(rgdal)
library(repmis)

d <- "D:/Users/Mathews/Documents/Git/semana_extensao_est/malha"
files <- list.files(d, recursive=TRUE)

zip("myarchive.zip", files=paste(d, files, sep="/"))



zip()

source_data('https://github.com/giapsunb/semana_extensao_est/blob/main/dados%20muncipio/Dados_Mun.rdata?raw=true')


shape <- readOGR(dsn = ".", layer = "SHAPEFILE")

getwd()

url2 <- 'https://github.com/giapsunb/semana_extensao_est/blob/main/malha/Malha_territorial/Malha_territorial.rar?raw=true'

download.file(url = url1, mode='wb',destfile = "acre.zip")

zipF<-file.choose()

utils::unzip('acre.zip')

unzip('Malha_territorial.zip')


PR.mu <- readOGR('malha_municipio.shp', encoding = "UTF-8")

plot(PR.mu)


states <- st_read('malha_municipio.shp')


file.remove('malha_territorial.zip')
file.remove('malha_municipio.shp')
file.remove('malha_municipio.prj')
file.remove('malha_municipio.dbf')
file.remove('malha_municipio.shx')
