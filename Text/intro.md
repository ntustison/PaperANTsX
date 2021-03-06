
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

