library( rmarkdown )
library( ggplot2 )

stitchedFile <- "stitched.Rmd"

rmdFiles <- c( "format.Rmd",
  "titlePage.Rmd"
   )

for( i in 1:length( rmdFiles ) )
  {
  if( i == 1 )
    {
    cmd <- paste( "cat", rmdFiles[i], ">", stitchedFile )
    } else {
    cmd <- paste( "cat", rmdFiles[i], ">>", stitchedFile )
    }
  system( cmd )
  }

cat( '\n Pandoc rendering', stitchedFile, '\n' )
render( stitchedFile, pdf_document( number_sections = TRUE, pandoc_args = "--variable=subparagraph" ) )
render( stitchedFile, word_document() )


# render( "simlrPING.Rmd", pdf_document( number_sections = TRUE, pandoc_args = "--variable=subparagraph" ) )

