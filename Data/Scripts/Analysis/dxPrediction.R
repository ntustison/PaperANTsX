library( ANTsR )
library( randomForest )
library( caret )
library( ggplot2 )
library( MASS )
library( popbio )
library( gdata )
library( ROCR )

baseDirectory <- "/Users/ntustison/Data/Public/SRPB1600/"

ants <- read.csv( paste0( baseDirectory, "antsJlfFlash.csv" ) )
colnames( ants )[1] <- "Subject"
antsBrainVolumes <- read.csv( paste0( baseDirectory, "antsBrainVolumes.csv" ) )
ants <- merge( ants, antsBrainVolumes, by = "Subject" )

antsxnet <- read.csv( paste0( baseDirectory, "antsxnetDeepFlash.csv" ) )
colnames( antsxnet )[1] <- "Subject"
antsxnetBrainVolumes <- read.csv( paste0( baseDirectory, "antsxnetBrainVolumes.csv" ) )
antsxnet <- merge( antsxnet, antsxnetBrainVolumes, by = "Subject" )

demo <- read.csv( "/Users/ntustison/Data/Public/SRPB1600/participants_diagscore/participants_decnef-Table 1.csv" )
colnames( demo )[1] <- "Subject"

commonSubjects <- intersect( ants$Subject, antsxnet$Subject )

ants <- ants[which( ants$Subject %in% commonSubjects ),]
ants$Subject <- as.factor( ants$Subject )
ants <- merge( ants, demo, by = "Subject" )
ants <- cbind( Dx = as.factor( ants$diag ), 
               Age = ants$age, 
               Gender = as.factor( ants$sex ), 
              #  Handedness = as.factor( ants$hand ),
              #  Site = as.factor( ants$site ),
              #  Protocol = as.factor( ants$protocol ),
               BrainVolume = ants$BrainVolumes, 
               ants[,2:15] )

antsxnet <- antsxnet[which( antsxnet$Subject %in% commonSubjects ),]
antsxnet$Subject <- as.factor( antsxnet$Subject )
antsxnet <- merge( antsxnet, demo, by = "Subject" )
antsxnet <- cbind( Dx = as.factor( antsxnet$diag ), 
                   Age = antsxnet$age, 
                   Gender = as.factor( antsxnet$sex ), 
                  #  Handedness = as.factor( antsxnet$hand ),
                  #  Site = as.factor( antsxnet$site ),
                  #  Protocol = as.factor( antsxnet$protocol ),
                   BrainVolume = antsxnet$BrainVolumes, 
                   antsxnet[,2:15] )

############################
#
# For now limit to controls (diag = 0) and depression (diag = 2)
#

ants <- ants[which( ants$Dx == 0 | ants$Dx == 1 ),]
ants$Dx <- factor( ants$Dx, levels = c( 0, 1 ) )
antsxnet <- ants[which( antsxnet$Dx == 0 | antsxnet$Dx == 1 ),]
antsxnet$Dx <- factor( antsxnet$Dx, levels = c( 0, 1 ) )
############################


thicknessPipelines <- list()
thicknessPipelines[[1]] <- ants
thicknessPipelines[[2]] <- antsxnet

numberOfSubjects <- nrow( ants )

nPermutations <- 1000
trainingPortions <- c( 0.8 )

