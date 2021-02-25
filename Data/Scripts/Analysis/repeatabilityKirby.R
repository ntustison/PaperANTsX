library( psych )

ants <- read.csv( "../../Kirby/antsThickness.csv" )
antsxnet <- read.csv( "../../Kirby/antsxnetThickness.csv" )

visitPairs <- c( '01', '25',
                 '02', '37',
                 '03', '22',
                 '04', '11',
                 '05', '31',
                 '06', '20',
                 '07', '34',
                 '08', '29',
#                 '09', '42',
                 '10', '21',
                 '12', '19',
                 '13', '24',
                 '14', '17',
                 '15', '26',
                 '16', '35',
                 '18', '38',
                 '23', '27',
                 '28', '40',
                 '30', '33',
                 '32', '36',
                 '39', '41' )
subjectIds <- paste0( "KKI2009-", visitPairs )

thicknessData <- list()
thicknessData[[1]] <- ants[ants$Subject %in% subjectIds,]
thicknessData[[2]] <- antsxnet[antsxnet$Subject %in% subjectIds,]

for( i in seq.int( 2 ) )
  {
  thicknessData[[i]] <- thicknessData[[i]][match( subjectIds, thicknessData[[i]]$Subject),]

  corticalLabels <- tail( colnames( thicknessData[[i]] ), n = 62 )
  numberOfLabels <- length( corticalLabels )
  beginIndex <- length( colnames( thicknessData[[i]] ) ) - 62 + 1
  endIndex <- length( colnames( thicknessData[[i]] ) )
  indices <- beginIndex:endIndex

  scanOrder <- rep( c( "First", "Repeat" ), 0.5 * ( nrow( thicknessData[[i]] ) ) )
  thicknessData[[i]]$ScanOrder <- scanOrder

  iccData <- data.frame( First = as.vector( data.matrix( thicknessData[[i]][which( thicknessData[[i]]$ScanOrder == "First" ), indices] ) ),
                         Repeat = as.vector( data.matrix( thicknessData[[i]][which( thicknessData[[i]]$ScanOrder == "Repeat" ), indices] ) ) )

  iccResults <- ICC( iccData )
  print( iccResults )
  cat( "\n" )
  }

