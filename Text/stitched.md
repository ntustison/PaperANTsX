---
title:
author:
address:
output:
  pdf_document:
    keep_tex: true
    fig_caption: true
    latex_engine: xelatex
    number_sections: true
    includes:
      after_body: authorContributions.md
    word_document:
      fig_caption: true
bibliography:
  - references.bib
csl: nature.csl
longtable: true
urlcolor: blue
header-includes:
  - \usepackage[left]{lineno}
  - \linenumbers
  - \usepackage{longtable}
  - \usepackage{graphicx}
  - \usepackage{booktabs}
  - \usepackage{listings}
  - \usepackage{textcomp}
  - \usepackage{xcolor}
  - \usepackage{multirow}
  - \usepackage{subcaption}
  - \definecolor{listcomment}{rgb}{0.0,0.5,0.0}
  - \definecolor{listkeyword}{rgb}{0.0,0.0,0.5}
  - \definecolor{listnumbers}{gray}{0.65}
  - \definecolor{listlightgray}{gray}{0.955}
  - \definecolor{listwhite}{gray}{1.0}
geometry: margin=1.0in
fontsize: 12pt
linestretch: 1.5
mainfont: Georgia
---


\pagenumbering{gobble}

\setstretch{1}

\begin{centering}

$ $

\vspace{4.cm}

\LARGE

{\bf ANTsX:  A dynamic ecosystem for quantitative biological and medical imaging}

\vspace{0.5 cm}

\normalsize

Nicholas J. Tustison$^{1,9}$,
Philip A. Cook$^{2}$,
Andrew J. Holbrook$^{3}$,
Hans J. Johnson$^{4}$,
John Muschelli$^{5}$,
Gabriel A. Devenyi$^{6}$,
Jeffrey T. Duda$^{2}$,
Sandhitsu R. Das$^{2}$,
Nicholas C. Cullen$^{7}$,
Daniel L. Gillen$^{8}$,
Michael A. Yassa$^{9}$,
James R. Stone$^{1}$,
James C. Gee$^{2}$,
Brian B. Avants$^{1}$
for the Alzheimer’s Disease Neuroimaging Initiative

\footnotesize

$^{1}$Department of Radiology and Medical Imaging, University of Virginia, Charlottesville, VA \\
$^{2}$Department of Radiology, University of Pennsylvania, Philadelphia, PA \\
$^{3}$Department of Biostatistics, University of California, Los Angeles, CA \\
$^{4}$Department of Electrical and Computer Engineering, University of Iowa, Philadelphia, PA \\
$^{5}$School of Public Health, Johns Hopkins University, Baltimore, MD \\
$^{6}$Douglas Mental Health University Institute, Department of Psychiatry, McGill University, Montreal, QC \\
$^{7}$Lund University, Scania, SE \\
$^{8}$Department of Statistics, University of California, Irvine, CA \\
$^{9}$Department of Neurobiology and Behavior, University of California, Irvine, CA \\

\end{centering}

\vspace{4.5 cm}


\scriptsize
Corresponding author: \
Nicholas J. Tustison, DSc \
Department of Radiology and Medical Imaging \
University of Virginia \
ntustison@virginia.edu

<!-- \tiny
\noindent\rule{4cm}{0.4pt}

