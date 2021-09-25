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
bibliography:
  - references.bib
fontsize: 12pt
linestretch: 1.5
mainfont: Georgia
---


## Image analysis {-}

Image processing leveraged the open-source ANTsX software ecosystem
[@Tustison:2021vi] with a particular focus on specific deep learning
applications developed for neuroimaging made available for both Python and R
users via the ANTsXNet (ANTsPyNet/ANTsRNet) libraries. Specifically, for the work
described here, white matter hyperintensity segmentation and lobar parcellation
based on the Desikan-Killiany-Tourville (DKT) cortical labels [@Klein:2012aa] employed
the ANTsPyNet functions:

* ``sysu_white_matter_hypterintensity_segmentation`` and
* ``desikan_killiany_tourville_labeling``,

respectively.  Note that in addition to the netework architectures being
specified by the ANTsXNet functions, data (including both weights and ancillary
image data, such as templates) are also available and automatically downloaded
from https://figshare.com to a specified cache directory and stored for
subsequent use.

__White matter hyperintensity segmentation.__  In conjunction with the
International Conference on Medical Image Computing and Computer Assisted
Intervention (MICCAI) held in 2017, a challenge was held for the automatic
segmentation of white matter hyperintensities using T1-weighted and FLAIR images
[@Kuijf:2019aa].  Image data from five separate collection sites were used for
training and testing of algorithms from 20 different teams.  The winning entry
used a simplified preprocessing scheme (e.g., simple thresholding for brain
extraction) and an ensemble ($n=3$) of randomly initialized 2-D U-nets
[@Falk:2019aa] to produce the probabilistic output [@Li:2018aa].  Importantly,
they made both the architecture and weights available to the public.  This
permitted a direct porting to the ANTsXNet libraries with the only difference
being the substitution of the threshold-based brain extraction with a
deep-learning approach [@Tustison:2021vi].

__Lobar parcellation.__  An automated, deep learning-based DKT labeling protocol
for T1-weighted images was briefly described in [@Tustison:2021vi] where it was
used to provide regional summary measures for the ANTsXNet cortical thickness
pipeline.  Data from multiple sites described in [@Tustison:2014ab] was used to
train two networks---one for the "inner" (e.g., subcortical, cerebellar) labels
and one for the "outer" cortical labels.  Training was performed using ANTsRNet
with trained weights being cross-compatible with ANTsPyNet as they are both
Keras- based.  Inputs include the T1-weighted image and spatial priors for each
label being included as additional channels to enforce spatial constraints on
the output. For both training and prediction, input T1-weighted images are
skull-stripped [@Tustison:2021vi] and transformed to the space of a cropped
version of the MNI152 template [@Fonov:2009aa] (also the space of the spatial
priors described above). Both networks use the U-net architecture with attention
gating [@Schlemper:2019aa]. Inner and outer networks are characterized by 8 and
16 filters at the base layer doubling at each subsequent layer for four total
layers.

After an individual T1-weighted is labeled with the cortical DKT regions, the
six-tissue (i.e., CSF, gray matter, white matter, deep gray matter, cerebellum,
and brain stem) segmentation network is applied to the skull stripped image.
Cortical labels corresponding to the same hemispherical lobes are combined and
then propagated through the non-CSF brain tissue, using a fast marching
approach [@Sethian:1996vr], to produce left/right parcellations of the frontal, temporal,
parietal, and occipital lobes, as well as left/right divisions of the brain stem
and cerebellum.

\newpage

## References {-}