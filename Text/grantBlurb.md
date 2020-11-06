

The Advanced Normalization Tools (ANTs) is a state-of-the-art, open-source
software toolkit for image registration, segmentation, and other functionality
for comprehensive biological and medical image analysis. Historically, ANTs is
rooted in advanced image registration techniques which have been at the
forefront of the field due to seminal contributions that date back to the
original elastic matching method of Bajcsy and co-investigators
[@Bajcsy:1982aa;@Bajcsy:1989aa;@Gee:2003aa] and continues to set the standard in
the field.   Various independent platforms have been used to evaluate ANTs tools
since their early development. In a landmark paper [@Klein:2009aa], the authors
reported an extensive evaluation using multiple neuroimaging datasets analyzed
by fourteen different registration tools, including the Symmetric Normalization
(SyN) algorithm [@Avants:2008aa] found in ANTs [@Avants:2011ab], and found that
"ART, SyN, IRTK, and SPM’s DARTEL Toolbox gave the best results according to
overlap and distance measures, with ART and SyN delivering the most consistently
high accuracy across subjects and label sets."

Since its inception, though, ANTs has expanded significantly beyond its image
registration origins.  Other core contributions include template building
[@Avants:2010aa], segmentation [@Avants:2011aa], image preprocessing (e.g., bias
correction [@Tustison2009e] and denoising [@Manjon:2010aa]), joint label fusion
[@Wang:2013aa;@Wang:2013ab], and brain cortical thickness estimation
[@Das:2009aa;@Tustison:2014ab]. Additionally, ANTs
has been integrated into multiple, publicly available workflows such as fMRIprep
[@Esteban:2019aa] and the Spinal Cord Toolbox [@De-Leener:2017aa].  Frequently
used ANTs pipelines, such as cortical thickness estimation [@Tustison:2014ab],
have been integrated into Docker containers and packaged as Brain Imaging Data
Structure (BIDS) [@Gorgolewski:2016aa] and FlyWheel applications (i.e.,
``gears''). It has also been independently ported for various platforms
including Neurodebian [@Halchenko:2012aa] (Debian OS), Neuroconductor
[@Muschelli:2019aa] (the R statistical project), and Nipype
[@Gorgolewski:2011aa] (Python).  Even competing softwares, such as FreeSurfer
[@Fischl:2012aa], have incorporated well-performing and complementary ANTs
components[@Tustison2009e;@Manjon:2010aa] into their own libraries.

