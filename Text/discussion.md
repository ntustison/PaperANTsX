
# Discussion {-}


To be further expanded in the Discussion:

* Basic criticisms:

    * Not publicly available (no weights)

    * No discussion of network architecture

* What were the preprocessing choices?

* Why limit to gray matter and white matter?

* correlation isn't an ideal measurement for determining accuracy---see ICC paper.

* The authors use correlation with FreeSurfer measurements.  Why is this a suboptimal
evaluation criterion as compared with demographic (i.e., age) prediction?  Perhaps
dumbing down in terms of tissue segmentation and network parameters produced a lower-
complexity model that correlates well with FreeSurfer's suspected heavier use of priors.


<!-- One of the significant advantages of interfacing a deep learning library to ANTs
is the accessibility of certain tools used in deep learning design.  For
example, in [@Tustison:2019aa], we proposed employing ANTs template building
for biologically-constrained data augmentation.  Many deformable approaches to
image-based data augmentation use randomly generated displacement fields
whereas, with ANTs-based deep learning, we can constrain simulated data to
reside within the space of plausible shapes pertaining to a specific domain.  It
should be noted that all of these software libraries are organized under the
ANTsX ecosystem on GitHub which allows the developers to monitor current
software status and interact with the larger ANTs community. -->

<!--
\begin{figure}[htb]
  \centering
    \includegraphics[width=0.75\textwidth]{Figures/antsx.pdf}
  \caption{ANTsX ecosystem showing internal and external dependencies.}
  \label{fig:antsx}
\end{figure}
 -->

