

ANTs is a state-of-the-art, open-source software toolkit for image registration,
segmentation, and other medical image analysis functionality. Historically, ANTs
is rooted in advanced image registration techniques which have been at the
forefront of the field due to seminal contributions that date back to the
original elastic matching method of Bajcsy and co-investigators
[@Bajcsy:1982aa;@Bajcsy:1989aa;@Gee:2003aa] and continues to set the standard in
the field for pulmonary [@Murphy:2011aa], brain [@Klein:2009aa], and cardiac
imaging [@Tustison:2015ab]. The ANTs registration component not only encodes
advanced developments in image registration research, notably the Symmetric
Normalization (SyN) algorithm for deformable diffeomorphic mappings
[@Avants:2008aa], but also packages these normalization tools within a
full-featured platform that includes an extensive library of similarity
measures, transformation types, and regularizers which are built upon the robust
Insight Toolkit and vetted by users and developers from all over the world
[@Avants:2014aa]. Since its inception, though, ANTs has expanded significantly
beyond its image registration origins.  Other core contributions include
template building [@Avants:2010aa], segmentation [@Avants:2011aa], image
preprocessing (e.g., bias correction [@Tustison2009e] and denoising
[@Manjon:2010aa]), joint label fusion [@Wang:2013aa;@Wang:2013ab], and brain
cortical thickness estimation [@Das:2009aa;@Tustison:2014ab] (cf Table
\ref{table:papers}). Additionally, ANTs has been integrated into multiple,
publicly available workflows such as fMRIprep [@Esteban:2019aa] and the Spinal
Cord Toolbox [@De-Leener:2017aa].  Heavily used ANTs pipelines, such as cortical
thickness estimation [@Tustison:2014ab], have been integrated into Docker
containers and packaged as Brain Imaging Data Structure (BIDS)
[@Gorgolewski:2016aa] and FlyWheel applications (i.e., ``gears''). It has also
been independently ported for various platforms including Neurodebian
[@Halchenko:2012aa] (Debian OS), Neuroconductor [@Muschelli:2019aa] (the R
statistical project), and Nipype [@Gorgolewski:2011aa] (Python).  Even competing
softwares, such as FreeSurfer [@Fischl:2012aa], have incorporated
well-performing and complementary ANTs components[@Tustison2009e;@Manjon:2010aa]
into their own libraries.

\input{papers_table}

\begin{figure}[htbp]
 \centering
 \includegraphics{Figures/coreANtsXNetTools.png}
 \caption{An illustration of the tools and applications available as part of the
 ANTsRNet and ANTsPyNet deep learning toolkits.  Both libraries are able to take
 advantage of ANTs functionality through their respective language
 interfaces---ANTsR (R) and ANTsPy (Python).  Building on the Keras language, both
 libraries standardize popular network architectures within the ANTs ecosystem
 and are cross-compatible.  These networks are used to train models and weights
 for such applications as brain extraction which are then disseminated to the
 public.}
\label{fig:antsXnetTools}
\end{figure}

Over the course of its development, ANTs has been extended to complementary
frameworks resulting in the the Python-based ANTsPy toolkit and the R-based
ANTsR toolkit. These ANTs-based interfaces with extremely popular, high-level,
open-source programming platforms have significantly increased the user base of
ANTs and facilitated research workflows which were not previously possible. In
addition, the rapidly rising popularity of deep learning motivated further
recent enhancement of ANTs and its extensions.  Although there exists an
abundance of online innovation and code for deep learning algorithms, much of it
is disorganized and lacks a uniformity in code structure and external data
interfaces which would facilitate large-scale adoption. With this in mind, ANTsR
spawned the deep learning ANTsRNet package which is a growing Keras-based
library of popular deep learning architectures and applications specifically
geared towards medical imaging. Analogously, ANTsPyNet is a deep learning
complement to ANTsPy.  Both, which we collectively refer to as "ANTsXNet", are
co-developed so as to ensure cross-compatibility such that training performed in
one can library is readily accessible by the other library.  In addition to a
variety of popular network architectures, ANTsXNet contains a host of
functionality for medical image analysis that have been developed in-house and
collected from other open-source projects.  For an extremely popular ANTsXNet
application is a multi-modal brain extraction tool that uses different variants
of the popular U-net [@Falk:2019aa] architecture.  Applicable modalities include
modalities include conventional T1-weighted structural MRI as well as
T2-weighted MRI, fractional anisotropy and BOLD.  Demographic specialization
also includes infant T1-weighted and/or T2-weighted MRI.  Additionally, we have
included other models and weights into our libraries such as HippMapp3r
[@Goubran:2020aa], a hippocampal segmentation tool; the winning entry of the
MICCAI 2017 white matter hyperintensity segmentation competition [@Li:2018aa];
and NoBrainer, a T1-weighted brain extraction approach based on FreeSurfer. (see
Figure \ref{fig:antsXnetTools}).

Our most recent developmental work involves recreating our popular ANTs cortical
thickness pipeline [@Tustison:2014ab;@Tustison:2019aa] within the ANTsXNet
framework for, amongst other potential benefits, increased computational
efficiency.  This structural processing functionality is currently available as
open-source within the ANTsXNet libraries and underwent a thorough evaluation
using both cross-sectional and longitudinal data and discussed within the
context of our previous findings concerning the traditional pipelines
[@Tustison:2014ab;@Tustison:2019aa].  Note that related work has been recently
reported by external groups [@Rebsamen:2020aa;@Henschel:2020aa]. Fortunately,
these overlapping contributions provide a context for comparison to
simultaneously motivate the utility of the ANTsX ecosystem and to editorialize
with respect to best practices in this field.