$^{\dagger}$Data used in preparation of this article were obtained from the Alzheimer’s
Disease Neuroimaging Initiative (ADNI) database (http://adni.loni.usc.edu). As
such, the investigators within the ADNI contributed to the design and
implementation of ADNI and/or provided data but did not participate in analysis
or writing of this report. A complete listing of ADNI investigators can be found
at: http://adni.loni.usc.edu/wp-content/uploads/how to apply/AD NI Acknowledgement List.pdf -->

\normalsize

\newpage

\setstretch{1.5}

# Abstract {-}

The Advanced Normalizations Tools ecosystem, known as ANTsX, consists of
multiple open-source software libraries which house top-performing algorithms
used worldwide by scientific and research communities for processing and
analyzing biological and medical imaging data. The base software library, ANTs,
is built upon, and contributes to, the NIH-sponsored Insight Toolkit.  Founded
in 2008 with the highly regarded Symmetric Normalization image registration
framework, the ANTs library has since grown to include additional functionality.
Recent enhancements include statistical, visualization, and deep learning
capabilities through interfacing with both the R statistical project (ANTsR) and
Python (ANTsPy). Additionally, the corresponding deep learning extensions
ANTsRNet and ANTsPyNet (built on the popular TensorFlow/Keras libraries) contain
several popular network architectures and trained models for specific
applications.  One such comprehensive application is a deep learning analog for
generating cortical thickness data from structural T1-weighted brain MRI,
\textcolor{black}{both cross-sectionally and longitudinally}.  These pipelines
significantly improve computational efficiency and provide
comparable-to-superior accuracy \textcolor{black}{over multiple criteria relative
to} the existing ANTs \textcolor{black}{workflows} and
\textcolor{black}{simultaneously} illustrate the importance of the comprehensive
ANTsX approach as a framework for medical image analysis.

\newpage



# The ANTsX ecosystem:  A brief overview {-}

## Image registration origins {-}

The Advanced Normalization Tools (ANTs) is a state-of-the-art, open-source
software toolkit for image registration, segmentation, and other functionality
for comprehensive biological and medical image analysis. Historically, ANTs is
rooted in advanced image registration techniques which have been at the
forefront of the field due to seminal contributions that date back to the
original elastic matching method of Bajcsy and co-investigators
[@Bajcsy:1982aa;@Bajcsy:1989aa;@Gee:2003aa]. Various independent platforms have
been used to evaluate ANTs tools since their early development. In a landmark
paper [@Klein:2009aa], the authors reported an extensive evaluation using
multiple neuroimaging datasets analyzed by fourteen different registration
tools, including the Symmetric Normalization (SyN) algorithm [@Avants:2008aa],
and found that "ART, SyN, IRTK, and SPM’s DARTEL Toolbox gave the best results
according to overlap and distance measures, with ART and SyN delivering the most
consistently high accuracy across subjects and label sets."
\textcolor{black}{Participation in other independent competitions}
[@Murphy:2011aa;@Menze:2014aa] \textcolor{black}{provided additional evidence of
the utility of ANTs registration and other tools}
[@Balakrishnan:2019aa;@Vos:2019wr;@Fu:2020aa]. \textcolor{black}{Despite the
extremely significant potential of deep learning for image registration
algorithmic development} [@Tustison:2019ab], \textcolor{black}{ANTs registration
tools continue to find application in the various biomedical imaging research
communities.}


<!-- This superior performance was
reinforced in a completely different pulmonary imaging evaluation, the
Evaluation of Methods for Pulmonary Image REgistration 2010 (EMPIRE10)
[@Murphy:2011aa], where ANTs was the top performer for the benchmarks used to
assess lung registration accuracy and biological plausibility of the inferred
transform (i.e., boundary alignment, fissure alignment, landmark correspondence,
and displacement field topology). The competition has continued to the present
where SyN has remained the top-ranked algorithm. Even indirect assessments have
demonstrated the performance superiority of ANTs registration. In the MICCAI
2012 multi-atlas label fusion segmentation challenge for brain data, the joint
label fusion algorithm [@Wang:2013ab] (coupled with SyN) was the top performer.
In fact, 6 of the top 10 performing entries in that competition used ANTs for
performing the spatial normalization. A separate competition [@Menze:2014aa] for
segmentation of brain tumors from multi-modal MRI held under the auspices of
MICCAI 2013 was won by ANTs developers where the registration capabilities were
crucial for performance [@Tustison:2014aa]. The following year an ANTs-based
entry for the STACOM workshop concerning cardiac motion estimation won the best
paper award [@Tustison:2015ab].

The ANTs registration component not only encodes advanced developments in image
registration research but also packages these normalization tools as a
full-featured platform that includes an extensive library of similarity
measures, transformation types, and regularizers which are built upon the robust
Insight Toolkit and vetted by users and developers from all over the world.  In
fact, based on performance and innovations within the ANTs toolkit and our track
record of contributions to the ITK registration development efforts, our group
was selected for the most recent major refactoring of the ITK image registration
component [@Avants:2014aa]. Not only did this development involve porting
previously reported research but also included several novel contributions. For
example, a newly formulated B-spline variant of the original SyN algorithm was
proposed and evaluated using multiple publicly available, annotated datasets and
demonstrated statistically significant improvement in label overlap measures
[@Tustison:2013ac].  Moreover, the ANTs/ITK code is open-source and
community-developed which allows the full community, including commercial
projects, use and build on this framework.-->

## Current developments {-}

\begin{figure}[htbp]
  \centering
    \includegraphics[width=0.9\textwidth]{Figures/coreANtsXNetTools.png}
    \caption{An illustration of the tools and applications available as part of the
    ANTsRNet and ANTsPyNet deep learning toolkits.  Both libraries take advantage
    of ANTs functionality through their respective language interfaces---ANTsR (R)
    and ANTsPy (Python).  Building on the Keras/TensorFlow language, both libraries
    standardize popular network architectures within the ANTs ecosystem and are
    cross-compatible.  These networks are used to train models and weights for such
    applications as brain extraction which are then disseminated to the public.}
 \label{fig:antsXnetTools}
 \end{figure}

Since its inception, though, ANTs has expanded significantly beyond its image
registration origins.  Other core contributions include template building
[@Avants:2010aa], segmentation [@Avants:2011aa], image preprocessing (e.g., bias
correction [@Tustison2009e] and denoising [@Manjon:2010aa]), joint label fusion
[@Wang:2013aa;@Wang:2013ab], and brain cortical thickness estimation
[@Das:2009aa;@Tustison:2014ab] (cf Table \ref{table:papers}).
Additionally, ANTs has been integrated into multiple, publicly available workflows such as fMRIprep
[@Esteban:2019aa] and the Spinal Cord Toolbox [@De-Leener:2017aa].  Frequently
used ANTs pipelines, such as cortical thickness estimation [@Tustison:2014ab],
have been integrated into Docker containers and packaged as Brain Imaging Data
Structure (BIDS) [@Gorgolewski:2016aa] and FlyWheel applications (i.e.,
``gears''). It has also been independently ported for various platforms
including Neurodebian [@Halchenko:2012aa] (Debian OS), Neuroconductor
[@Muschelli:2019aa] (the R statistical project), and Nipype
[@Gorgolewski:2011aa] (Python).  \textcolor{black}{Additionally, other widely
used software}, such as FreeSurfer [@Fischl:2012aa], have incorporated
well-performing and complementary ANTs components[@Tustison2009e;@Manjon:2010aa]
into their own libraries. \textcolor{black}{According to GitHub, recent
unique “clones” have averaged 34 per day with the total number of clones being
approximately twice that many.  50 unique contributors to the ANTs library have
made a total of over 4500 commits. Additional insights into usage can be viewed
at the ANTs GitHub website.}


\input{papers_table}

Over the course of its development, ANTs has been extended to complementary
frameworks resulting in the Python- and R-based ANTsPy and ANTsR toolkits,
respectively. These ANTs-based packages interface with extremely popular, high-level,
open-source programming platforms which have significantly increased the user base of
ANTs.  The rapidly rising
popularity of deep learning motivated further recent enhancement of ANTs and its
extensions.  Despite the existence of an abundance of online innovation and code
for deep learning algorithms, much of it is disorganized and lacks a uniformity
in structure and external data interfaces which would facilitate greater uptake.
With this in mind, ANTsR spawned the deep learning ANTsRNet package
[@Tustison:2019ac] which is a growing Keras/TensorFlow-based library of popular
deep learning architectures and applications specifically geared towards medical
imaging. Analogously, ANTsPyNet is an additional ANTsX complement to ANTsPy.
Both, which we collectively refer to as "ANTsXNet", are co-developed so as to
ensure cross-compatibility such that training performed in one library is
readily accessible by the other library. In addition to a variety of popular
network architectures (which are implemented in both 2-D and 3-D), ANTsXNet
contains a host of functionality for medical image analysis that have been
developed in-house and collected from other open-source projects. For example,
an extremely popular ANTsXNet application is a multi-modal brain extraction tool
that uses different variants of the popular U-net [@Falk:2019aa] architecture
for segmenting the brain in multiple modalities.  These modalities include
conventional T1-weighted structural MRI as well as T2-weighted MRI, FLAIR,
fractional anisotropy, and BOLD data.  Demographic specialization also includes infant
T1-weighted and/or T2-weighted MRI. Additionally, we have included other models
and weights into our libraries such as a recent BrainAGE estimation model
[@Bashyam:2020aa], based on $>14,000$ individuals; HippMapp3r [@Goubran:2020aa],
a hippocampal segmentation tool; the winning entry of the MICCAI 2017 white
matter hyperintensity segmentation competition [@Li:2018aa]; MRI super
resolution using deep back-projection networks [@Haris:2018aa]; and NoBrainer, a
T1-weighted brain extraction approach based on FreeSurfer (see Figure
\ref{fig:antsXnetTools}).

## The ANTsXNet cortical thickness pipeline {-}

\begin{figure}[htb]
  \centering
    \includegraphics[width=\textwidth]{Figures/antsxnetPipeline.pdf}
  \caption{\textcolor{black}{Illustration of the ANTsXNet cortical thickness pipeline and the
  relationship to its traditional ANTs analog.  The hash-designated sections
  denote pipeline steps which have been obviated by the deep learning approach.
  These include template-based brain extraction, template-based $n$-tissue
  segmentation, and joint label fusion for cortical labeling.  In our prior work, execution time of the thickness pipeline was dominated by registration.  In the deep version of the pipeline,
it is dominated by DiReCT.  However, we note that  registration and DiReCT execute much more quickly than in the past in part due to major improvements in the underlying ITK multi-threading strategy.}}
  \label{fig:pipeline}
\end{figure}

The most recent ANTsX \textcolor{black}{innovation involves the development of
deep learning analogs} of our popular ANTs cortical thickness
\textcolor{black}{cross-sectional}[@Tustison:2014ab] \textcolor{black}{and
longitudinal}[@Tustison:2019aa] pipeline\textcolor{black}{s} within the ANTsXNet
framework.  \textcolor{black}{Figure} \ref{fig:pipeline},
\textcolor{black}{adapted from our previous work} [@Tustison:2014ab],
\textcolor{black}{illustrates some of the major changes associated with the
single-subject, cross-sectional pipeline.  The resulting improvement in efficiency
derives primarily from eliminating deformable image registration from the
pipeline---a step which has historically been used to propagate prior,
population-based information (e.g., tissue maps) to individual subjects for such
tasks as brain extraction} [@Avants:2010ab] \textcolor{black}{and tissue
segmentation} [@Avants:2011aa] \textcolor{black}{which is now configured within
the neural networks and trained weights.}

\textcolor{black}{These} structural MRI processing pipeline\textcolor{black}{s
are} currently available as open-source within the ANTsXNet libraries.
\textcolor{black}{Evaluations using both cross-sectional and longitudinal data
are described in subsequent sections and couched} within the context of our
previous publications [@Tustison:2014ab;@Tustison:2019aa].
Related work has been recently reported by external groups
[@Rebsamen:2020aa;@Henschel:2020aa] and provide\textcolor{blue}{s} a context for comparison to
motivate the utility of the ANTsX ecosystem.


# Results {-}


## Cross-sectional performance evaluation {-}

\input{dktRegions}


Due to the absence of ground-truth, we utilize the evaluation strategy from our
previous work [@Tustison:2014ab] where we used cross-validation to build and
compare age prediction models from data derived from both the proposed ANTsXNet
pipeline and the established ANTs pipeline.  Specifically, we use "age" as a
well-known and widely-available demographic correlate of cortical thickness
[@Lemaitre:2012aa] and quantify the predictive capabilities of corresponding
random forest classifiers [@Breiman:2001aa] of the form:

\begin{equation}
AGE \sim VOLUME + GENDER + \sum_{i=1}^{62} T(DKT_i)
\end{equation}

with covariates
$GENDER$ and $VOLUME$ (i.e., total intracranial volume). $T(DKT_i)$ is the
average thickness value in the $i^{th}$ Desikian-Killiany-Tourville (DKT) region
[@Klein:2012aa] (cf Table \ref{table:dkt_labels}).  Root mean square error
(RMSE) between the actual and predicted ages are the quantity used for
comparative evaluation.  As we have explained previously [@Tustison:2014ab], we
find these evaluation measures to be much more useful than other commonly
applied criteria as they are closer to assessing the actual utility of these
thickness measurements as biomarkers for
disease [@holbrook2020anterolateral] or growth.  In recent work
[@Rebsamen:2020aa] the authors employ correlation with FreeSurfer thickness
values as the primary evaluation for assessing relative performance with ANTs
cortical thickness [@Tustison:2014ab].  This evaluation, unfortunately, is
fundamentally flawed in that it is a prime example of a type of circularity
analysis [@Kriegeskorte:2009aa] whereby data selection is driven by the same
criteria used to evaluate performance.  Specifically, the underlying DeepSCAN
network used for the tissue segmentation step employs training based on
FreeSurfer results which directly influences thickness values as
thickness/segmentation are highly correlated and vary characteristically between
software packages. Relative performance with ANTs thickness (which does not use
FreeSurfer for training) is then assessed by determining correlations with
FreeSurfer thickness values.  Almost as problematic is their use of
repeatability, which they confusingly label as "robustness," as an additional
ranking criterion. Repeatability evaluations should be contextualized within
considerations such as the bias-variance tradeoff and quantified using relevant
metrics, such as the intra-class correlation coefficient which takes into
account both inter- and intra-observer variability.

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

In addition to the training data listed above, to ensure generalizability, we
also compared performance using the SRPB data set [@srpb] comprising over 1600
participants from 12 sites.  Note that we recognize that we are processing a
portion of the evaluation data through certain components of the proposed deep
learning-based pipeline that were used to train the same pipeline components.
Although this does not provide evidence for generalizability (which is why we
include the much larger SRPB data set), it is still interesting to examine the
results since, in this case, the deep learning training can be considered a type
of noise reduction on the final results.  It should be noted that training did not
use age prediction (or any other evaluation or related measure) as a criterion
to be optimized during network model training (i.e., circular analysis
[@Kriegeskorte:2009aa]).

The results are shown in Figure \ref{fig:agePrediction} where we used
cross-validation with 500 permutations per model per data set (including a
"combined" set) and an 80/20 training/testing split. The ANTsXNet deep learning
pipeline outperformed the classical pipeline [@Tustison:2014ab] in terms of age
prediction in all data sets except for IXI.  This also includes the
cross-validation iteration where all data sets were combined.  Additionally,
repeatability assessment on \textcolor{blue}{the regional cortical thickness
values of the} MMRR data set yielded ICC values ("average random rater") of 0.99
for both pipelines.

\textcolor{blue}{
A comparative illustration of regional thickness measurements between the ANTs
and ANTsXNet pipelines is provided in Figure \ref{fig:radar} for three different
ages spanning the lifespan.  Linear models of the form}

\begin{equation}
  T(DKT_i) \sim GENDER + AGE
\end{equation}

\textcolor{blue}{
were created for each of the 62 DKT regions for each pipeline.  These models were
then used to predict thickness values for each gender at ages of 25 years, 50 years,
and 75 years and subsequently plotted relative to the absolute maximum predicted
thickness value (ANTs:  right entorhinal cortex at 25 years, male).  Although
there appear to be systematic differences between specific regional predicted
thickness values (e.g., $T(ENT)_{ANTs} > T(ENT)_{ANTsXNet}$,
$T(pORB)_{ANTs} < T(pORB)_{ANTsXNet}$)), a pairwise t-test evidenced no statistically
significant difference between the predicted thickness values of the two pipelines.}

