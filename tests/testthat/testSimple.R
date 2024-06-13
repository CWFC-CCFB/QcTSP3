#'
#' A series of simple tests
#'

restoreQcTSP3Data()

test_that("Testing nb rows in plots", {expect_equal(nrow(QcTSP3Data$plots), 101728)})
test_that("Testing nb rows in sites", {expect_equal(nrow(QcTSP3Data$sites), 101152)})
test_that("Testing nb rows in photoInterpretedStands", {expect_equal(nrow(QcTSP3Data$photoInterpretedStands), 96172)})
test_that("Testing nb rows in trees", {expect_equal(nrow(QcTSP3Data$trees), 1291748)})
test_that("Testing nb rows in studyTrees", {expect_equal(nrow(QcTSP3Data$studyTrees), 335964)})
test_that("Testing nb rows in saplings", {expect_equal(nrow(QcTSP3Data$saplings), 502741)})

plots <- c(8500101, 9400909104,  9904805304)
selectedTrees <- extractArtemisFormatForMetaModelling(QcTSP3Data, plots)
selectedTrees <- selectedTrees[which(selectedTrees$TREEDHPCM >= 9),]
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees), 39)})

plots <- QcTSP3Data$plots
unique(plots$TYPE_PE)

firstPlotLess7m <- plots[which(plots$TYPE_PE == "PET 4-7 mètres"), "ID_PE"][1]
firstPlotGreaterThan7m <- plots[which(plots$TYPE_PE == "PET 7 mètres et +"), "ID_PE"][1]

plotList <- c(19403003, 8500101) # one of them is a 4-7m plot
selectedTrees <- extractArtemisFormatForMetaModelling(QcTSP3Data, plotList)
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees), 14)})

plotList <- c(8500101, 19403002, 19643204, 19655605, 19720702, 19745605, 19836201) ## only the first has trees and saplings, the others are empty plots
selectedTrees <- extractArtemisFormatForMetaModelling(QcTSP3Data, plotList)
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees), 17)})

stratumPlots <- data.frame("stratum"=c("BOJ","ERS","SAB"),"plots"=c(8500101,9400909104,9904805304))## only the first and last has sample trees
selectedTrees <- extractNaturaFormatForMetaModelling(QcTSP3Data, stratumPlots)
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees[[1]]), 39)})

stratumPlots<- data.frame("stratum"=c("BOJ","ERS","SAB"),"plots"=c(8500101,9400909104,9904805304))## only the first and last has sample trees
selectedTrees <- extractNaturaFormatForMetaModelling(QcTSP3Data, stratumPlots)
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees[[2]]), 6)})
