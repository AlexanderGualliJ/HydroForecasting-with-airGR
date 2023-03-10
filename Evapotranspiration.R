# title: "Evapotranspiration calculation"
# author: "Alexander Gualli"
# date: '2023-03-03'
# description: This script uses data from temperature to calculate Evapotranspiration

# Library
library(Evapotranspiration)

# Define the directory
setwd("D:\\Modelo Pronostico Hidrologico\\Scripts\\Evapotranspiration")

# Define the file with the temperature data
MeteoData = read.csv("Sample2.csv",dec = ",",sep=";",header = TRUE)

# Define the file with the constants data
constants = c(read.csv("Constants.csv",dec = ",",sep=";",header = TRUE))

#### if you want to modify one of the constants, modify it on the .csv file (constants.csv) ####

# Define function etp, this function calculate potential evapotranspiration 
etp <- function() {
# This section create an object whit the temperature data and a list with the constants ####
# Also review the missing data and fill fill the missing data with a monthly average ####
    data <- ReadInputs(varnames = c("Tmax","Tmin"),
                     MeteoData,
                     constants,
                     stopmissing=c(10,10,3),
                     timestep = "daily",
                     interp_missing_days = TRUE,
                     interp_missing_entries = TRUE,
                     interp_abnormal = TRUE,
                     missing_method = "DoY average",
                     abnormal_method = "DoY average")
# This section apply the McGuinness Bordne method to calculate potential evapotranspiration
  results <- ET.McGuinnessBordne(data, 
                                 constants, 
                                 ts="daily",
                                 message="yes", 
                                 AdditionalStats="yes", 
                                 save.csv="yes")
  return(results)
}

etp()