\begin{figure}[htb]
  \centering
    \includegraphics[width=0.9\textwidth]{Figures/radarSPRB.pdf}
  \caption{\textcolor{blue}{Radar plots enabling comparison of relative thickness values between
  the ANTs and ANTsXNet cortical thickness pipelines at three different ages
  sampling the life span.  See Table \ref{table:dkt_labels} for region abbreviations. }}
  \label{fig:radar}
\end{figure}


<!-- Importance plots
ranking the cortical thickness regions and the other covariates of Equation (1)
are shown in Figure \ref{fig:radar}. Rankings employ
"MeanDecreaseAccuracy" which quantifies the decrease in model accuracy based on
the exclusion of a specific random forest regressor.  -->

<!--
\begin{figure}[htb]
  \centering
  \begin{subfigure}{0.4\textwidth}
    \centering
    \includegraphics[width=0.75\linewidth]{Figures/rfImportance_SRPB1600_ANTs.pdf}
    \caption{ANTs}
  \end{subfigure}%
  \begin{subfigure}{0.4\textwidth}
    \centering
    \includegraphics[width=0.75\linewidth]{Figures/rfImportance_SRPB1600_ANTsXNet.pdf}
    \caption{ANTsXNet}
  \end{subfigure}
\caption{Importance plots for the SRPB data set using ``MeanDecreaseAccuracy'' for the
random forest regressors (i.e., cortical thickness regions, gender, and brain volume
specified by Equation (1).}
\label{fig:rfimportance}
\end{figure}
-->


## Longitudinal performance evaluation {-}

\begin{figure}[!htb]
  \centering
  \begin{subfigure}{0.95\textwidth}
    \centering
    \includegraphics[width=1.0\linewidth]{Figures/variance.ratio_FINALX.png}
    \caption{}
  \end{subfigure}
  \begin{subfigure}{0.95\textwidth}
    \centering
    \includegraphics[width=1\linewidth]{Figures/allData_FINALX2.png}
    \caption{}
  \end{subfigure}
  \caption{Performance over longitudinal data as determined by the variance ratio.
    (a) Region-specific 95\% confidence intervals of the variance ratio showing the
    superior performance of the longitudinally tailored ANTsX-based pipelines, including
    ANTsSST and ANTsXNetLong. (b) Residual variability, between subject, and variance ratio
    values per pipeline over all DKT regions. }
\label{fig:longeval1}
\end{figure}

\begin{figure}[!htb]
  \centering
    \includegraphics[width=1.0\linewidth]{Figures/logPvalues2.pdf}
  \caption{Measures for the supervised evaluation
  strategy where log p-values for diagnostic
  differentiation of LMCI-CN, AD-LMCI, and AD-CN subjects are plotted for all pipelines
  over all DKT regions. }
  \label{fig:longeval2}
\end{figure}

Given the excellent performance and superior computational efficiency of the
proposed ANTsXNet pipeline for cross-sectional data, we evaluated its
performance on longitudinal data using the longitudinally-specific evaluation
strategy and data we employed with the introduction of the longitudinal version
of the ANTs cortical thickness pipeline [@Tustison:2019aa].  \textcolor{black}{
We also evaluated an ANTsXNet-based pipeline tailored specifically for longitudinal
data.  In this variant, an SST is generated and processed using the previously
described ANTsXNet cross-sectional pipeline which yields tissue spatial priors.
These spatial priors are used in our traditional brain segmentation approach}
[@Avants:2011aa]\textcolor{black}{.  The computational efficiency of this variant is also
significantly improved, in part, due to the elimination of the costly SST prior generation
which uses multiple registrations combined with joint label fusion} [@Wang:2013ab].

The ADNI-1 data used for our longitudinal performance evaluation
[@Tustison:2019aa] consists of over 600 subjects (197 cognitive normals, 324
LMCI subjects, and 142 AD subjects) with one or more follow-up image acquisition
sessions every 6 months (up to 36 months) for a total of over 2500 images. In
addition to the ANTsXNet pipelines \textcolor{black}{(``ANTsXNetCross'' and
``ANTsXNetLong'')} for the current evaluation, our previous work included the
FreeSurfer [@Fischl:2012aa] cross-sectional ("FSCross") and longitudinal
("FSLong") streams, the ANTs cross-sectional pipeline ("ANTsCross") in addition
to two longitudinal ANTs-based variants ("ANTsNative" and "ANTsSST"). Two
evaluation measurements, one unsupervised and one supervised, were used to
assess comparative performance between all seven pipelines.  We add the results
of the ANTsXNet pipeline \textcolor{black}{cross-sectional and longitudinal}
evaluations in relation to these other pipelines to provide a comprehensive
overview of relative performance.

First, \textcolor{black}{linear mixed-effects} (LME) [@verbeke1997linear] modeling was used to quantify
between-subject and residual variabilities, the ratio of which provides an
estimate of the effectiveness of a given biomarker for distinguishing between
subpopulations. In order to assess this criteria while accounting for changes
that may occur through the passage of time, we used the following Bayesian LME
model:
\begin{gather}
  Y^k_{ij} \sim N(\alpha^k_i + \beta^k_i t_{ij}, \sigma_k^2) \\ \nonumber
  \alpha^k_i \sim N(\alpha^k_0, \tau^2_k) \,\,\,\, \beta^k_i \sim N(\beta^k_0, \rho^2_k) \\ \nonumber
  \alpha^k_0, \beta^k_0 \sim N(0,10) \,\,\,\,  \sigma_k, \tau_k, \rho_k \sim \mbox{Cauchy}^+ (0, 5)
\end{gather}
where $Y^k_{ij}$ denotes the $i^{th}$ individual's cortical thickness
measurement corresponding to the $k^{th}$ region of interest at the time point
indexed by $j$ and specification of variance priors to half-Cauchy distributions
reflects commonly accepted best practice in the context of hierarchical models
[@gelman2006prior].  The ratio of interest, $r^k$, per region
of the between-subject variability, $\tau_k$, and residual variability, $\sigma_k$
is
\begin{align}
  r^k = \frac{\tau_k}{\sigma_k}, k = 1,\ldots,62
\end{align}
where the posterior distribution of $r_k$ was summarized via the posterior
median.

Second, the supervised evaluation employed Tukey post-hoc analyses with false
discovery rate (FDR) adjustment to test the significance of the
LMCI-CN, AD-LMCI, and AD-CN diagnostic contrasts.  This is provided by the
following LME model
\begin{align}
  \Delta Y \sim & Y_{bl} + AGE_{bl} + ICV_{bl} + APOE_{bl} + GENDER + DIAGNOSIS_{bl} \\ \nonumber
                & + VISIT:DIAGNOSIS_{bl} + (1 | ID) + (1 | SITE).
\end{align}
Here, $\Delta Y$ is the change in thickness of the $k^{th}$ DKT region from
baseline (bl) thickness $Y_{bl}$ with random intercepts for both the individual
subject ($ID$) and the acquisition site. The subject-specific covariates $AGE$, $APOE$
status, $GENDER$, $DIAGNOSIS$, $ICV$, and $VISIT$ were taken directly from the
ADNIMERGE package.


\textcolor{black}{Results for all pipelines with respect to the longitudinal
evaluation criteria are shown in Figures \ref{fig:longeval1} and
\ref{fig:longeval2}.  Figure \ref{fig:longeval1}(a) provides the 95\% confidence
intervals of the variance ratio for all 62 regions of the DKT cortical labeling
where ANTsSST consistently performs best with ANTsXNetLong also performing
well.  These quantities are summarized in Figure \ref{fig:longeval1}(b).  The
second evaluation criteria compares diagnostic differentiation via LMEs.  Log
p-values are provided in Figure \ref{fig:longeval2} which demonstrate excellent
LMCI-CN and AD-CN differentiation for both deep learning pipelines.}

<!-- , suggesting that
better classification performance---e.g., superior differentiation between
LMCI and AD cohorts---is completely possible for an ANTsXNet extension that
leverages the longitudinal information the current implementation does not. One
such piece of information is repeated measures, i.e., the fact that we observe
some subjects multiple times. Failure to account for this information explains
lower between-subject variabilities for ANTsXNet. In turn, all variability
expresses itself through higher within-subject residuals. But there is an
additional reason for ANTsXNet exhibiting higher residual variability. Neural
networks achieve their power by increasing their effective degrees of freedom
way beyond those of traditional linear models. In terms of the bias-variance
tradeoff, such an increase in model complexity translates to significantly less
predictive bias while simultaneously leading to greater predictive variance.
This fact explains how ANTsXNet can perform so well while retaining such a large
residual variability.  An interesting question is how longitudinal extensions to
ANTsXNet will perform with respect to the same measure. -->



# Discussion {-}

The ANTsX software ecosystem provides a comprehensive framework for quantitative
biological and medical imaging.  Although ANTs, the original core of ANTsX, is
still at the forefront of image registration technology, it has moved
significantly beyond its image registration origins.  This expansion is not
confined to technical contributions (of which there are many) but also consists
of facilitating access to a wide range of users who can use ANTsX tools (whether
through bash, Python, or R scripting) to construct tailored
pipelines for their own studies or to take advantage of our pre-fabricated
pipelines.  And given the open-source nature of the ANTsX software, usage is not
limited, for example, to \textcolor{blue}{non-commercial} use---a common constraint
characteristic of other packages \textcolor{blue}{such as the FMRIB Software Library}
(https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).

One of our most widely used pipelines is the estimation of cortical thickness
from neuroimaging. This is understandable given the widespread usage of regional
cortical thickness as a biomarker for developmental or pathological trajectories
of the brain.  In this work, we used this well-vetted ANTs tool to provide training data
for producing alternative variants which leverage deep learning for improved
computational efficiency and also provides superior performance with respect to
previously proposed evaluation measures for both cross-sectional [@Tustison:2014ab]
and longitudinal scenarios [@Tustison:2019aa].  In addition to providing the tools
which generated the original training data for the proposed ANTsXNet pipeline, the
ANTsX ecosystem provides a full-featured platform for the additional steps such as
preprocessing (ANTsR/ANTsPy); data augmentation (ANTsR/ANTsPy); network construction
and training (ANTsRNet/ANTsPyNet); and visualization and statistical
analysis of the results (ANTsR/ANTsPy).

\textcolor{black}{It is the comprehensiveness of ANTsX that provides several
advantages over much of the deep learning work that is currently taking place in
medical imaging. In other words, various steps in the deep learning training
processing (e.g., data augmentation, preprocessing) can all be performed within
the same ecosystem where such important details as header information for image
geometry are treated the same.} In contrast, related work [@Rebsamen:2020aa]
described and evaluated a similar thickness measurement pipeline.  However, due
to the lack of a complete processing and analysis framework, training data was
generated using the FreeSurfer stream, deep learning-based brain segmentation
employed DeepSCAN [@deepscan] (in-house software), and cortical thickness
estimation [@Das:2009aa] was generated using the ANTs toolkit.
The interested researcher must ensure the consistency of the input/output
interface between packages (a task for which the Nipype development team is
quite familiar.)

\textcolor{blue}{
Although potentially advantageous in terms of such issues as computational
efficiency and other performance measures, there are a number of limitations
associated with the ANTsXNet pipeline that should be mentioned both to guide
potential users and possibly motivate future related research.  As is the
case with many deep learning models, usage is restricted based on training
data.  For example, much of the publicly available brain data has been
anonymized through various defacing protocols.  That is certainly the case
with the training data used for the ANTsXNet pipeline which has consequences
specific to the brain extraction step which could lead to poor performance.
We are currently aware of this issue and have provided a temporary workaround
while simultaneously resuming training on whole head data to mitigate this issue.
Related, although the ANTsXNet pipeline performs relatively well as assessed
across lifespan data, performance might be hampered for specific age ranges
(e.g., neonates), whereas the traditional ANTs cortical thickness pipeline
is more flexible and might provide better age-targeted performance.  This is the subject
of ongoing research.  Additionally, application of the ANTsXNet pipeline would
be limited with high-resolution acquisitions.  Due to the heavy memory
requirements associated with deep learning training, the utility of any
resolution greater than ~1 mm isotropic would not be leveraged by the
existing pipeline.  However, there is a potential pipeline variation (akin
to the longitudinal variant) that would be worth exploring where Deep Atropos
is used only to provide the priors for a subsequent traditional Atropos
segmentation on high-resolution data.}

In terms of additional future work, the recent surge and utility of deep learning in
medical image analysis has significantly guided the areas of active ANTsX
development.  As demonstrated in this work with our widely used cortical
thickness pipelines, there are many potential benefits of deep learning analogs
to existing ANTs tools as well as the development of new ones. Performance is
\textcolor{black}{mostly} comparable-to-superior relative to existing pipelines
depending on the evaluation metric.  \textcolor{black}{Specifically, the ANTsXNet
cross-sectional pipeline does well for the age prediction performance framework
and in terms of the ICC.  Additionally, this pipeline performs relatively well
for longitudinal ADNI data for disease differentiation but not so much in terms
of the generic variance ratio criterion.  However, for such longitudinal-specific
studies, the ANTsXNet longitudinal variant performs well for both performance
measures.} We see possible additional longitudinal extensions incorporating
subject ID and months as additional network inputs.



<!-- This is mimicked, in a sense, by training the brain segmentation
and cortical parcellation models in the affinely aligned MNI template space
[@Fonov:2009aa] (further discussion in the Methods section). -->


# Methods {-}

## The original ANTs cortical thickness pipeline {-}

The original ANTs cortical thickness pipeline [@Tustison:2014ab] consists of the
following steps:

* preprocessing: denoising [@Manjon:2010aa] and bias correction [@Tustison:2010ac];
* brain extraction [@Avants:2010ab];
* brain segmentation with spatial tissue priors [@Avants:2011aa] comprising the
    * cerebrospinal fluid (CSF),
    * gray matter (GM),
    * white matter (WM),
    * deep gray matter,
    * cerebellum, and
    * brain stem; and
* cortical thickness estimation [@Das:2009aa].

Our recent longitudinal variant [@Tustison:2019aa] incorporates an additional
step involving the construction of a single subject template (SST)
[@Avants:2010aa] coupled with the generation of tissue spatial priors of the SST
for use with the processing of the individual time points as described above.

Although the resulting thickness maps are conducive to voxel-based
[@Ashburner:2000aa] and related analyses[@Avants:2012aa], here we employ the
well-known Desikan-Killiany-Tourville (DKT) [@Klein:2012aa] labeling protocol
(31 labels per hemisphere) to parcellate the cortex for averaging thickness
values regionally (cf Table \ref{table:dkt_labels}). This allows us to 1) be
consistent in our evaluation strategy for comparison with our previous work
[@Tustison:2014ab;@Tustison:2019aa] and 2) leverage an additional deep
learning-based substitution within the proposed pipeline.


