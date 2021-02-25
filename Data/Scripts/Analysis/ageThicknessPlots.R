library( ggplot2 )
library( ANTsR )
library( brainGraph )
library( ggradar2 )


# dataSets <- c( "SRPB1600", "IXI", "Kirby", "NKI", "Oasis" )
# demoFiles <- c( "srpb1600.csv", "ixi.csv", "kirby.csv", "nki.csv", "oasis.csv" )

dataSets <- c( "SRPB1600" )
demoFiles <- c( "srpb1600.csv" )

pipelineNames <- c( "ANTs", "ANTsXNet" )

figuresDirectory <- "../../../Text/Figures/"

#################
#
# Per site
#

radarData <- data.frame( DataSet = character(),
                         Pipeline = character(),
                         Hemisphere = character(),
                         Region = character(),
                         Age = character(),
                         Gender = character(),
                         Thickness = numeric() )

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

  corticalLabels <- tail( colnames( thicknessPipelines[[1]] ), n = 62 )

  gender <- as.numeric( thicknessPipelines[[1]]$Gender )
  gender[which( gender == 1 )] <- 'male';
  gender[which( gender == 2 )] <- 'female';

  for( p in 1:length( thicknessPipelines ) )
    {
    for( i in 1:length( corticalLabels ) )
      {
      regionalData <- data.frame( Thickness = thicknessPipelines[[p]][,i+3],
                                  Gender = thicknessPipelines[[p]]$Gender,
                                  Age = thicknessPipelines[[p]]$Age )
      myformula <- as.formula( paste0( "Thickness ~ 1 + Gender + Age" ) )
      cat( paste0( corticalLabels[i], " ~ 1 + Gender + Age" ), "\n" )
      mylm <- lm( myformula, data = regionalData )
      mysummary <- summary( mylm )
      print( mysummary$coefficients )
      cat( "------------------------------------------\n" )

      modelData <- data.frame( Age = c( 25, 25, 50, 50, 75, 75 ),
                               Gender = c( "1", "2", "1", "2", "1", "2" ) )
      prediction <- predict( mylm, modelData )

      for( n in seq.int( length( prediction ) ) )
        {
        singleData <- data.frame( DataSet = dataSets[d],
                                  Pipeline = pipelineNames[p],
                                  Hemisphere = ifelse( i < 32, "left", "right" ),
                                  Region = substring( dkt$name[i], 2 ),
                                  Age = modelData$Age[n],
                                  Gender = modelData$Gender[n],
                                  Thickness = prediction[n] )
        radarData <- rbind( radarData, singleData )
        }

      ##
      #  Plot age vs. thickness
      ##

      # thickness <- thicknessPipelines[[p]][,i+3]

      # plotData <- data.frame( cbind( Age = thicknessPipelines[[p]]$Age, Thickness = thickness, Gender = gender ) )
      # plotData <- transform( plotData, Gender = factor( Gender ) );
      # plotData <- transform( plotData, Age = as.numeric( Age ) );
      # plotData <- transform( plotData, Thickness = as.numeric( Thickness ) );

      # male_color = "darkred";
      # female_color = "navyblue";

      # thickPlot <- ggplot( plotData, aes( x = Age, y = Thickness, group = Gender ) ) +
      #             stat_smooth( aes( group = Gender, colour = Gender ), formula = y ~ 1 + x, method = "lm", size = 1, n = 1000, level = 0.95, se = TRUE, fullrange = TRUE, fill = 'black', alpha = 0.5 ) +
      #             geom_point( data = plotData, aes( colour = Gender ), size = 3, alpha = 0.5 ) +
      #             scale_x_continuous( "Age (years)", breaks = seq( 10, 90, by = 10 ), labels = seq( 10, 90, by = 10 ), limits = c( 10, 90 ) ) +
      #             scale_y_continuous( "Thickness (mm)", breaks = seq( 0, 6, by = 1 ), labels = seq( 0, 6, by = 1 ), limits = c( 0, 6 ) ) +
      #             scale_colour_manual( values = c( male_color, female_color ), labels = c( "Male", "Female" ) ) +
      #             ggtitle( paste( "Cortical thickness (", corticalLabels[i], ")", sep = "" ) )
      # outputDirectory <- paste0( baseDirectory, "AgeThicknessPlots/", pipelineNames[p], "/" )
      # if( ! dir.exists( outputDirectory ) )
      #   {
      #   dir.create( outputDirectory, showWarnings = FALSE, recursive = TRUE )
      #   }
      # ggsave( filename = paste0( outputDirectory, "/", corticalLabels[i], ".pdf" ), plot = thickPlot, width = 8, height = 6, units = 'in' )
      }
    }
  }

ages <- c( 25, 50, 75 )
genders <- c( "1", "2" )

groupNames <- c( "ANTs Left", "ANTs Right",  "ANTsXNet Left", "ANTsXNet Right" )
groupColors <- c( "orange", "darkorange1", "royalblue", "royalblue4" )

for( i in seq.int( length( ages ) ) )
  {
  for( j in seq.int( length( genders ) ) )
    {
    radarDataSubset <- radarData[which( radarData$Age == ages[i] & radarData$Gender == genders[j] ),]

    plotData <- matrix()

    tmp1 <- radarDataSubset[which( radarDataSubset$Hemisphere == "left" & radarDataSubset$Pipeline == "ANTs" ),]
    tmp2 <- radarDataSubset[which( radarDataSubset$Hemisphere == "right" & radarDataSubset$Pipeline == "ANTs" ),]
    plotData <- rbind( tmp1$Thickness, tmp2$Thickness )
    tmp <- radarDataSubset[which( radarDataSubset$Hemisphere == "left" & radarDataSubset$Pipeline == "ANTsXNet" ),]
    plotData <- rbind( plotData, tmp$Thickness )
    tmp <- radarDataSubset[which( radarDataSubset$Hemisphere == "right" & radarDataSubset$Pipeline == "ANTsXNet" ),]
    plotData <- rbind( plotData, tmp$Thickness )

    plotDataFrame <- as.data.frame( plotData )
    colnames( plotDataFrame ) <- tmp$Region
    rownames( plotDataFrame ) <- groupNames

    fullscore <- rep( max( radarData$Thickness ), ncol( plotDataFrame ) )


    radarPlot <- ggradar2( plotDataFrame, grid.min = 0.0, grid.max = 1.0, group.colours = groupColors,
      group.fill.colours = groupColors, fullscore = fullscore, plot.legend = FALSE )
    ggsave( filename = paste0( figuresDirectory, "/", "radar", ages[i], "_", genders[j], ".pdf" ), plot = radarPlot, width = 8, height = 8, units = 'in' )

    }
  }

antsData <- radarData[which( radarData$Pipeline == "ANTs" ),]
antsxnetData <- radarData[which( radarData$Pipeline == "ANTsXNet" ),]
t.test( antsData$Thickness, antsxnetData$Thickness, paired = TRUE )