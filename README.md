# ANTsXNet cortical thickness

But if you wait around awhile, I promise you

------------

## ANTsPy/ANTsPyNet

```
import ants 
import antspynet

# ANTsPy/ANTsPyNet processing for subject IXI002-Guys-0828-T1

t1_file = "IXI002-Guys-0828-T1.nii.gz" 
t1 = ants.image_read(t1_file)

# Atropos six-tissue segmentation

atropos = antspynet.deep_atropos(t1, do_preprocessing=True, verbose=True)

# Kelly Kapowski cortical thickness

kk_segmentation = atropos['segmentation_image']
kk_segmentation = kk_segmentation[kk_segmentation == 4] = 3
gray_matter = atropos['probability_images'][2] 
white_matter = (atropos['probability_images'][3] + atropos['probability_images'][4]) 
kk = ants.kelly_kapowski(s=kk_segmentation, g=gray_matter, w=white_matter, 
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
```

## ANTsR/ANTsRNet

```
library( ANTsR )
library( ANTsRNet )

# ANTsR/ANTsRNet processing for subject IXI002-Guys-0828-T1

t1File <- "IXI002-Guys-0828-T1.nii.gz" 
t1 <- antsImageRead( t1File )

# Atropos six-tissue segmentation

atropos <- deepAtropos( t1, doPreprocessing = TRUE, verbose = TRUE )

# Kelly Kapowski cortical thickness

kkSegmentation <- atropos$segmentationImage
kkSegmentation <- kkSegmentation[kkSegmentation == 4] <- 3
grayMatter <- atropos$probabilityImages[[3]] 
whiteMatter <- atropos$probabilityImages[[4]] + atropos$probabilityImages[[5]]
kk <- kellyKapowski( s = kkSegmentation, g = grayMatter, w = whiteMatter, 
                     its = 45, r = 0.025, m = 1.5, x = 0, verbose = TRUE )

# Desikan-Killiany-Tourville labeling

dkt <- desikanKillianyTourvilleLabeling( t1, doPreprocessing = TRUE, verbose = TRUE )

# DKT label propagation throughout the cortex

dktCorticalMask <- thresholdImage( dkt, 1000, 3000, 1, 0 ) 
dkt <- dktCorticalMask * dkt 
kkMask <- thresholdImage( kk, 0, 0, 0, 1 ) 
dktPropagated <- iMath( kkMask, "PropagateLabelsThroughMask", kkMask * dkt )

# Get average regional thickness values

kkRegionalStats <- labelStats( kk, dktPropagated ) 
```


