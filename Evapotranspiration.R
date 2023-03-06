# title: "Evapotranspiration calculation"
# author: "Alexander Gualli"
# date: '2023-03-03'
# desciption: This script uses data from precipitation and temperature to calculate Evapotranspiration

# Library
library(Evapotranspiration)

# Directorio
setwd("D:\\Modelo Pronostico Hidrologico\\Scripts\\Evapotranspiration")

# ReadInputs climate data
a = read.csv("Sample.csv",dec = ",",sep=";",header = TRUE)
data("processeddata")
data("defaultconstants")

# Call mcguinnessbordne under the generic function ET
mcguinessbordne <- function() {
  results <- ET.McGuinnessBordne(processeddata, 
                                 constants, 
                                 ts="daily",
                                 message="yes", 
                                 AdditionalStats="yes", 
                                 save.csv="no")
  return(results)
}

