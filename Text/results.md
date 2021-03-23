
# Results {-}


## Cross-sectional performance evaluation {-}

\input{dktRegions}


Due to the absence of ground-truth, we utilize the evaluation strategy from our
previous work [@Tustison:2014ab] where we used cross-validation to build and
compare age prediction models from data derived from both the proposed ANTsXNet
pipeline and the established ANTs pipeline.  Specifically, we use "age" as a
well-known and widely-available demographic correlate of cortical thickness
[@Lemaitre:2012aa] and quantify the predictive capabilities of corresponding
random forest classifiers [@Breiman:2001aa] of the form:

\begin{equation}
AGE \sim VOLUME + GENDER + \sum_{i=1}^{62} T(DKT_i)
\end{equation}

with covariates
$GENDER$ and $VOLUME$ (i.e., total intracranial volume). $T(DKT_i)$ is the
average thickness value in the $i^{th}$ Desikian-Killiany-Tourville (DKT) region
[@Klein:2012aa] (cf Table \ref{table:dkt_labels}).  Root mean square error
(RMSE) between the actual and predicted ages are the quantity used for
comparative evaluation.  As we have explained previously [@Tustison:2014ab], we
find these evaluation measures to be much more useful than other commonly
applied criteria as they are closer to assessing the actual utility of these
thickness measurements as biomarkers for
disease [@holbrook2020anterolateral] or growth.  In recent work
[@Rebsamen:2020aa] the authors employ correlation with FreeSurfer thickness
values as the primary evaluation for assessing relative performance with ANTs
cortical thickness [@Tustison:2014ab].  This evaluation, unfortunately, is
fundamentally flawed in that it is a prime example of a type of circularity
analysis [@Kriegeskorte:2009aa] whereby data selection is driven by the same
criteria used to evaluate performance.  Specifically, the underlying DeepSCAN
network used for the tissue segmentation step employs training based on
FreeSurfer results which directly influences thickness values as
thickness/segmentation are highly correlated and vary characteristically between
software packages. Relative performance with ANTs thickness (which does not use
FreeSurfer for training) is then assessed by determining correlations with
FreeSurfer thickness values.  Almost as problematic is their use of
repeatability, which they confusingly label as "robustness," as an additional
ranking criterion. Repeatability evaluations should be contextualized within
considerations such as the bias-variance tradeoff and quantified using relevant
metrics, such as the intra-class correlation coefficient which takes into
account both inter- and intra-observer variability.

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

In addition to the training data listed above, to ensure generalizability, we
also compared performance using the SRPB data set [@srpb] comprising over 1600
participants from 12 sites.  Note that we recognize that we are processing a
portion of the evaluation data through certain components of the proposed deep
learning-based pipeline that were used to train the same pipeline components.
Although this does not provide evidence for generalizability (which is why we
include the much larger SRPB data set), it is still interesting to examine the
results since, in this case, the deep learning training can be considered a type
of noise reduction on the final results.  It should be noted that training did not
use age prediction (or any other evaluation or related measure) as a criterion
to be optimized during network model training (i.e., circular analysis
[@Kriegeskorte:2009aa]).

The results are shown in Figure \ref{fig:agePrediction} where we used
cross-validation with 500 permutations per model per data set (including a
"combined" set) and an 80/20 training/testing split. The ANTsXNet deep learning
pipeline outperformed the classical pipeline [@Tustison:2014ab] in terms of age
prediction in all data sets except for IXI.  This also includes the
cross-validation iteration where all data sets were combined.  Additionally,
repeatability assessment on \textcolor{black}{the regional cortical thickness
values of the} MMRR data set yielded ICC values ("average random rater") of 0.99
for both pipelines.

\textcolor{black}{
A comparative illustration of regional thickness measurements between the ANTs
and ANTsXNet pipelines is provided in Figure \ref{fig:radar} for three different
ages spanning the lifespan.  Linear models of the form}

\begin{equation}
  T(DKT_i) \sim GENDER + AGE
\end{equation}

