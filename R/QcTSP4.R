########################################################
# Clean database from TSP - fourth campaign - data.
# Author: Mathieu Fortin, Canadian Wood Fibre Centre
# Date: February 2024
########################################################

.welcomeMessage <- function() {
  packageStartupMessage("Welcome to QcTSP4!")
  packageStartupMessage("The QcTSP4 package provides a clean version of the TSP of the fourth campaign of Quebec provincial inventory.")
}


.onAttach <- function(libname, pkgname) {
  .welcomeMessage()
}

.onUnload <- function(libpath) {
}

.onDetach <- function(libpath) {
}


.loadPackageData <- function(filename) {
  return(readRDS(system.file(paste0("extdata/",filename,".Rds"), package = "QcTSP4")))
}

#'
#' Restore Quebec TSP Data in the Global Environment.
#'
#' @description This function call creates four data.frame objects that contain
#' the tree measurements.
#'
#' @details
#'
#' The resulting list encompasses five data.frame objects are: \cr
#' \itemize{
#' \item plots: the list of plots \cr
#' \item sites: some site information recorded in those plots \cr
#' \item photoInterpretedStands: some site information recorded through photo-interpretation \cr
#' \item trees: the talled trees \cr
#' \item studyTrees: the study trees (a subsample of trees) \cr
#' }
#'
#' @export
restoreQcTSP4Data <- function() {
  assign("QcTSP4Data", .loadPackageData("QcTSP4"), envir = .GlobalEnv)
}


#'
#' Extract plot list for Artemis simulation
#' @param QcTSP4Data the database that is retrieved through the restoreQcTSP4Data function
#' @param plots a vector of integers standing for the plot id to be considered
#' @return a data.frame object formatted for Capsis Web API
#'
#' @export
extractArtemisFormatForMetaModelling <- function(QcTSP4Data, plots) {
  plotList <- unique(plots) ### make sure there is no duplicate
  plotInfo <- QcTSP4Data$plots[which(QcTSP4Data$plots$ID_PE %in% plotList), c("ID_PE", "LATITUDE", "LONGITUDE", "DATE_SOND")]
  siteInfo <- QcTSP4Data$sites[which(QcTSP4Data$sites$ID_PE %in% plotList), c("ID_PE", "ALTITUDE", "SDOMAINE", "GUIDE_ECO", "TYPE_ECO", "CL_DRAI")]
  standInfo <- QcTSP4Data$photoInterpretedStands[which(QcTSP4Data$photoInterpretedStands$ID_PE %in% plotList), c("ID_PE", "CL_AGE", "TYPE_ECO")]
  colnames(standInfo)[3] <- "TYPE_ECO_PHOTO"
  treeInfo <- QcTSP4Data$trees[which(QcTSP4Data$trees$ID_PE %in% plotList), c("ID_PE", "ESSENCE", "CL_DHP", "HAUT_ARBRE", "TIGE_HA")]
  saplings <- QcTSP4Data$saplings
  saplings$HAUT_ARBRE <- NA
  saplingInfo <- saplings[which(saplings$ID_PE %in% plotList), c("ID_PE", "ESSENCE", "CL_DHP", "HAUT_ARBRE", "TIGE_HA")]
  plotInfo <- merge(plotInfo, standInfo, by = "ID_PE")
  plotInfo <- merge(plotInfo, siteInfo, by="ID_PE")
  output_tree <- merge(plotInfo,
                  treeInfo,
                  by = "ID_PE")
  output_saplings <- merge(plotInfo,
                          saplingInfo,
                          by = "ID_PE")
  output <- rbind(output_tree, output_saplings)
  outputPlots <- unique(output$ID_PE)

  missingPlots <- setdiff(plotList, outputPlots)
  if (length(missingPlots) > 0) {
    message("These plots have no saplings and no trees: ", paste(missingPlots, collapse = ", "))
    message("We will add a fake sapling to make sure they are properly imported in Artemis-2009.")
    fakeSaplings <- NULL
    for (mPlot in missingPlots) {
      fakeSaplings <- rbind(fakeSaplings, data.frame(ID_PE = mPlot, ESSENCE = "SAB", CL_DHP = as.integer(2), HAUT_ARBRE = NA, TIGE_HA = as.integer(25)))
    }
    output_MissingSaplings <- merge(plotInfo,
                                   fakeSaplings,
                                   by = "ID_PE")
    output <- rbind(output, output_MissingSaplings)
  }

  outputPlots <- unique(output$ID_PE)
  missingPlots <- setdiff(plotList, outputPlots)
  if (length(missingPlots) > 0) {
    stop("Apparently, there are still some plots with no saplings and no trees: ", paste(missingPlots, collapse = ", "))
  }

  output <- output[order(output$ID_PE, -output$CL_DHP),]
  output$ANNEE_SOND <- as.integer(format(output$DATE_SOND, "%Y"))
  output$TREEFREQ <- output$TIGE_HA / 25
  output$TREESTATUS <- 10
  output$TREEHEIGHT <- output$HAUT_ARBRE * .1

  output <- output[,c("ID_PE", "LATITUDE", "LONGITUDE", "ALTITUDE", "SDOMAINE", "GUIDE_ECO", "TYPE_ECO", "CL_DRAI",
                      "ESSENCE", "TREESTATUS", "CL_DHP", "TREEFREQ", "TREEHEIGHT", "ANNEE_SOND", "TYPE_ECO_PHOTO", "CL_AGE")]
  colnames(output) <- c("PLOT", "LATITUDE", "LONGITUDE", "ALTITUDE", "SUBDOMAIN", "ECOREGION", "TYPEECO", "DRAINAGE_CLASS",
                        "SPECIES", "TREESTATUS", "TREEDHPCM", "TREEFREQ", "TREEHEIGHT", "ANNEE_SOND", "STANDTYPEECO", "STANDAGE")
  return(output)
}




