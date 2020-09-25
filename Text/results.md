
# Results {-}

As described in [@Tustison:2014ab], the ANTs cortical thickness pipeline
consists of the following steps:

* Preprocessing: denoising [@Manjon:2010aa].
* Preprocessing: bias correction [@Tustison:2010ac].
* Brain extraction [@Avants:2010ab].
* Brain segmentation [@Avants:2011aa] comprising the
    * cerebrospinal fluid,
    * gray matter,
    * white matter,
    * deep gray matter,
    * cerebellum, and
    * brain stem.
* Cortical thickness estimation [@Das:2009aa].

Although the resulting thickness maps are conducive to voxel-based
[@Ashburner:2000aa] and related analyses (e.g., [@Avants:2012aa]), here we
employ the well-known Desikan-Killiany-Tourville [@Klein:2012aa] labeling
protocol (32 labels per hemisphere) to parcellate the cortex for averaging
thickness values regionally. This allows us to 1) be consistent in our
evaluation strategy for comparison with our previous work
[@Tustison:2014ab;@Tustison:2019aa] and 2) leverage an additional deep
learning-based substitution within the proposed pipeline. The longitudinal
variant incorporates an additional step involving the construction of a single
subject template [@Avants:2010aa].  This is mimicked, in a sense, by training
the brain segmentation and cortical parcellation models in the affinely aligned
MNI template space [@Fonov:2009aa].

Note that the entire analysis/evaluation framework, from preprocessing to
statistical analysis, is made possible through the ANTsX ecosystem and simplified
through the open-source R and Python platforms.  Preprocessing, image registration,
and cortical thickness estimation are all available through the ANTsPy and ANTsR
libraries whereas the deep learning steps are made possible through networks
constructed and trained via ANTsRNet/ANTsPyNet with data augmentation strategies
built from ANTsR/ANTsPy functionality.

The brain extraction, brain segmentation, and DKT parcellation steps were trained
using the data derived from the data used in [@Tustison:2014ab].  Specifically,
the IXI, MMRR, NKI, and OASIS data sets comprising over 1200 subjects from age
4 to 94 were used .



## Cross-sectional cortical thickness {-}

\begin{figure}[htb]
  \centering
    \includegraphics[width=\textwidth]{Figures/rmseThicknessPerSite.pdf}
  \caption{Distribution of mean RMSE values (500 permutations) for age
          prediction across the different data sets between
          the traditional ANTs and deep learning-based ANTsXNet pipelines. Total
          mean values are as follows: Combined---9.3 years (ANTs) and 8.2 years
          (ANTsXNet); IXI---7.9 years (ANTs) and 8.6 years (ANTsXNet);
          MMRR---7.9 years (ANTs) and 7.6 years (ANTsXNet); NKI---8.7 years
          (ANTs) and 7.9 years (ANTsXNet); OASIS---9.2 years (ANTs) and 8.0
          years (ANTsXNet); and SRPB---9.2 years (ANTs) and 8.1 years
          (ANTsXNet).}
  \label{fig:agePrediction}
\end{figure}

## Longitudinal cortical thickness


