#'
#' Script to produce the data.frame objects
#' that contain the information from
#' the original database.
#' @author Mathieu Fortin - June 2024
#'

rm(list=ls())
options(scipen=999)

source("./compilation/utilityFunctions.R")

if (!require("RODBC")) {
  install.packages("RODBC")
  require("RODBC")
}

.driverinfo <- "Driver={Microsoft Access Driver (*.mdb, *.accdb)};"
.db <- file.path(getwd(), "compilation", "PET3.mdb") # database path
.path <- paste0(.driverinfo, "DBQ=", .db)
channel <- odbcDriverConnect(.path, rows_at_time = 1)
message("Here are the tables in the database:")
sqlTables(channel, tableType = "TABLE")$TABLE_NAME

plots <- sqlFetch(channel, "PLACETTE") #### 101 728 observations
sites <- sqlFetch(channel, "STATION_PE") #### 101 742 observations
photoInterpretedStands <- sqlFetch(channel, "PEE_ORI_SOND") #### 96 172 observations
trees <- sqlFetch(channel, "DENDRO_TIGES") #### 1 291 748 observations
studyTrees <- sqlFetch(channel, "DENDRO_ARBRES_ETUDES") #### 335 964 observations
saplings <- sqlFetch(channel, "DENDRO_GAULES") #### 502 741 observations
close(channel)

sort(unique(sites$GUIDE_ECO))
GUIDE_ECO <- c("1a", "2a", "2b", "2c", "3ab",  "3c", "3d",
               "4a", "4bc", "4de", "4f", "4gh",
               "5a", "5bcd", "5ef", "5g", "5hi", "5jk",
               "6ab", "6cdefg", "6hi", "6j", "6kl", "6mn", "6opqr")
SDOMAINE <- c("1", "2OUEST", "2EST", "2EST", "3OUEST", "3EST", "3EST",
               "4OUEST", "4OUEST", "4EST", "4EST", "4EST",
               "5OUEST", "5OUEST", "5EST", "5EST", "5EST", "5EST",
               "6OUEST", "6OUEST", "6EST", "6EST", "6EST", "6EST", "6EST")
matchREGECO_SDOMAINE <- data.frame(GUIDE_ECO, SDOMAINE)
sites <- merge(sites, matchREGECO_SDOMAINE, by = "GUIDE_ECO")
plots <- plots[,colnames(plots)[which(colnames(plots) != "SHAPE")]]

TSP3 <- list()
TSP3$plots <- plots
TSP3$sites <- sites
TSP3$photoInterpretedStands <- photoInterpretedStands
TSP3$trees <- trees
TSP3$studyTrees <- studyTrees
TSP3$saplings <- saplings

saveRDS(TSP3, file = file.path(getwd(),"inst","extdata", "QcTSP3.Rds"), compress = "xz")
