library( ANTsR )
library( ggplot2 )
library( randomForest )
library( ggplot2 )

nPermutations <- 500
trainingPortions <- c( 0.8 )

doCombined <- TRUE 
source( "./geom_split_violin.R" )

resultsData <- data.frame( DataSet = character( 0 ), Pipeline = character( 0 ), RMSE = numeric( 0 ) )
count <- 1

dataSets <- c( "SRPB1600", "IXI", "Kirby", "NKI", "Oasis" )
demoFiles <- c( "srpb1600.csv", "ixi.csv", "kirby.csv", "nki.csv", "oasis.csv" )

#################
#
# Per site
# 

for( d in seq.int( from = 1, to = length( dataSets ) ) )
  {
  cat( "Data set = ", dataSets[d], "\n" )  
  baseDirectory <- paste0( "../../", dataSets[d], "/" )

  ants <- read.csv( paste0( baseDirectory, "antsThickness.csv" ) )
  antsBrainVolumes <- read.csv( paste0( baseDirectory, "antsBrainVolumes.csv" ) )

  antsxnetBrainVolumes <- read.csv( paste0( baseDirectory, "antsxnetBrainVolumes.csv" ) )
  if( dataSets[d] == "SRPB1600" )
    {
    antsxnet <- read.csv( paste0( baseDirectory, "antsxnetThickness2.csv" ) )
    } else {
    antsxnet <- read.csv( paste0( baseDirectory, "antsxnetThickness.csv" ) )
    }

  if( dataSets[d] == "IXI" )
    {
    ants$Subject <- as.factor( as.numeric( substr( ants$Subject, 4, 6 ) ) )
    antsBrainVolumes$Subject <- as.factor( as.numeric( substr( antsBrainVolumes$Subject, 4, 6 ) ) )
    antsxnet$Subject <- as.factor( as.numeric( substr( antsxnet$Subject, 4, 6 ) ) )
    antsxnetBrainVolumes$Subject <- as.factor( as.numeric( substr( antsxnetBrainVolumes$Subject, 4, 6 ) ) )
    }

  if( dataSets[d] == "NKI" )  
    {
    ants$Subject <- gsub( "_defaced_MPRAGE.nii.gz", "", ants$Subject )
    antsxnet$Subject <- gsub( "_defaced_MPRAGE.nii.gz", "", antsxnet$Subject )
    }

  if( dataSets[d] == "Oasis" )  
    {
    ants$Subject <- as.factor( substr( ants$Subject, 1, 13 ) )
    antsBrainVolumes$Subject <- as.factor( substr( antsBrainVolumes$Subject, 1, 13 ) )
    antsxnet$Subject <- as.factor( substr( antsxnet$Subject, 1, 13 ) )
    antsxnetBrainVolumes$Subject <- as.factor( substr( antsxnetBrainVolumes$Subject, 1, 13 ) )
    }

  demo <- read.csv( paste0( baseDirectory, demoFiles[d] ) )

  commonSubjects <- intersect( ants$Subject, antsxnet$Subject )

  ants <- ants[which( ants$Subject %in% commonSubjects ),]
  ants$Subject <- as.factor( ants$Subject )
  ants <- merge( ants, antsBrainVolumes, by = "Subject" )
  ants <- merge( ants, demo, by = "Subject" )
  ants$Gender[which( ants$Gender == "male" )] <- "1"
  ants$Gender[which( ants$Gender == "female" )] <- "2"
  ants$Gender[which( ants$Gender == "M" )] <- "1"
  ants$Gender[which( ants$Gender == "F" )] <- "2"
  ants$Gender <- factor( ants$Gender, levels = c( "1", "2" ) )
  ants <- cbind( Age = ants$Age, Gender = ants$Gender, BrainVolume = ants$BrainVolumes, ants[,2:63] )

  antsxnet <- antsxnet[which( antsxnet$Subject %in% commonSubjects ),]
  antsxnet$Subject <- as.factor( antsxnet$Subject )
  antsxnet <- merge( antsxnet, antsxnetBrainVolumes, by = "Subject" )
  antsxnet <- merge( antsxnet, demo, by = "Subject" )
  antsxnet$Gender[which( antsxnet$Gender == "male" )] <- "1"
  antsxnet$Gender[which( antsxnet$Gender == "female" )] <- "2"
  antsxnet$Gender[which( antsxnet$Gender == "M" )] <- "1"
  antsxnet$Gender[which( antsxnet$Gender == "F" )] <- "2"
  antsxnet$Gender <- factor( antsxnet$Gender, levels = c( "1", "2" ) )
  antsxnet <- cbind( Age = antsxnet$Age, Gender = antsxnet$Gender, BrainVolume = antsxnet$BrainVolumes, antsxnet[,2:63] )

  thicknessPipelines <- list()
  thicknessPipelines[[1]] <- ants
  thicknessPipelines[[2]] <- antsxnet

  numberOfSubjects <- nrow( ants )

  for( p in trainingPortions )
    {
    trainingPortion <- p
    cat( "trainingPortion = ", trainingPortion, "\n", sep = '' )

    forestImp <- list()
    for( n in seq( 1, nPermutations, by = 1 ) )
      {
      cat( "  Permutation ", n, "\n", sep = '' )

      trainingIndices <- sample.int( numberOfSubjects, floor( trainingPortion * numberOfSubjects ), replace = FALSE )

      thicknessTypes = c( 'ANTs', 'ANTsXNet' )
      for( i in seq.int( length( thicknessPipelines ) ) )
        {
        trainingData <- thicknessPipelines[[i]][trainingIndices,]
        testingData <- thicknessPipelines[[i]][-trainingIndices,]

        brainAgeRF <- randomForest( Age ~ ., data = trainingData, importance = TRUE,
                    na.action = na.omit, replace = FALSE, ntree = 200 )
        if( n == 1 )
          {
          if( i == 1 )
            {
            forestImp[[1]] <- importance( brainAgeRF, type = 1 )
            } else {
            forestImp[[2]] <- importance( brainAgeRF, type = 1 )
            }
          } else {
          if( i == 1 )
            {
            forestImp[[1]] <- forestImp[[1]] + importance( brainAgeRF, type = 1 )
            } else {
            forestImp[[2]] <- forestImp[[2]] + importance( brainAgeRF, type = 1 )
            }
          }

        predictedAge <- predict( brainAgeRF, testingData )

        rmse <- sqrt( mean( ( ( testingData$Age - predictedAge )^2 ), na.rm = TRUE ) )
        
        oneData <- data.frame( DataSet = dataSets[d], Pipeline = thicknessTypes[[i]], RMSE = rmse )
        resultsData <- rbind( resultsData, oneData )
        }
      }
    cat( "Mean ANTs rmse = ", mean( resultsData$RMSE[which( resultsData$Pipeline == 'ANTs' )], na.rm = TRUE ), "\n", sep = '' );
    cat( "Mean ANTsXnet rmse = ", mean( resultsData$RMSE[which( resultsData$Pipeline == 'ANTsXNet' )], na.rm = TRUE ), "\n", sep = '' );
    }

  for( n in seq.int( length( forestImp ) ) )
    {
    forestImp[[n]] <- forestImp[[n]] / nPermutations

    forestImp.df <- data.frame( Statistic = names( forestImp[[n]][,1] ), Importance = as.numeric( forestImp[[n]][,1] )  )
    forestImp.df <- forestImp.df[order( forestImp.df$Importance ),]

    forestImp.df$Statistic <- factor( x = forestImp.df$Statistic, levels = forestImp.df$Statistic )

    vPlot <- ggplot( data = forestImp.df, aes( x = Importance, y = Statistic ) ) +
            geom_point( aes( color = Importance ) ) +
            ylab( "" ) +
            scale_x_continuous( "MeanDecreaseAccuracy" ) +
            scale_color_continuous( low = "#232D4B", high = "#E57200" ) +
            theme( axis.text.y = element_text( size = 8 ) ) +
            theme( plot.margin = unit( c( 0.1, 0.1, 0.1, -0.5 ), "cm" ) ) +
            theme( axis.title = element_text( size = 9 ) ) +
            theme( legend.position = "none" )

    ggsave( file = paste( "../../../Text/Figures/rfImportance_", dataSets[d], "_", thicknessTypes[n], ".pdf", sep = "" ), plot = vPlot, width = 3, height = 8 )
    }
  }  