\textcolor{black}{
were created for each of the 62 DKT regions for each pipeline.  These models were
then used to predict thickness values for each gender at ages of 25 years, 50 years,
and 75 years and subsequently plotted relative to the absolute maximum predicted
thickness value (ANTs:  right entorhinal cortex at 25 years, male).  Although
there appear to be systematic differences between specific regional predicted
thickness values (e.g., $T(ENT)_{ANTs} > T(ENT)_{ANTsXNet}$,
$T(pORB)_{ANTs} < T(pORB)_{ANTsXNet}$)), a pairwise t-test evidenced no statistically
significant difference between the predicted thickness values of the two pipelines.}

\begin{figure}[htb]
  \centering
    \includegraphics[width=0.9\textwidth]{Figures/radarSPRB.pdf}
  \caption{\textcolor{black}{Radar plots enabling comparison of relative thickness values between
  the ANTs and ANTsXNet cortical thickness pipelines at three different ages
  sampling the life span.  See Table \ref{table:dkt_labels} for region abbreviations. }}
  \label{fig:radar}
\end{figure}


<!-- Importance plots
ranking the cortical thickness regions and the other covariates of Equation (1)
are shown in Figure \ref{fig:radar}. Rankings employ
"MeanDecreaseAccuracy" which quantifies the decrease in model accuracy based on
the exclusion of a specific random forest regressor.  -->

<!--
\begin{figure}[htb]
  \centering
  \begin{subfigure}{0.4\textwidth}
    \centering
    \includegraphics[width=0.75\linewidth]{Figures/rfImportance_SRPB1600_ANTs.pdf}
    \caption{ANTs}
  \end{subfigure}%
  \begin{subfigure}{0.4\textwidth}
    \centering
    \includegraphics[width=0.75\linewidth]{Figures/rfImportance_SRPB1600_ANTsXNet.pdf}
    \caption{ANTsXNet}
  \end{subfigure}
