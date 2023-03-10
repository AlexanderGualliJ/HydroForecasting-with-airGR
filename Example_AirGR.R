# title: "Adaptacion del modelo hidrologico GR4J Manduriacu"
# author: "Alexander Gualli"
# date: '2023-03-07'
# description: This script uses data from temperature, precipitation and evapotranspiration

library(airGR)

## loading catchment data
data(L0123001)

path = setwd("D:\\Modelo Pronostico Hidrologico\\HydroForecasting-with-airGR")

# Dataset preparation
pathFiles <- list.files(path, pattern = "MHM.*csv", full.names = TRUE)
listObs <- lapply(pathFiles, function(i) {
  iObs <- read.table(i, header = TRUE, sep = ";", dec = ".")
  iObs <- iObs[, c("DATE", "PRECIP", "PET", "FLOW_mmday", "TEMP")]
  colnames(iObs) <- c("Date", "P", "E", "Qmm", "T")
  iObs$Date <- as.POSIXct(iObs$Date, tz = "UTC")
  iObs$Basin <- gsub("(.*)(\\d{5})([.]csv)", "\\2", basename(i))
  return(iObs)
})

# preparation of the InputsModel object
# Order of the basins: Sb. San Pedro, Sb. Pita, Sb. Quito, Sb. Pisque, Sb. Guayllabamba, Sb. Intag, Sb. Alambi, Sb. Chontal ####
InputsModel <- CreateInputsModel(FUN_MOD     = RunModel_GR4J, 
                                 DatesR      = BasinObs$DatesR,
                                 Precip      = BasinObs$P, 
                                 PotEvap     = BasinObs$E,
                                 # Qupstream: time series of upstream flows (catchment average)####
                                 Qupstream   = QObs[, c("Up1", "Up2")],
                                 # LengthHydro: Real giving the distance between the downstream outlet and each upstream inlet of the sub-catchment [km] ####
                                 LengthHydro = c(50, 50, 50, 50, 50), 
                                 # BasinAreas: Real giving the area of each upstream sub-catchment [km2] ####
                                 BasinAreas  = c(100, 100, 100, 100, 100, 100, 100, 100))
                                 

# run period selection
Ind_Run <- seq(which(format(BasinObs$DatesR, format = "%Y-%m-%d")=="1990-01-01"),
               which(format(BasinObs$DatesR, format = "%Y-%m-%d")=="1999-12-31"))

# preparation of the RunOptions object
RunOptions <- CreateRunOptions(FUN_MOD = RunModel_GR4J,
                               InputsModel = InputsModel, 
                               IndPeriod_Run = Ind_Run)

## simulation
Param <- c(X1 = 734.568, X2 = -0.840, X3 = 109.809, X4 = 1.971)
OutputsModel <- RunModel(InputsModel = InputsModel,
                         RunOptions = RunOptions, 
                         Param = Param,
                         FUN_MOD = RunModel_GR4J)

## results preview
plot(OutputsModel, Qobs = BasinObs$Qmm[Ind_Run])

## efficiency criterion: Nash-Sutcliffe Efficiency
InputsCrit <- CreateInputsCrit(FUN_CRIT = ErrorCrit_NSE, 
                               InputsModel = InputsModel,
                               RunOptions = RunOptions, 
                               Obs = BasinObs$Qmm[Ind_Run])

OutputsCrit <- ErrorCrit_NSE(InputsCrit = InputsCrit, 
                             OutputsModel = OutputsModel)
