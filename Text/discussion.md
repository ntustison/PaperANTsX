


# Discussion {-}

The ANTsX software ecosystem provides a comprehensive framework for quantitative
biological and medical imaging.  Although ANTs, the original core of ANTsX, is
still at the forefront of image registration technology, it has moved
signicantly beyond its image registration origins.  This expansion is not
confined to technical contributions (of which there are many) but also consists
of facilitating access to a wide range of users who can use ANTsX tools (whether
through bash scripting, Python scripting or R scripting) to construct tailored
pipelines for their own studies or to take advantage of our pre-fabricated
pipelines.  And given the open-source nature of the ANTsX software, usage is not
limited, for example, to academic institutions---a common constraint
characteristic of other packages.

One of our most widely used pipelines is the estimation of cortical thickness
from neuroimaging. This is understandable given the widespread usage of regional
cortical thickness as a biomarker for developmental or pathological trajectories
of the brain.  In this work, we used this well-vetted ANTs tool to provide training data
for producing an alternative version which leverages deep learning for improved
computational efficiency and also provides superior performance with respect to
previously proposed evaluation measures for both cross-sectional [@Tustison:2014ab]
and longitudinal scenarios [@Tustison:2019aa].  In addition to providing the tools
which generated the original training data for the proposed ANTsXNet pipeline, the
ANTsX ecosystem provides a full-featured platform for the additional steps such as
preprocessing (ANTsR/ANTsPy); data augmentation (ANTsR/ANTsPy); network construction
and training (ANTsRNet/ANTsPyNet); and visualization and statistical
analysis of the results (ANTsR/ANTsPy).

It is the comprehensiveness of ANTsX that provides significant advantages over
much of the deep learning work that is currently taking place in medical imaging
and related fields.  For example, related work [@Rebsamen:2020aa] also built a
similar pipeline and assessed performance.  However, due to the lack of a
complete processing and analysis framework, training data was generated using
the FreeSurfer stream, deep learning-based brain segmentation employed DeepSCAN
[@deepscan] (in-house software), and cortical thickness estimation [@Das:2009aa]
used the ANTs toolkit.  For the reader interested in reproducing the authors'
results, they are primarily prevented from doing so due, as far as we can tell,
to the lack of the public availability of the only software they actually
produced themselves, i.e., DeepSCAN.  However, even further inhibiting usage is
the fact that the external utilities derive from different sources and so issues
such as interoperability are relevant.

In terms of future work, the recent surge and utility of deep learning in
medical image analysis has significantly guided the areas of active ANTsX
development.  As demonstrated in this work with our widely used cortical
thickness pipeline, there are many potential benefits of deep learning analogs
to existing ANTs tools as well as the development of new ones.  As mentioned,
the proposed cortical thickness pipeline is not specifically tailored for
longitudinal data.  Nevertheless, performance is comparable-to-superior relative
to existing pipelines depending on the evaluation metric.  We see possible
longitudinal extensions incorporating aspects of the single-subject template
construction, as described in [@Tustison:2019aa], in addition to the possibility
of incorporating subject ID and months as additional network inputs.



<!-- This is mimicked, in a sense, by training the brain segmentation
and cortical parcellation models in the affinely aligned MNI template space
[@Fonov:2009aa] (further discussion in the Methods section). -->