\caption{Importance plots for the SRPB data set using ``MeanDecreaseAccuracy'' for the
random forest regressors (i.e., cortical thickness regions, gender, and brain volume
specified by Equation (1).}
\label{fig:rfimportance}
\end{figure}
-->


## Longitudinal performance evaluation {-}

\begin{figure}[!htb]
  \centering
  \begin{subfigure}{0.95\textwidth}
    \centering
    \includegraphics[width=1.0\linewidth]{Figures/variance.ratio_FINALX.png}
    \caption{}
  \end{subfigure}
  \begin{subfigure}{0.95\textwidth}
    \centering
    \includegraphics[width=1\linewidth]{Figures/allData_FINALX2.png}
    \caption{}
  \end{subfigure}
  \caption{Performance over longitudinal data as determined by the variance ratio.
    (a) Region-specific 95\% confidence intervals of the variance ratio showing the
    superior performance of the longitudinally tailored ANTsX-based pipelines, including
    ANTsSST and ANTsXNetLong. (b) Residual variability, between subject, and variance ratio
    values per pipeline over all DKT regions. }
\label{fig:longeval1}
\end{figure}

\begin{figure}[!htb]
  \centering
    \includegraphics[width=1.0\linewidth]{Figures/logPvalues2.pdf}
  \caption{Measures for the supervised evaluation
  strategy where log p-values for diagnostic
  differentiation of LMCI-CN, AD-LMCI, and AD-CN subjects are plotted for all pipelines
  over all DKT regions. }
  \label{fig:longeval2}
\end{figure}

Given the excellent performance and superior computational efficiency of the
proposed ANTsXNet pipeline for cross-sectional data, we evaluated its
performance on longitudinal data using the longitudinally-specific evaluation
strategy and data we employed with the introduction of the longitudinal version
of the ANTs cortical thickness pipeline [@Tustison:2019aa].  \textcolor{black}{
We also evaluated an ANTsXNet-based pipeline tailored specifically for longitudinal
data.  In this variant, an SST is generated and processed using the previously
described ANTsXNet cross-sectional pipeline which yields tissue spatial priors.
These spatial priors are used in our traditional brain segmentation approach}
[@Avants:2011aa]\textcolor{black}{.  The computational efficiency of this variant is also
significantly improved, in part, due to the elimination of the costly SST prior generation
which uses multiple registrations combined with joint label fusion} [@Wang:2013ab].

The ADNI-1 data used for our longitudinal performance evaluation
[@Tustison:2019aa] consists of over 600 subjects (197 cognitive normals, 324
LMCI subjects, and 142 AD subjects) with one or more follow-up image acquisition
sessions every 6 months (up to 36 months) for a total of over 2500 images. In
addition to the ANTsXNet pipelines \textcolor{black}{(``ANTsXNetCross'' and
``ANTsXNetLong'')} for the current evaluation, our previous work included the
FreeSurfer [@Fischl:2012aa] cross-sectional ("FSCross") and longitudinal
("FSLong") streams, the ANTs cross-sectional pipeline ("ANTsCross") in addition
to two longitudinal ANTs-based variants ("ANTsNative" and "ANTsSST"). Two
evaluation measurements, one unsupervised and one supervised, were used to
assess comparative performance between all seven pipelines.  We add the results
of the ANTsXNet pipeline \textcolor{black}{cross-sectional and longitudinal}
evaluations in relation to these other pipelines to provide a comprehensive
overview of relative performance.

First, \textcolor{black}{linear mixed-effects} (LME) [@verbeke1997linear] modeling was used to quantify
between-subject and residual variabilities, the ratio of which provides an
estimate of the effectiveness of a given biomarker for distinguishing between
subpopulations. In order to assess this criteria while accounting for changes
that may occur through the passage of time, we used the following Bayesian LME
model:
\begin{gather}
  Y^k_{ij} \sim N(\alpha^k_i + \beta^k_i t_{ij}, \sigma_k^2) \\ \nonumber
  \alpha^k_i \sim N(\alpha^k_0, \tau^2_k) \,\,\,\, \beta^k_i \sim N(\beta^k_0, \rho^2_k) \\ \nonumber
  \alpha^k_0, \beta^k_0 \sim N(0,10) \,\,\,\,  \sigma_k, \tau_k, \rho_k \sim \mbox{Cauchy}^+ (0, 5)
\end{gather}
where $Y^k_{ij}$ denotes the $i^{th}$ individual's cortical thickness
measurement corresponding to the $k^{th}$ region of interest at the time point
indexed by $j$ and specification of variance priors to half-Cauchy distributions
reflects commonly accepted best practice in the context of hierarchical models
[@gelman2006prior].  The ratio of interest, $r^k$, per region
of the between-subject variability, $\tau_k$, and residual variability, $\sigma_k$
is
\begin{align}
  r^k = \frac{\tau_k}{\sigma_k}, k = 1,\ldots,62
\end{align}
where the posterior distribution of $r_k$ was summarized via the posterior
median.

Second, the supervised evaluation employed Tukey post-hoc analyses with false
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
status, $GENDER$, $DIAGNOSIS$, $ICV$, and $VISIT$ were taken directly from the
ADNIMERGE package.


\textcolor{black}{Results for all pipelines with respect to the longitudinal
evaluation criteria are shown in Figures \ref{fig:longeval1} and
\ref{fig:longeval2}.  Figure \ref{fig:longeval1}(a) provides the 95\% confidence
intervals of the variance ratio for all 62 regions of the DKT cortical labeling
where ANTsSST consistently performs best with ANTsXNetLong also performing
well.  These quantities are summarized in Figure \ref{fig:longeval1}(b).  The
second evaluation criteria compares diagnostic differentiation via LMEs.  Log
p-values are provided in Figure \ref{fig:longeval2} which demonstrate excellent
LMCI-CN and AD-CN differentiation for both deep learning pipelines.}

<!-- , suggesting that
better classification performance---e.g., superior differentiation between
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
ANTsXNet will perform with respect to the same measure. -->