## Overview of cortical thickness via ANTsXNet  {-}

The entire analysis/evaluation framework, from preprocessing to
statistical analysis, is made possible through the ANTsX ecosystem and simplified
through the open-source R and Python platforms.  Preprocessing, image registration,
and cortical thickness estimation are all available through the ANTsPy and ANTsR
libraries whereas the deep learning steps are performed through networks
constructed and trained via ANTsRNet/ANTsPyNet with data augmentation strategies
and other utilities built from ANTsR/ANTsPy functionality.

The brain extraction, brain segmentation, and DKT parcellation deep learning
components were trained using data derived from our previous work
[@Tustison:2014ab]. Specifically, the IXI [@ixi], MMRR [@Landman:2011aa], NKI
[@nki], and OASIS [@oasis] data sets, and the corresponding derived data,
comprising over 1200 subjects from age 4 to 94, were used for network training.
Brain extraction employs a traditional 3-D U-net network [@Falk:2019aa] with
whole brain, template-based data augmentation [@Tustison:2019ac] whereas brain
segmentation and DKT parcellation are processed via 3-D U-net networks with
attention gating [@Schlemper:2019aa] on image octant-based batches.
\textcolor{blue}{Additional network architecture details are given below.}  We
emphasize that a single model (\textcolor{black}{as opposed to ensemble
approaches where multiple models are used to produce the final solution}
[@Li:2018aa]) was created for each of these steps and was used for all the
experiments described below.


