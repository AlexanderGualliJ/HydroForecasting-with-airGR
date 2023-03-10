# title: "Extract Database"
# author: "Alexander Gualli"
# date: '2023-03-07'
# description: This script extract a database of temperature and precipitation data from INAMHI SQL servers

# Install packages
# install.packages("RMySQL")

# Library
library(RMySQL)

# Define the directory
setwd("D:\\Modelo Pronostico Hidrologico\\Scripts\\Evapotranspiration")

MeteoData = read.csv("Sample2.csv",dec = ",",sep=";",header = TRUE)

# Define stations
stations = read.csv("Stations.csv",dec = ",",sep=";",header = TRUE)
p_stations = c(stations$Stations.P)
t_stations = c(stations$Stations.T)


conexion <- dbConnect(SQLite(), host="XXX.XXX.X.XX",dbname="XXXXX",user="XXXX",pass="XXXX")

conection = dbConnect(SQLite(),dbname = "data.sqlite")
dbListTables(stations)
b = dbGetQuery(stations,"SELECT *FROM estaciones")
dbDisconnect(stations)
---
  write.csv(b,"b.csv")