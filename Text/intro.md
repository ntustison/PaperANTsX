

ANTs is a state-of-the-art, open-source software toolkit for image registration,
segmentation, and other medical image analysis functionality. Historically, ANTs
is rooted in advanced image registration techniques which have been at the
forefront of the field characterized by seminal contributions that date back to
the original elastic matching method of Bajcsy and co-investigators
[@Bajcsy:1982aa;@Bajcsy:1989aa;@Gee:2003aa]. Our most recent work, embodied in
the ANTs cross-platform toolkit for multiple modality image processing,
continues to set the standard in the field for pulmonary [@Murphy:2011aa], brain
[@Klein:2009aa], and cardiac imaging [@Tustison:2015ab]. The ANTs registration
component not only encodes advanced developments in image registration research,
notably the Symmetric Normalization (SyN) algorithm for deformable diffeomorphic
mappings [@Avants:2008aa], but also packages these normalization tools within a
full-featured platform that includes an extensive library of similarity
measures, transformation types, and regularizers which are built upon the robust
Insight Toolkit and vetted by users and developers from all over the world
[@Avants:2014aa]. Since its inception, though, ANTs has expanded significantly
beyond its image registration origins.  We have contributed to other core
subfields with state-of-the-art algorithms and implementations, including
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
statistical project), and Nipype [@Gorgolewski:2011aa] (Python).  Even
competing softwares, such as FreeSurfer [@Fischl:2012aa], have
incorporated well-performing and complementary ANTs
components[@Tustison2009e;@Manjon:2010aa] into their own libraries.

\begin{table}
  \small
   \centering
   \vspace{-0.25cm}
   \begin{tabular*}{0.75\textwidth}{l @{\extracolsep{\fill}} c}
    \toprule
    {\bf Functionality} & {\bf Citations}\\
    \cmidrule[1pt](lr){1-2}
    SyN registration \cite{Avants:2008aa} & 2314        \\
    ANTs registration evaluation \cite{Avants:2011ab} & 1736  \\
    ITK integration \cite{Avants:2014aa} & 204           \\
    template generation \cite{Avants:2010aa} & 384      \\
    bias field correction \cite{Tustison:2010ac} & 1803  \\
    MAP-MRF segmentation \cite{Avants:2011aa} & 283     \\
    joint label fusion   \cite{Wang:2013ab} & 622       \\
    cortical thickness: theory \cite{Das:2009aa} & 156   \\
    cortical thickness: implementation \cite{Tustison:2014ab} & 262 \\
    \bottomrule
   \end{tabular*}
 \caption{The significance of core ANTs tools in terms of their number of citations (from April 27, 2020).}
 \label{table:papers}
\end{table}

The rapidly rising popularity of deep learning has motivated further recent
enhancement of ANTs and its extensions.  Although there exists an abundance of
online innovation and code for deep learning algorithms, much of it is
disorganized and lacks a uniformity in code structure and external data
interfaces which would facilitate large-scale adoption. With this in mind, ANTsR
spawned the deep learning ANTsRNet package which is a growing Keras-based
library\footnote{The motivation for choosing Keras as the foundation for the
ANTsXNet libraries was strictly practical.  Keras provides a simple yet powerful
on-ramp for developing identical functionality for both our R and Python-based
ANTs interfaces which allows one to easily share weights and model architectures
between the two libraries. However, we recognize the popularity of Pytorch and
plan to offer a Pytorch equivalent.} of popular deep learning architectures and
applications specifically geared towards medical imaging.

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

Analogously, ANTsPyNet is a deep learning complement to ANTsPy.  Both are
co-developed so as to ensure cross-compatibility such that training performed in
one can easily transfer to the other.  For example, an extremely popular
application is our multi-modal brain extraction tool that uses the popular U-net
[@Falk:2019aa] architecture.  Applicable modalities include conventional
T1-weighted structural MRI as well as T2-weighted MRI, fractional anisotropy and
BOLD.  Demographic specialization also includes infant T1-weighted and/or
T2-weighted MRI.  Additionally, we have included other models and weights into our
libraries such as HippMapp3r [@Goubran:2020aa], a hippocampal segmentation
tool; the winning entry of the MICCAI 2017 white matter hyperintensity
segmentation competition [@Li:2018aa]; and NoBrainer, a T1-weighted brain
extraction approach based on FreeSurfer.
(see Figure \ref{fig:antsXnetTools}).

One of the significant advantages of interfacing a deep learning library to ANTs
is the accessibility of certain tools used in deep learning design.  For
example, in [@Tustison:2019aa], we proposed employing ANTs template building
for biologically-constrained data augmentation.  Many deformable approaches to
image-based data augmentation use randomly generated displacement fields
whereas, with ANTs-based deep learning, we can constrain simulated data to
reside within the space of plausible shapes pertaining to a specific domain.  It
should be noted that all of these software libraries are organized under the
ANTsX ecosystem on GitHub which allows the developers to monitor current
software status and interact with the ANTs community.  This tight integration
with other ANTs components differentiates our deep learning offerings with
somewhat similar efforts such as the Medical Open Network for AI
(MONAI)\footnote{https://monai.io}.






By providing
essential medical image analysis functionality in an accessible and flexible
software package, ANTs is able to meet the real-world needs of thousands of
users in many areas of health-related research







Recently, while working on our deep learning-based cortical thickness pipeline
detailed in the Methods section, a conceptually similar framework was published
by an external group [@Rebsamen:2020aa].  Fortunately, this overlapping
contribution provides a context for comparison to simultaneously showcase the
utility of the ANTsX ecosystem and to editorialize with respect to best practices
in this field.

To be further expanded in the Discussion:

* Basic criticisms:

    * Not publicly available (no weights)

    * No discussion of network architecture

* What were the preprocessing choices?

* Why limit to gray matter and white matter?

* The authors use correlation with FreeSurfer measurements.  Why is this a suboptimal
evaluation criterion as compared with demographic (i.e., age) prediction?  Perhaps
dumbing down in terms of tissue segmentation and network parameters produced a lower-
complexity model that correlates well with FreeSurfer's suspected heavier use of priors.







\begin{figure}[htb]
  \centering
    \includegraphics[width=0.75\textwidth]{Figures/antsx.pdf}
  \caption{ANTsX ecosystem showing internal and external dependencies.}
  \label{fig:antsx}
\end{figure}


