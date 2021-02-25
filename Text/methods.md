
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
emphasize that a single model (\textcolor{blue}{as opposed to ensemble
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
consisted of four encoding/decoding layers with eight filters at the base layer
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
function.  \textcolor{blue}{The architecture consisted of four encoding/decoding
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
