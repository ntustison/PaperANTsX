
# Results {-}

The original ANTs cortical thickness pipeline [@Tustison:2014ab] consists of the
following steps:

* preprocessing: denoising [@Manjon:2010aa] and bias correction [@Tustison:2010ac];
* brain extraction [@Avants:2010ab];
* brain segmentation [@Avants:2011aa] comprising the
    * cerebrospinal fluid (CSF),
    * gray matter (GM),
    * white matter (WM),
    * deep gray matter,
    * cerebellum, and
    * brain stem; and
* cortical thickness estimation [@Das:2009aa].

Our recent longitudinal variant incorporates an additional step involving the
construction of a single subject template [@Avants:2010aa] followed by normal
processing.

Although the resulting thickness maps are conducive to voxel-based
[@Ashburner:2000aa] and related analyses[@Avants:2012aa], here we employ the
well-known Desikan-Killiany-Tourville (DKT) [@Klein:2012aa] labeling protocol (31
labels per hemisphere) to parcellate the cortex for averaging thickness values
regionally. This allows us to 1) be consistent in our evaluation strategy for
comparison with our previous work [@Tustison:2014ab;@Tustison:2019aa] and 2)
leverage an additional deep learning-based substitution within the proposed
pipeline.

Note that the entire analysis/evaluation framework, from preprocessing to
statistical analysis, is made possible through the ANTsX ecosystem and simplified
through the open-source R and Python platforms.  Preprocessing, image registration,
and cortical thickness estimation are all available through the ANTsPy and ANTsR
libraries whereas the deep learning steps are made possible through networks
constructed and trained via ANTsRNet/ANTsPyNet with data augmentation strategies
and other utilities built from ANTsR/ANTsPy functionality.

The brain extraction, brain segmentation, and DKT parcellation deep learning components were
trained using data derived from our previous work [@Tustison:2014ab].
Specifically, the IXI[^1] , MMRR [@Landman:2011aa], NKI[^2], and OASIS[^3] data
sets, and the corresponding derived data, comprising over 1200 subjects from age
4 to 94, were used for all network training. Brain extraction employs a traditional 3-D
U-net network [@Falk:2019aa] with whole brain, template-based data augmentation
[@Tustison:2019ac] whereas brain segmentation and DKT parcellation are processed
via 3-D U-net networks with attention gating [@Schlemper:2019aa] on image octant-based
batches.  We emphasize that a single model was created for each of these steps
and was used for all the experiments described below.

[^1]: https://brain-development.org/ixi-dataset/
[^2]: http://fcon_1000.projects.nitrc.org/indi/pro/nki.html
[^3]: https://www.oasis-brains.org

## Cross-sectional cortical thickness {-}

\begin{figure}[htb]
  \centering
    \includegraphics[width=\textwidth]{Figures/rmseThicknessPerSite.pdf}
  \caption{Distribution of mean RMSE values (500 permutations) for age
          prediction across the different data sets between
          the traditional ANTs and deep learning-based ANTsXNet pipelines. Total
          mean values are as follows: Combined---9.3 years (ANTs) and 8.2 years
          (ANTsXNet); IXI---7.9 years (ANTs) and 8.6 years (ANTsXNet);
          MMRR---7.9 years (ANTs) and 7.6 years (ANTsXNet); NKI---8.7 years
          (ANTs) and 7.9 years (ANTsXNet); OASIS---9.2 years (ANTs) and 8.0
          years (ANTsXNet); and SRPB---9.2 years (ANTs) and 8.1 years
          (ANTsXNet).}
  \label{fig:agePrediction}
\end{figure}

Due to the absence of ground-truth, we utilize the evaluation strategy from our
previous work [@Tustison:2014ab] where we used cross-validation to build and
compare age prediction models from data derived from both the proposed ANTsXNet
pipeline and the established ANTs pipeline.  Specifically, we use "age" as a well-known and
widely-available demographic correlate of cortical thickness [@Lemaitre:2012aa]
and quantify the predictive capabilities of corresponding random forest classifier
[@Breiman:2001aa] of the form:
\begin{equation}
AGE \sim VOLUME + GENDER + \sum_{i=1}^{62} T(DKT_i)
\end{equation}
with covariates $GENDER$ and $VOLUME$ (i.e., total intracranial volume). [^5]
$T(DKT_i)$ is the average thickness value in the $i^{th}$ DKT region.  Root mean
square error (RMSE) between the actual and predicted ages are the quantity used
for comparative evaluation.  As we have explained previously [@Tustison:2014ab], we find these
evaluation measures to be much more useful than some other commonly applied
criteria as they are closer to assessing the actual utility of these thickness
measurements as actual biomarkers for disease[@holbrook2020anterolateral] or growth.  For example, in recent work
[@Rebsamen:2020aa] the authors employ correlation with FreeSurfer thickness values
as the primary evaluation for assessing relative performance with ANTs cortical
thickness [@Tustison:2014ab].  Aside from the fact that this is a
prime example of flawed [^6] circularity analysis [@Kriegeskorte:2009aa], such
an evaluation does not indicate relative utility as a biomarker.

