

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
high accuracy across subjects and label sets." This superior performance was
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
projects, use and build on this framework.

Since its inception, though, ANTs has expanded significantly beyond its image
registration origins.  Other core contributions include template building
[@Avants:2010aa], segmentation [@Avants:2011aa], image preprocessing (e.g., bias
correction [@Tustison2009e] and denoising [@Manjon:2010aa]), joint label fusion
[@Wang:2013aa;@Wang:2013ab], and brain cortical thickness estimation
[@Das:2009aa;@Tustison:2014ab] (cf Table \ref{table:papers}). Additionally, ANTs
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

\input{papers_table}

\begin{figure}[htbp] \centering \includegraphics{Figures/coreANtsXNetTools.png}
 \caption{An illustration of the tools and applications available as part of the
 ANTsRNet and ANTsPyNet deep learning toolkits.  Both libraries take advantage
 of ANTs functionality through their respective language interfaces---ANTsR (R)
 and ANTsPy (Python).  Building on the Keras/TensorFlow language, both libraries
 standardize popular network architectures within the ANTs ecosystem and are
 cross-compatible.  These networks are used to train models and weights for such
 applications as brain extraction which are then disseminated to the public.}
 \label{fig:antsXnetTools} \end{figure}

Over the course of its development, ANTs has been extended to complementary
frameworks resulting in the Python- and R-based ANTsPy and ANTsR toolkits,
respectively. These ANTs-based interfaces with extremely popular, high-level,
open-source programming platforms have significantly increased the user base of
ANTs and facilitated research workflows which were not previously possible. The
rapidly rising popularity of deep learning motivated further recent enhancement
of ANTs and its extensions.  Despite the existence of an abundance of online
innovation and code for deep learning algorithms, much of it is disorganized and
lacks a uniformity in structure and external data interfaces which would
facilitate greater uptake. With this in mind, ANTsR spawned the deep learning
ANTsRNet package which is a growing Keras/TensorFlow-based library of popular
deep learning architectures and applications specifically geared towards medical
imaging. Analogously, ANTsPyNet is an additional ANTsX complement to ANTsPy.
Both, which we collectively refer to as "ANTsXNet", are co-developed so as to
ensure cross-compatibility such that training performed in one library is
readily accessible by the other library.  In addition to a variety of popular
network architectures (which are implemented in both 2-D and 3-D), ANTsXNet
contains a host of functionality for medical image analysis that have been
developed in-house and collected from other open-source projects. For example,
an extremely popular ANTsXNet application is a multi-modal brain extraction tool
that uses different variants of the popular U-net [@Falk:2019aa] architecture
for segmenting the brain in multiple modalities.  These modalities include
conventional T1-weighted structural MRI as well as T2-weighted MRI, FLAIR,
fractional anisotropy and BOLD.  Demographic specialization also includes infant
T1-weighted and/or T2-weighted MRI.  Additionally, we have included other models
and weights into our libraries such as a recent BrainAGE estimation model
[@Bashyam:2020aa], based on $>14,000$ individuals; HippMapp3r [@Goubran:2020aa],
a hippocampal segmentation tool; the winning entry of the MICCAI 2017 white
matter hyperintensity segmentation competition [@Li:2018aa]; MRI super
resolution using deep-projection networks [@Haris:2018aa]; and NoBrainer, a
T1-weighted brain extraction approach based on FreeSurfer (see Figure
\ref{fig:antsXnetTools}).

The most recent ANTsX developmental work involves recreating our popular ANTs
cortical thickness \textcolor{blue}{cross-sectional}[@Tustison:2014ab]
\textcolor{blue}{and longitudinal}[@Tustison:2019aa] pipeline\textcolor{blue}{s}
within the ANTsXNet framework for, amongst other potential benefits, increased
computational efficiency.  \textcolor{blue}{These} structural processing
pipeline\textcolor{blue}{s are} currently available as open-source within the
ANTsXNet libraries which underwent a thorough evaluation using both
cross-sectional and longitudinal data and discussed within the context of our
previous evaluations [@Tustison:2014ab;@Tustison:2019aa].  Note that related
work has been recently reported by external groups
[@Rebsamen:2020aa;@Henschel:2020aa]. Fortunately, these overlapping
contributions provide a context for comparison to simultaneously motivate the
utility of the ANTsX ecosystem and to editorialize with respect to best
practices in the field.

