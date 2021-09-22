#url1<-"https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2020/UFs/AC/AC_Municipios_2020.zip"



library(dplyr)
library(ggplot2)
library(rgdal)
library(repmis)

d <- "D:/Users/Mathews/Documents/Git/semana_extensao_est/malha"
files <- list.files(d, recursive=TRUE)

zip("myarchive.zip", files=paste(d, files, sep="/"))



source_data('https://github.com/giapsunb/semana_extensao_est/blob/main/dados%20muncipio/Dados_Mun.rdata?raw=true')


shape <- readOGR(dsn = ".", layer = "SHAPEFILE")

getwd()

url2 <- 'https://github.com/giapsunb/semana_extensao_est/blob/main/malha/Malha_territorial/Malha_territorial.zip?raw=true'

download.file(url = url2, mode='wb',destfile = "malha.zip")

#zipF<-file.choose()

unzip('malha.zip')

library(sf)
states <- st_read('malha_municipio.shp')


file.remove('malha.zip')
file.remove('malha_municipio.shp')
file.remove('malha_municipio.prj')
file.remove('malha_municipio.dbf')
file.remove('malha_municipio.shx')