[^5]:  We used the randomForest package in R with the default hyperparameter values.

[^6]:  Here, data selection is driven by the same criteria used to evaluate
performance.  Specifically, DeepSCAN network training utilizes FreeSurfer brain
segmentation results.  Thickness is highly correlated with segmentation which
varies characteristically between relevant software packages. Relative
performance with ANTs thickness (which does not use FreeSurfer for training) is
then assessed by determining correlations with FreeSurfer thickness values.
Almost as problematic is their use of repeatability (which they confusingly
label as "robustness") as an additional ranking criterion.  Repeatability
evaluations should be contextualized within considerations such as the
bias-variance tradeoff and quantified using relevant metrics, such as the intra-class
correlation coefficient which takes into account both inter- and intra-observer
variability.

In addition to the training data listed above, to ensure generalizability, we
also compared performance using the SRPB data set[^4] comprising over 1600
participants from 12 sites.  Note that we recognize that we are processing data
through the proposed deep learning-based pipeline that were used to train
certain components of this pipeline.  Although this does not provide evidence
for generalizability (which is why we include the much larger SRPB data set),
it is still interesting to examine the results since, in this case, the deep
learning training can be considered a type of noise reduction on the final
model.  It should be noted that training did not use age prediction (or any other
evaluation or related measure) as a criterion to be optimized during network model
training (i.e., circular analysis [@Kriegeskorte:2009aa]).

[^4]: https://bicr-resource.atr.jp/srpbs1600/

The results are shown in Figure \ref{fig:agePrediction} where we used
cross-validation with 500 permutations per model per data set (including a
"combined" set) and an 80/20 training/testing split. The ANTsXNet deep learning
pipeline outperformed the classical pipeline [@Tustison:2014ab] in terms of age
prediction in all data sets except for IXI.  This also includes the
cross-validation iteration where all data sets were combined. Importance plots
ranking the cortical thickness regions and the other covariates of Equation (1)
are shown in Figure \ref{fig:rfimportance}. Rankings employ
"MeanDecreaseAccuracy" which quantifies the decrease in model accuracy based on
the exclusion of that variable. Additionally, repeatability assessment on the
MMRR data set yielded  using ICC valuence s ("average random rater") of 0.99 for
both pipelines.

\begin{figure}[htb]
  \centering
  \begin{subfigure}{0.4\textwidth}
    \centering
    \includegraphics[width=0.7\linewidth]{Figures/rfImportance_SRPB1600_ANTs.pdf}
    \caption{ANTs}
  \end{subfigure}%
  \begin{subfigure}{0.4\textwidth}
    \centering
    \includegraphics[width=0.7\linewidth]{Figures/rfImportance_SRPB1600_ANTsXNet.pdf}
    \caption{ANTsXNet}
  \end{subfigure}