## Implementation {-}

Software, average DKT regional thickness values for all data sets, and the
scripts to perform both the analysis and obtain thickness values for a single
subject \textcolor{black}{(cross-sectionally or longitudinally)} are provided as
open-source.  Specifically, all the ANTsX libraries are hosted on GitHub
(https://github.com/ANTsX).  The cross-sectional data and analysis code are
available as .csv files and R scripts at the GitHub repository dedicated to this
paper (https://github.com/ntustison/PaperANTsX) whereas the longitudinal data
and evaluation scripts are organized with the repository associated with our
previous work [@Tustison:2019aa] (https://github.com/ntustison/CrossLong).

\vspace{10mm}

\setstretch{1.0}

\lstset{frame = htb,
        framerule = 0.25pt,
        float,
        fontadjust,
        backgroundcolor={\color{listlightgray}},
        basicstyle = {\ttfamily\scriptsize},
        keywordstyle = {\ttfamily\color{listkeyword}\textbf},
        identifierstyle = {\ttfamily},
        commentstyle = {\ttfamily\color{listcomment}\textit},
        stringstyle = {\ttfamily},
        showstringspaces = false,
        showtabs = false,
        numbers = none,
        numbersep = 6pt,
        numberstyle={\ttfamily\color{listnumbers}},
        tabsize = 2,
        language=python,
        floatplacement=!h,
        caption={\small ANTsPy/ANTsPyNet command calls
        for a single IXI subject in the evaluation study for
        the cross-sectional pipeline.
        },
        captionpos=b,
        label=listing:antspyCorticalThickness
        }
\begin{lstlisting}
import ants
import antspynet

# ANTsPy/ANTsPyNet processing for subject IXI002-Guys-0828-T1
t1_file = "IXI002-Guys-0828-T1.nii.gz"
t1 = ants.image_read(t1_file)

# Atropos six-tissue segmentation
atropos = antspynet.deep_atropos(t1, do_preprocessing=True, verbose=True)

# Kelly Kapowski cortical thickness (combine Atropos WM and deep GM)
kk_segmentation = atropos['segmentation_image']
kk_segmentation[kk_segmentation == 4] = 3
kk_gray_matter = atropos['probability_images'][2]
kk_white_matter = atropos['probability_images'][3] + atropos['probability_images'][4]
kk = ants.kelly_kapowski(s=kk_segmentation, g=kk_gray_matter, w=kk_white_matter,
                         its=45, r=0.025, m=1.5, x=0, verbose=1)

# Desikan-Killiany-Tourville labeling
dkt = antspynet.desikan_killiany_tourville_labeling(t1, do_preprocessing=True, verbose=True)

# DKT label propagation throughout the cortex
dkt_cortical_mask = ants.threshold_image(dkt, 1000, 3000, 1, 0)
dkt = dkt_cortical_mask * dkt
kk_mask = ants.threshold_image(kk, 0, 0, 0, 1)
dkt_propagated = ants.iMath(kk_mask, "PropagateLabelsThroughMask", kk_mask * dkt)

# Get average regional thickness values
kk_regional_stats = ants.label_stats(kk, dkt_propagated)
\end{lstlisting}

\setstretch{1.5}

In Listing 1, we show the ANTsPy/ANTsPyNet code snippet for cross-sectional
processing a single subject which starts with reading the T1-weighted MRI input
image, through the generation of the Atropos-style six-tissue segmentation and
probability images, application of ``ants.kelly_kapowski`` (i.e., DiReCT), DKT
cortical parcellation, subsequent label propagation through the cortex, and,
finally, regional cortical thickness tabulation.  \textcolor{black}{The
cross-sectional and longitudinal pipelines are encapsulated in the ANTsPyNet
functions} ``antspynet.cortical_thickness`` and
``antspynet.longitudinal_cortical_thickness``, \textcolor{black}{respectively.}
Note that there are precise, line-by-line R-based analogs available through
ANTsR/ANTsRNet.

Both the ``ants.deep_atropos`` and
``antspynet.desikan_killiany_tourville_labeling`` functions perform brain
extraction using the ``antspynet.brain_extraction`` function.  Internally,
``antspynet.brain_extraction`` contains the requisite code to build the network
and assign the appropriate hyperparameters.  The model weights are automatically
downloaded from the online hosting site https://figshare.com (see the function
``get_pretrained_network`` in ANTsPyNet or ``getPretrainedNetwork`` in ANTsRNet
for links to all models and weights) and loaded to the constructed network.
``antspynet.brain_extraction`` performs a quick translation transformation to a
specific template (also downloaded automatically) using the centers of intensity
mass, a common alignment initialization strategy. This is to ensure proper gross
orientation.  Following brain extraction, preprocessing for the other two deep
learning components includes ``ants.denoise_image`` and
``ants.n4_bias_correction`` and an affine-based reorientation to a version of
the MNI template [@Fonov:2009aa].

We recognize the presence of some redundancy due to the repeated application of
certain preprocessing steps.  Thus, each function has a ``do_preprocessing``
option to eliminate this redundancy for knowledgeable users but, for simplicity
in presentation purposes, we do not provide this modified pipeline here.
Although it should be noted that the time difference is minimal considering the
longer time required by ``ants.kelly_kapowski``. ``ants.deep_atropos`` returns
the segmentation image as well as the posterior probability maps for each tissue
type listed previously. ``antspynet.desikan_killiany_tourville_labeling``
returns only the segmentation label image which includes not only the 62
cortical labels but the remaining labels as well.  The label numbers and
corresponding structure names are given in the program description/help.
Because the DKT parcellation will, in general, not exactly coincide with the
non-zero voxels of the resulting cortical thickness maps, we perform a label
propagation step to ensure the entire cortex, and only the non-zero thickness
values in the cortex, are included in the tabulated regional values.

\textcolor{black}{As mentioned previously, the longitudinal version,}
``antspynet.longitudinal_cortical_thickness``, \textcolor{black}{adds an SST
generation step which can either be provided as a program input or it can be
constructed from spatial normalization of all time points to a specified
template.}  ``ants.deep_atropos`` \textcolor{black}{is applied to the SST
yielding spatial tissues priors which are then used as input to}
``ants.atropos`` \textcolor{black}{for each time point. } ``ants.kelly_kapowski``
\textcolor{black}{is applied to the result to generate the desired cortical
thickness maps.}

\textcolor{black}{Computational time on a CPU-only platform is approximately 1
hour primarily due to} ``ants.kelly_kapowski`` \textcolor{black}{processing.
Other preprocessing steps, i.e., bias correction and denoising, are on the order of a
couple minutes. This total time should be compared with $4-5$ hours
using the traditional pipeline employing the} ``quick``
\textcolor{black}{registration option or $10-15$ hours with the more
comprehensive registration parameters employed).  As mentioned previously,
elimination of the registration-based propagation of prior probability images to
individual subjects is the principal source of reduced computational time. For
ROI-based analyses, this is in addition to the elimination of the optional
generation of a population-specific template. Additionally, the use of}
``antspynet.desikan_killiany_tourville_labeling``, \textcolor{black}{for cortical
labeling (which completes in less than five minutes) eliminates the need for
joint label fusion which requires multiple pairwise registrations for each
subject in addition to the fusion algorithm itself.}


## Training details {-}

Training differed slightly between models and so we provide details for each of
these components below.  For all training, we used ANTsRNet scripts and custom
batch generators.  Although the network construction and other functionality is
available in both ANTsPyNet and ANTsRNet (as is model weights compatibility), we
have not written such custom batch generators for the former (although this is
on our to-do list).  In terms of hardware, all training was done on a DGX (GPUs:
4X Tesla V100, system memory: 256 GB LRDIMM DDR4).

__T1-weighted brain extraction.__  A whole-image 3-D U-net model [@Falk:2019aa]
was used in conjunction with multiple training sessions employing a Dice loss
function followed by categorical cross entropy.  \textcolor{black}{Training data
was derived from the same multi-site data described previously processed through
our registration-based approach} [@Avants:2010ab].  A center-of-mass-based
transformation to a standard template was used to standardize such parameters as
orientation and voxel size.  However, to account for possible different header
orientations of input data, a template-based data augmentation scheme was used
[@Tustison:2019ac] whereby forward and inverse transforms are used to randomly
warp batch images between members of the training population (followed by
reorientation to the standard template). A digital random coin flipping for
possible histogram matching [@Nyul:1999aa] between source and target images
further increased data augmentation. \textcolor{black}{The output of the network
is a probabilistic mask of the brain.} \textcolor{blue}{The architecture
consists of four encoding/decoding layers with eight filters at the base layer
which doubled every layer.} Although not detailed here, training for brain
extraction in other modalities was performed similarly.

__Deep Atropos.__ Dealing with 3-D data presents unique barriers for training
that are often unique to medical imaging.  Various strategies are employed such
as minimizing the number of layers and/or the number of filters at the base
layer of the U-net architecture (as we do for brian extraction).  However, we
found this to be too limiting for capturing certain brain structures such as the
cortex. 2-D and 2.5-D approaches are often used with varying levels of success
but we also found better performance using full 3-D information.  This led us to
try randomly selected 3-D patches of various sizes.  However, for both the
six-tissue segmentations and DKT parcellations, we found that an octant-based
patch strategy yielded the desired results.  Specifically, after a brain
extracted affine normalization to the MNI template, the normalized image is
cropped to a size of [160, 190, 160].  Overlapping octant patches of size [112,
112, 112] were extracted from each image and trained using a batch size of 12
such octant patches with weighted categorical cross entropy as the loss
function.  \textcolor{blue}{The architecture consists of four encoding/decoding
layers with 16 filters at the base layer which doubled every layer.}

As we point out in our earlier work [@Tustison:2014ab], obtaining
proper brain segmentation is perhaps the most critical step to estimating
thickness values that have the greatest utility as a potential biomarker.  In
fact, the first and last authors (NT and BA, respectively) spent much time
during the original ANTs pipeline development [@Tustison:2014ab] trying to get
the segmentation correct which required manually looking at many images and
manually adjusting where necessary.  This fine-tuning is often omitted or not
considered when other groups [@Clarkson:2011aa;@Schwarz:2016aa;@Rebsamen:2020aa]
use components of our cortical thickness pipeline which can be potentially
problematic[@Tustison:2013aa]. Fine-tuning for this particular workflow was also
performed between the first and last authors using manual variation of the
weights in the weighted categorical cross entropy.
\textcolor{black}{Specifically, the weights of each tissue type were altered in
order to produce segmentations which most resemble the traditional Atropos segmentations.}
Ultimately, we settled on a weight vector of $(0.05, 1.5, 1, 3, 4, 3, 3)$ for
the CSF, GM, WM, Deep GM, brain stem, and cerebellum, respectively.  Other
hyperparameters can be directly inferred from explicit specification in the
actual code.  As mentioned previously, training data was derived from
application of the ANTs Atropos segmentation [@Avants:2011aa] during the course
of our previous work
[@Tustison:2014ab].  Data augmentation included small affine and deformable
perturbations using ``antspynet.randomly_transform_image_data`` and random
contralateral flips.

__Desikan-Killiany-Tourville parcellation.__  Preprocessing for the DKT
parcellation training was similar to the Deep Atropos training.  However, the
number of labels and the complexity of the parcellation required deviation from
other training steps.  First, labeling was split into an inner set and an outer
set.  Subsequent training was performed separately for both of these sets.  For
the cortical labels, a set of corresponding input prior probability maps were
constructed from the training data (and are also available and automatically
downloaded, when needed, from https://figshare.com). Training occurred over
multiple sessions where, initially, categorical cross entropy was used and then
subsquently refined using a Dice loss function.  Whole-brain training was
performed on a brain-cropped template size of [96, 112, 96].
Inner label training was performed similarly to our brain extraction training
where the number of layers at the base layer was reduced to eight. Training also
occurred over multiple sessions where, initially, categorical cross entropy was
used and then subsquently refined using a Dice loss function.  Other
hyperparameters can be directly inferred from explicit specification in the
actual code. Training data was derived from application of joint label fusion
[@Wang:2013aa] during the course of our previous work [@Tustison:2014ab].  When
calling ``antspynet.desikan_killiany_tourville_labeling``, inner labels are
estimated first followed by the outer, cortical labels.

<!-- ## ADNI image data

A portion of the data used in the preparation of this article were obtained from
the Alzheimer’s Disease Neuroimaging Initiative (ADNI) database
(adni.loni.usc.edu). The ADNI was launched in 2003 as a public-private
partnership, led by Principal Investigator Michael W. Weiner, MD. The primary
goal of ADNI has been to test whether serial magnetic resonance imaging (MRI),
positron emission tomography (PET), other biological markers, and clinical and
neuropsychological assessment can be combined to measure the progression of mild
cognitive impairment (MCI) and early Alzheimer’s disease (AD). -->


\clearpage

## Acknowledgments {-}

Support for the research reported in this work includes funding from the
National Heart, Lung, and Blood Institute  of the National Institutes of Health
(R01HL133889) and a combined grant from Cohen Veterans Bioscience (CVB-461) and
the Office of Naval Research (N00014-18-1-2440).

Data used in preparation of this article were obtained from the Alzheimer’s
Disease Neuroimaging Initiative (ADNI) database (http://adni.loni.usc.edu). As
such, the investigators within the ADNI contributed to the design and
implementation of ADNI and/or provided data but did not participate in analysis
or writing of this report. A complete listing of ADNI investigators can be found
at: http://adni.loni.usc.edu/wp-content/uploads/how to apply/AD NI Acknowledgement List.pdf


Data collection and sharing for this project was funded by the Alzheimer's
Disease Neuroimaging Initiative (ADNI) (National Institutes of Health Grant U01
AG024904) and DOD ADNI (Department of Defense award number W81XWH-12-2-0012).
ADNI is funded by the National Institute on Aging, the National Institute of
Biomedical Imaging and Bioengineering, and through generous contributions from
the following: AbbVie, Alzheimer’s Association; Alzheimer’s Drug Discovery
Foundation; Araclon Biotech; BioClinica, Inc.; Biogen; Bristol-Myers Squibb
Company; CereSpir, Inc.; Cogstate; Eisai Inc.; Elan Pharmaceuticals, Inc.; Eli
Lilly and Company; EuroImmun; F. Hoffmann-La Roche Ltd and its affiliated
company Genentech, Inc.; Fujirebio; GE Healthcare; IXICO Ltd.; Janssen Alzheimer
Immunotherapy Research \& Development, LLC.; Johnson \& Johnson Pharmaceutical
Research \& Development LLC.; Lumosity; Lundbeck; Merck \& Co., Inc.; Meso Scale
Diagnostics, LLC.; NeuroRx Research; Neurotrack Technologies; Novartis
Pharmaceuticals Corporation; Pfizer Inc.; Piramal Imaging; Servier; Takeda
Pharmaceutical Company; and Transition Therapeutics. The Canadian Institutes of
Health Research is providing funds to support ADNI clinical sites in Canada.
Private sector contributions are facilitated by the Foundation for the National
Institutes of Health (www.fnih.org). The grantee organization is the Northern
California Institute for Research and Education, and the study is coordinated by
the Alzheimer’s Therapeutic Research Institute at the University of Southern
California. ADNI data are disseminated by the Laboratory for Neuro Imaging at
the University of Southern California.
\newpage

# References {-}