count <- 1
for( p in trainingPortions )
  {
  trainingPortion <- p
  cat( "trainingPortion = ", trainingPortion, "\n", sep = '' )

  resultsData <- data.frame( Pipeline = character( 0 ), RMSE = numeric( 0 ) )

  forestImp <- list()
  fpr <- list()
  tpr <- list()
  for( n in seq( 1, nPermutations, by = 1 ) )
    {
    cat( "  Permutation ", n, "\n", sep = '' )

    trainingIndices <- sample.int( numberOfSubjects, floor( trainingPortion * numberOfSubjects ), replace = FALSE )

    thicknessTypes = c( 'ANTs', 'ANTsXNet' )
    for( i in seq.int( length( thicknessPipelines ) ) )
      {
      trainingData <- thicknessPipelines[[i]][trainingIndices,]
      testingData <- thicknessPipelines[[i]][-trainingIndices,]

      # dxRF <- randomForest( Dx ~ ., data = trainingData, importance = TRUE,
      #                       na.action = na.omit, replace = FALSE )
      # predictions <- predict( dxRF, newdata = testingData )

      gl <- glm( Dx ~ ., data = trainingData, family = "binomial" )
      predictions <- predict( gl, newdata = testingData, type = "response" )

      naIndices <- which( is.na( predictions ) )

      testingDx <- testingData$Dx
      if( length( naIndices ) > 0 )
        {
        predictions <- predictions[-naIndices]
        testingDx <- testingData$Dx[-naIndices]
        }

      dxPredictionROC <- prediction( as.numeric( predictions ), as.numeric( testingDx ) )
      dxPerformanceROC <- performance( dxPredictionROC, "tpr", "fpr" )
      auc <- performance( dxPredictionROC, "auc" )@y.values[[1]]

      fprRun <- dxPerformanceROC@x.values[[1]]
      tprRun <- dxPerformanceROC@y.values[[1]]

      if( n == 1 )
        {
        if( i == 1 )
          {
          # forestImp[[1]] <- importance( dxRF, type = 1 )
          fpr[[1]] <- fprRun 
          tpr[[1]] <- tprRun
          } else {
          # forestImp[[2]] <- importance( dxRF, type = 1 )
          fpr[[2]] <- fprRun 
          tpr[[2]] <- tprRun
          }
        } else {

        myApprox <- approx( fprRun, tprRun, n = length( tpr[[i]] ) )

        if( i == 1 )
          {
          # forestImp[[1]] <- forestImp[[1]] + importance( dxRF, type = 1 )
          fpr[[1]] <- fpr[[1]] + ( myApprox$x - fpr[[1]] ) / ( n + 1 )
          tpr[[1]] <- tpr[[1]] + ( myApprox$y - tpr[[1]] ) / ( n + 1 )          
          } else {
          # forestImp[[2]] <- forestImp[[2]] + importance( dxRF, type = 1 )
          fpr[[2]] <- fpr[[2]] + ( myApprox$x - fpr[[2]] ) / ( n + 1 )
          tpr[[2]] <- tpr[[2]] + ( myApprox$y - tpr[[2]] ) / ( n + 1 )          
          }
        }
      }
    }

  aucData <- data.frame( Pipeline = c( rep( thicknessTypes[1], length( fpr[[1]] ) ),
                                       rep( thicknessTypes[2], length( fpr[[2]] ) ) ), 
                         FPR = c( fpr[[1]], fpr[[2]] ), 
                         TPR = c( tpr[[1]], tpr[[2]] ) ) 
  aucPlot <- ggplot( aucData, aes( x = FPR, y = TPR, colour = Pipeline ) ) +
        geom_line( size = 1.0 ) +
        geom_abline ( intercept = 0, slope = 1, colour = "black", linetype = "dashed", size = 1.0 ) +
        scale_x_continuous( "False positive rate (1-specificity)", limits = c( 0, 1 ) ) +
        scale_y_continuous( "True positive rate (sensitivity)", limits = c( 0, 1 ) )
  ggsave( filename = paste0( "~/Desktop/aucPlot.pdf" ),
          plot = aucPlot, width = 8, height = 6, units = 'in' )

#   for( n in seq.int( length( forestImp ) ) )
#     {
# #     forestImp[[n]] <- forestImp[[n]] / nPermutations

#     forestImp.df <- data.frame( Statistic = names( forestImp[[n]][,1] ), Importance = as.numeric( forestImp[[n]][,1] )  )
#     forestImp.df <- forestImp.df[order( forestImp.df$Importance ),]

#     forestImp.df$Statistic <- factor( x = forestImp.df$Statistic, levels = forestImp.df$Statistic )

#     vPlot <- ggplot( data = forestImp.df, aes( x = Importance, y = Statistic ) ) +
#              geom_point( aes( color = Importance ) ) +
#              ylab( "" ) +
#              scale_x_continuous( "MeanDecreaseAccuracy" ) +
#              scale_color_continuous( low = "navyblue", high = "darkred" ) +
#              theme( axis.text.y = element_text( size = 8 ) ) +
#              theme( plot.margin = unit( c( 0.1, 0.1, 0.1, -0.5 ), "cm" ) ) +
#              theme( axis.title = element_text( size = 9 ) ) +
#              theme( legend.position = "none" )

#     ggsave( file = paste( "~/Desktop/importanceCombined", thicknessTypes[n], p, ".pdf", sep = "" ), plot = vPlot, width = 3, height = 8 )
#     }
  }

