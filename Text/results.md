
# Results {-}

As described in [@Tustison:2014ab], the ANTs cortical thickness pipeline
consists of the following steps:

* preprocessing: denoising [@Manjon:2010aa];
* preprocessing: bias correction [@Tustison:2010ac];
* brain extraction [@Avants:2010ab];
* brain segmentation [@Avants:2011aa] comprising the
    * cerebrospinal fluid,
    * gray matter,
    * white matter,
    * deep gray matter,
    * cerebellum, and
    * brain stem; and
* cortical thickness estimation [@Das:2009aa].

Although the resulting thickness maps are conducive to voxel-based
[@Ashburner:2000aa] and related analyses[@Avants:2012aa], here we
employ the well-known Desikan-Killiany-Tourville [@Klein:2012aa] labeling
protocol (31 labels per hemisphere) to parcellate the cortex for averaging
thickness values regionally. This allows us to 1) be consistent in our
evaluation strategy for comparison with our previous work
[@Tustison:2014ab;@Tustison:2019aa] and 2) leverage an additional deep
learning-based substitution within the proposed pipeline. Our recent longitudinal
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

The brain extraction, brain segmentation, and DKT parcellation steps were
trained using data derived from our previous work [@Tustison:2014ab].
Specifically, the IXI[^1] , MMRR [Landman:2011aa], NKI[^2], and OASIS[^3] data
sets, and the corresponding derived data, comprising over 1200 subjects from age
4 to 94 were used for training. Brain extraction employed a traditional 3-D
U-net network [@Falk:2019aa] with whole brain, template-based data augmentation
[@Tustison:2019ac] whereas brain segmentation and DKT parcellation used 3-D
U-net networks with attention gating [@Schlemper:2019aa] on image octant-based
batches.  We emphasize that a single model was created for each of these steps
and were used for all the experiments described below.  More details including
actual ANTsRNet and ANTsPyNet pipeline code are found in the Methods section.

[^1]: https://brain-development.org/ixi-dataset/
[^2]: http://fcon_1000.projects.nitrc.org/indi/pro/nki.html
[^3]: https://www.oasis-brains.org

## Cross-sectional cortical thickness {-}

Due to the absence of ground-truth, we utilize the evaluation strategy from our
previous work [@Tustison:2014ab] where we used cross-validation to build and
compare age prediction models from data derived from both the proposed pipeline
and the classic pipeline.  Specifically, we use age as a well-known and
widely-available demographic correlate of cortical thickness [@Lemaitre:2012aa]
and build random forest models of the form:
\begin{equation}
AGE \sim VOLUME + GENDER + \sum_{i=1}^{62} T(DKT_i)
\end{equation}
with covariates $GENDER$ and $VOLUME$ (i.e., total intracranial volume).
$T(DKT_i)$ is the average thickness value in the $i^{th}$ DKT region.  Root mean
square error between the actual and predicted ages are the quantity used for
comparison.

In addition to the data listed above, to ensure generalizability, we also
processed the SRPB1600 data set[^4] comprising over 1600 participants from 12
sites and performed the same comparative evaluation. Note that we recognize that
we are processing data through the proposed deep learning-based pipeline that
were used to train certain components of the pipeline.  Although this does not
ensure generalizability (which is why we include SRPB1600), we believe that
the reader would be interested to see the resulting comparative performance since
training did not use age prediction as a criterion to be optimized
(i.e., circular analysis [@Kriegeskorte:2009aa]).

[^4]: https://bicr-resource.atr.jp/srpbs1600/

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

The results are shown in Figure \ref{fig:agePrediction} where we used cross-validation
with 500 permutations and an 80/20 training/testing split.   The ANTsXNet deep learning
pipeline outperformed the classical pipeline[@Tustison:2014ab] in terms of age prediction
in all data sets except for IXI.  This also includes the cross-validation iteration where
all data sets were combined.

## Longitudinal cortical thickness {-}


