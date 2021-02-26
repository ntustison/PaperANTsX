


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

\textcolor{black}{It is the comprehensiveness of ANTsX that provides significant
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
The interested reader must also ensure the consistency of the input/output
interface between packages (a task for which the Nipype development team is
quite familiar.)}

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

