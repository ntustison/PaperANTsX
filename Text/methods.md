
# Methods {-}

Software, average DKT regional thickness values for all data sets, and the
scripts to perform both the analysis and obtain thickness values for a single
subject are provided as open-source.  Specifically, all the ANTsX libraries are
hosted on GitHub (https://github.com/ANTsX).  The cross-sectional data and
analysis code are available as .csv files and R scripts at the GitHub repository
dedicated to this paper (https://github.com/ntustison/PaperANTsX) whereas the
longitudinal data and evaluation scripts are organized with the repository
associated with our previous work [@Tustison:2019aa]
(https://github.com/ntustison/CrossLong).

## ANTsXNet cortical thickness {-}

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
        for a single IXI subject in the evaluation study.
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

In Listing 1, we show the ANTsPy/ANTsPyNet code snippet for processing a single
subject which starts with reading the T1-weighted MRI input image, through the
generation of the Atropos-style six-tissue segmentation and probability images,
application of ``ants.kelly_kapowski`` (i.e., DiReCT), DKT cortical parcellation,
subsequent label propagation through the cortex, and, finally, regional cortical
thickness tabulation.  Computation time on a CPU-only platform is  ~1 hour
primarily due to the ``ants.kelly_kapowski`` function.  Note that there is a
precise, line-by-line R-based analog available through ANTsR/ANTsRNet.

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
the MNI template [@Fonov:2009aa].  We recognize the presence of some redundancy
due to the repeated application of certain preprocessing steps.  Thus, each
function has a ``do_preprocessing`` option to eliminate this redundancy for
knowledgeable users but, for simplicity in presentation purposes, we do not
provide this modified pipeline here. Although it should be noted that the time
difference is minimal considering the longer time required by
``ants.kelly_kapowski``. ``ants.deep_atropos`` returns the segmentation image as
well as the posterior probability maps for each tissue type listed previously.
``antspynet.desikan_killiany_tourville_labeling`` returns only the segmentation
label image which includes not only the 62 cortical labels but the remaining
labels as well.  The label numbers and corresponding structure names are given
in the program help.  Because the DKT parcellation will, in general, not exactly
coincide with the non-zero voxels of the resulting cortical thickness maps, we
perform a label propagation step to ensure the entire cortex, and only the
non-zero thickness values in the cortex, are included in the tabulated regional
values.

## Training {-}

Training differed slightly between models and so we provide details for each of
these components below.  For all training, we used ANTsRNet scripts and custom
batch generators.  Although the network construction and other functionality is
available in both ANTsPyNet and ANTsRNet (as is model weights compatibility), we
have not written such custom batch generators for the former (although this is
on our to-do list).  In terms of hardware, all training was done on a DGX (GPUs:
4X Tesla V100, system memory: 256 GB LRDIMM DDR4).

__T1-weighted brain extraction.__  A whole-image 3-D U-net model [@Falk:2019aa]
was used in conjunction with multiple training sessions employing a Dice loss
function followed by categorical cross entropy.  As mentioned previously, a
center-of-mass-based transformation to a standard template was used to
standardize such parameters as orientation and voxel size.  However, to account
for possible different header orientations of input data, a template-based data
augmentation scheme was used [@Tustison:2019ac] whereby forward and inverse
transforms are used to randomly warp batch images between members of the
training population (followed by reorientation to the standard template). A
digital random coin flipping for possible histogram matching [@Nyul:1999aa]
between source and target images further increased possible data augmentation.
Although not detailed here, training for brain extraction in other modalities
was performed similarly.

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
function.  As we point out in our earlier work [@Tustison:2014ab], obtaining
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
weights in the weighted categorical cross entropy.  Ultimately, we settled on a
weight vector of $(0.05, 1.5, 1, 3, 4, 3, 3)$ for the CSF, GM, WM, Deep GM,
brain stem, and cerebellum, respectively.  Other hyperparameters can be directly
inferred from explicit specification in the actual code.  As mentioned
previously, training data was derived from application of the ANTs Atropos
segmentation [@Avants:2011aa] during the course of our previous work
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