\caption{Importance plots for the SRPB data set using ``MeanDecreaseAccuracy'' for the
random forest regressors (i.e., cortical thickness regions, gender, and brain volume
specified by Equation (1).}
\label{fig:rfimportance}
\end{figure}


## Longitudinal cortical thickness {-}

\begin{figure}[!htb]
  \centering
  \begin{subfigure}{0.95\textwidth}
    \centering
    \includegraphics[width=1.0\linewidth]{Figures/logPvalues.pdf}
    \caption{}
  \end{subfigure}
  \begin{subfigure}{0.95\textwidth}
    \centering
    \includegraphics[width=1\linewidth]{Figures/allData_FINALX.png}
    \caption{}
  \end{subfigure}
\caption{Measures for the both the supervised and unsupervised evaluation
strategies, respectively given in (a) and (b).  (a) Log p-values for diagnostic
differentiation of LMCI-CN, AD-LMCI, and AD-CN subjects for all pipelines
over all DKT regions.  (b) Residual variability, between subject, and variance ratio
values per pipeline over all DKT regions. }
\label{fig:longeval}
\end{figure}

Given the excellent performance and superior computational efficiency of the
proposed ANTsXNet pipeline for cross-sectional data, we evaluated its
performance on longitudinal data using the longitudinally-specific evaluation
strategy and data we employed with the introduction of the longitudinal version
of the ANTs cortical thickness pipeline [@Tustison:2019aa].  It should be
emphasized that, in contrast to the longitudinal version, the ANTsXNet pipeline
is not specifically tailored for longitudinal data, so we regard any positive
performance in this domain as a plus that motivates the development of future
longitudinal extensions.  The ADNI-1 data used for our previous evaluation
[@Tustison:2019aa] consisted of over 600 subjects (197 cognitive normals, 324
LMCI subjects, and 142 AD subjects) with one or more follow-up image acquisition
sessions every 6 months (up to 36 months) for a total of over 2500 images. In
addition to the ANTsXNet pipeline for the current evaluation, our previous work
included the FreeSurfer [@Fischl:2012aa] cross-sectional (FSCross) and
longitudinal (FSLong) streams, the ANTs cross-sectional pipeline (ANTsCross) in
addition to two longitudinal ANTs-based variants (ANTsNative and ANTsSST). Two
evaluation measurements, one unsupervised and one supervised, were used to
assess comparative performance between all five pipelines.  We add the results
of the ANTsXNet pipeline evaluation in relation to these other pipelines to
provide a comprehensive overview of relative performance.

The first, supervised evaluation employed Tukey post-hoc analyses with false
discovery rate (FDR) adjustment to test the significance of the
LMCI-CN, AD-LMCI, and AD-CN diagnostic contrasts.  This is provided by the
following LME model
\begin{align}
  \Delta Y \sim & Y_{bl} + AGE_{bl} + ICV_{bl} + APOE_{bl} + GENDER + DIAGNOSIS_{bl} \\ \nonumber
                & + VISIT:DIAGNOSIS_{bl} + (1 | ID) + (1 | SITE).
\end{align}
Here, $\Delta Y$ is the change in thickness of the $k^{th}$ DKT region from
baseline (bl) thickness $Y_{bl}$ with random intercepts for both the individual
subject ($ID$) and the acquisition site. The subject-specific covariates $AGE$, $APOE$
status, $GENDER$, $DIAGNOSIS$, and $VISIT$ were taken directly from the
ADNIMERGE package.

Second, linear mixed-effects (LME) [@verbeke1997linear] modeling was used to quantify
between-subject and residual variabilities, the ratio of which provides an
estimate of the effectiveness of a given biomarker for distinguishing between
subpopulations. In order to assess this criteria while accounting for changes
that may occur through the passage of time, we used the following Bayesian LME
model:
\begin{gather}
  Y^k_{ij} \sim N(\alpha^k_i + \beta^k_i t, \sigma_k^2) \\ \nonumber
  \alpha^k_i \sim N(\alpha^k_0, \tau^2_k) \,\,\,\, \beta^k_i \sim N(\beta^k_0, \rho^2_k) \\ \nonumber
  \alpha^k_0, \beta^k_0 \sim N(0,10) \,\,\,\,  \sigma_k, \tau_k, \rho_k \sim \mbox{Cauchy}^+ (0, 5)
\end{gather}
where $Y^k_{ij}$ denotes the $i^{th}$ individual's cortical thickness
measurement corresponding to the $k^{th}$ region of interest at the time point
indexed by $j$ and specification of variance priors to half-Cauchy distributions
reflects commonly accepted best practice in the context of hierarchical models
[@gelman2006prior].  The ratio of interest, $r^k$, per region
of the residual variability, $\tau_k$, and between-subject variability, $\sigma_k$
is
\begin{align}
  r^k = \frac{\tau_k}{\sigma_k}, k = 1,\ldots,62
\end{align}
where the posterior distribution of $r_k$ was summarized via the posterior
median.


Results for both longitudinal evaluation scenarios are shown in Figure
\ref{fig:longeval}. Log p-values are provided in Figure \ref{fig:longeval}(a)
which demonstrate excellent LMCI-CN and AD-CN differentiation and comparable
AD-LMCI diffierentiation relative to the other pipelines.
Despite these strong results, Figure \ref{fig:longeval}(b) shows that even
better performance may be possible for a longitudinal extension to ANTsXNet. In
a longitudinal setting, we prefer to see lower values for residual variability
and higher values for within-subject variability, leading to a larger variance
ratio.  ANTsXNet performs remarkably poorly for these measures, suggesting that
even better classification performance---e.g., superior differentiation between
LMCI and AD cohorts---is completely possible for an ANTsXNet extension that
leverages the longitudinal information the current implementation does not. One
such piece of information is repeated measures, i.e., the fact that we observe
some subjects multiple times. Failure to account for this information explains
lower between-subject variabilities for ANTsXNet. In turn, all variability
expresses itself through higher within-subject residuals. But there is an
additional reason for ANTsXNet exhibiting higher residual variability. Neural
networks achieve their power by increasing their effective degrees of freedom
way beyond those of traditional linear models. In terms of the bias-variance
tradeoff, such an increase in model complexity translates to significantly less
predictive bias while simultaneously leading to greater predictive variance.
This fact explains how ANTsXNet can perform so well while retaining such a large
residual variability.  An interesting question is how longitudinal extensions to
ANTsXNet will perform with respect to the same measure.
