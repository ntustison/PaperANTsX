# PaperANTsX
But if you wait around awhile, I promise you

------------

```
import ants 
import antspynet

# ANTsPy/ANTsPyNet processing for subject IXI002-Guys-0828-T1

t1_file = "IXI002-Guys-0828-T1.nii.gz" t1 = ants.image_read(t1_file)

# Atropos six-tissue segmentation

atropos = antspynet.deep_atropos(t1, do_preprocessing=True, verbose=True)

# Kelly Kapowski cortical thickness

gray_matter_probability = atropos['probability_images'][2] 
white_matter_probability = (atropos['probability_images'][3] + atropos['probability_images'][4]) 
kk = ants.kelly_kapowski(s=atropos['segmentation_image'], g=gray_matter_probability, w=white_matter_probability, its=45, r=0.025, m=1.5, x=0, verbose=1)

# Desikan-Killiany-Tourville labeling

dkt = antspynet.desikan_killiany_tourville_labeling(t1, do_preprocessing=True, verbose=True)

# DKT label propagation throughout the cortex

dkt_cortical_mask = ants.threshold_image(dkt, 1000, 3000, 1, 0) dkt = dkt_cortical_mask * dkt kk_mask = ants.threshold_image(kk, 0, 0, 0, 1) dkt_propagated = ants.iMath(kk_mask, "PropagateLabelsThroughMask", kk_mask * dkt)

# Get average regional thickness values

kk_regional_stats = ants.label_stats(kk, dkt_propagated) \end{lstlisting}
```
