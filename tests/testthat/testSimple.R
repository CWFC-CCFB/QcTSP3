#'
#' A series of simple tests
#'

restoreQcTSP4Data()

test_that("Testing nb rows in plots", {expect_equal(nrow(QcTSP4Data$plots), 109713)})
test_that("Testing nb rows in sites", {expect_equal(nrow(QcTSP4Data$sites), 109713)})
test_that("Testing nb rows in photoInterpretedStands", {expect_equal(nrow(QcTSP4Data$photoInterpretedStands), 109713)})
test_that("Testing nb rows in trees", {expect_equal(nrow(QcTSP4Data$trees), 3919833)})
test_that("Testing nb rows in studyTrees", {expect_equal(nrow(QcTSP4Data$studyTrees), 355123)})
test_that("Testing nb rows in saplings", {expect_equal(nrow(QcTSP4Data$saplings), 459898)})

plots <- c(700412604, 700412701, 700412702)
selectedTrees <- extractArtemisFormatForMetaModelling(QcTSP4Data, plots)
selectedTrees <- selectedTrees[which(selectedTrees$TREEDHPCM >= 9),]
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees), 211)})

plots <- QcTSP4Data$plots
unique(plots$TYPE_PE)

firstPlotLess7m <- plots[which(plots$TYPE_PE == "PET 4-7 mètres"), "ID_PE"][1]
firstPlotGreaterThan7m <- plots[which(plots$TYPE_PE == "PET 7 mètres et +"), "ID_PE"][1]

plotList <- c(319700401, 700412604) # one of them is a 4-7m plot
selectedTrees <- extractArtemisFormatForMetaModelling(QcTSP4Data, plotList)
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees), 119)})

plotList <- c(700412604, 504656201,603562101,401960602,401960601,319703404) ## only the first has trees and saplings, the others are empty plots
selectedTrees <- extractArtemisFormatForMetaModelling(QcTSP4Data, plotList)
test_that("Testing nb rows in selectedTrees", {expect_equal(nrow(selectedTrees), 116)})