#################
#
# Combined
# 

if( doCombined == TRUE )
  {
  cat( "Data set = Combined\n" )  

  for( d in seq.int( from = 1, to = length( dataSets ) ) )
    {
    baseDirectory <- paste0( "../../", dataSets[d], "/" )

    antsLocal <- read.csv( paste0( baseDirectory, "antsThickness.csv" ) )
    antsLocalBrainVolumes <- read.csv( paste0( baseDirectory, "antsBrainVolumes.csv" ) )

    antsxnetLocal <- read.csv( paste0( baseDirectory, "antsxnetThickness.csv" ) )
    antsxnetLocalBrainVolumes <- read.csv( paste0( baseDirectory, "antsxnetBrainVolumes.csv" ) )

    if( dataSets[d] == "IXI" )
      {
      antsLocal$Subject <- as.factor( as.numeric( substr( antsLocal$Subject, 4, 6 ) ) )
      antsLocalBrainVolumes$Subject <- as.factor( as.numeric( substr( antsLocalBrainVolumes$Subject, 4, 6 ) ) )
      antsxnetLocal$Subject <- as.factor( as.numeric( substr( antsxnetLocal$Subject, 4, 6 ) ) )
      antsxnetLocalBrainVolumes$Subject <- as.factor( as.numeric( substr( antsxnetLocalBrainVolumes$Subject, 4, 6 ) ) )
      }

    if( dataSets[d] == "NKI" )  
      {
      antsLocal$Subject <- gsub( "_defaced_MPRAGE.nii.gz", "", antsLocal$Subject )
      antsxnetLocal$Subject <- gsub( "_defaced_MPRAGE.nii.gz", "", antsxnetLocal$Subject )
      }

    if( dataSets[d] == "Oasis" )  
      {
      antsLocal$Subject <- as.factor( substr( antsLocal$Subject, 1, 13 ) )
      antsLocalBrainVolumes$Subject <- as.factor( substr( antsLocalBrainVolumes$Subject, 1, 13 ) )
      antsxnetLocal$Subject <- as.factor( substr( antsxnetLocal$Subject, 1, 13 ) )
      antsxnetLocalBrainVolumes$Subject <- as.factor( substr( antsxnetLocalBrainVolumes$Subject, 1, 13 ) )
      }

    demo <- read.csv( paste0( baseDirectory, demoFiles[d] ) )

    commonSubjects <- intersect( antsLocal$Subject, antsxnetLocal$Subject )

    antsLocal <- antsLocal[which( antsLocal$Subject %in% commonSubjects ),]
    antsLocal$Subject <- as.factor( antsLocal$Subject )
    antsLocal <- merge( antsLocal, antsLocalBrainVolumes, by = "Subject" )
    antsLocal <- merge( antsLocal, demo, by = "Subject" )
    antsLocal$Gender[which( antsLocal$Gender == "male" )] <- "1"
    antsLocal$Gender[which( antsLocal$Gender == "female" )] <- "2"
    antsLocal$Gender[which( antsLocal$Gender == "M" )] <- "1"
    antsLocal$Gender[which( antsLocal$Gender == "F" )] <- "2"
    antsLocal$Gender <- factor( antsLocal$Gender, levels = c( "1", "2" ) )
    antsLocal <- cbind( Age = antsLocal$Age, Gender = antsLocal$Gender, BrainVolume = antsLocal$BrainVolumes, antsLocal[,2:63] )

    antsxnetLocal <- antsxnetLocal[which( antsxnetLocal$Subject %in% commonSubjects ),]
    antsxnetLocal$Subject <- as.factor( antsxnetLocal$Subject )
    antsxnetLocal <- merge( antsxnetLocal, antsxnetLocalBrainVolumes, by = "Subject" )
    antsxnetLocal <- merge( antsxnetLocal, demo, by = "Subject" )
    antsxnetLocal$Gender[which( antsxnetLocal$Gender == "male" )] <- "1"
    antsxnetLocal$Gender[which( antsxnetLocal$Gender == "female" )] <- "2"
    antsxnetLocal$Gender[which( antsxnetLocal$Gender == "M" )] <- "1"
    antsxnetLocal$Gender[which( antsxnetLocal$Gender == "F" )] <- "2"
    antsxnetLocal$Gender <- factor( antsxnetLocal$Gender, levels = c( "1", "2" ) )
    antsxnetLocal <- cbind( Age = antsxnetLocal$Age, Gender = antsxnetLocal$Gender, BrainVolume = antsxnetLocal$BrainVolumes, antsxnetLocal[,2:63] )

    if( d == 1 )
      {
      ants <- antsLocal
      antsBrainVolumes <- antsLocalBrainVolumes
      antsxnet <- antsxnetLocal
      antsxnetBrainVolumes <- antsxnetLocalBrainVolumes
      } else {
      ants <- rbind( ants, antsLocal )
      antsBrainVolumes <- rbind( antsBrainVolumes, antsLocalBrainVolumes )
      antsxnet <- rbind( antsxnet, antsxnetLocal )
      antsxnetBrainVolumes <- rbind( antsxnetBrainVolumes, antsxnetLocalBrainVolumes )
      }
    }

  thicknessPipelines <- list()
  thicknessPipelines[[1]] <- ants
  thicknessPipelines[[2]] <- antsxnet

  numberOfSubjects <- nrow( ants )

  for( p in trainingPortions )
    {
    trainingPortion <- p
    cat( "trainingPortion = ", trainingPortion, "\n", sep = '' )

    for( n in seq( 1, nPermutations, by = 1 ) )
      {
      cat( "  Permutation ", n, "\n", sep = '' )

      trainingIndices <- sample.int( numberOfSubjects, floor( trainingPortion * numberOfSubjects ), replace = FALSE )

      thicknessTypes = c( 'ANTs', 'ANTsXNet' )
      for( i in seq.int( length( thicknessPipelines ) ) )
        {
        trainingData <- thicknessPipelines[[i]][trainingIndices,]
        testingData <- thicknessPipelines[[i]][-trainingIndices,]

        brainAgeRF <- randomForest( Age ~ ., data = trainingData, importance = TRUE,
                    na.action = na.omit, replace = FALSE, ntree = 200 )

        predictedAge <- predict( brainAgeRF, testingData )

        rmse <- sqrt( mean( ( ( testingData$Age - predictedAge )^2 ), na.rm = TRUE ) )
        
        oneData <- data.frame( DataSet = "Combined", Pipeline = thicknessTypes[[i]], RMSE = rmse )
        resultsData <- rbind( resultsData, oneData )
        }
      }
    cat( "Mean ANTs rmse = ", mean( resultsData$RMSE[which( resultsData$Pipeline == 'ANTs' )], na.rm = TRUE ), "\n", sep = '' );
    cat( "Mean ANTsXnet rmse = ", mean( resultsData$RMSE[which( resultsData$Pipeline == 'ANTsXNet' )], na.rm = TRUE ), "\n", sep = '' );
    }

  resultsData$DataSet[resultsData$DataSet == "SRPB1600"] <- "SRPB"
  resultsData$DataSet[resultsData$DataSet == "Kirby"] <- "MMRR"

  rmsePlot <- ggplot( resultsData, aes( x = DataSet, y = RMSE, fill = Pipeline ) ) +
                    #  geom_split_violin() +
                      geom_boxplot() +
                      scale_y_continuous( "Mean RMSE" ) +
                      scale_x_discrete( "Data set" ) + 
                      scale_fill_manual( values = c( "#E57200", "#232D4B" ) )
  ggsave( filename = paste( "../../../Text/Figures/rmseThicknessPerSite.pdf", sep = "" ), plot = rmsePlot, width = 7, height = 3, units = 'in' )
  }
