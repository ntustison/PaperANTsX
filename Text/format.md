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
    includes:
      after_body: authorContributions.md
    word_document:
      fig_caption: true
bibliography:
  - references.bib
csl: nature.csl
longtable: true
urlcolor: blue
header-includes:
  - \usepackage[left]{lineno}
  - \linenumbers
  - \usepackage{longtable}
  - \usepackage{graphicx}
  - \usepackage{booktabs}
  - \usepackage{listings}
  - \usepackage{textcomp}
  - \usepackage{xcolor}
  - \usepackage{multirow}
  - \usepackage{subcaption}
  - \definecolor{listcomment}{rgb}{0.0,0.5,0.0}
  - \definecolor{listkeyword}{rgb}{0.0,0.0,0.5}
  - \definecolor{listnumbers}{gray}{0.65}
  - \definecolor{listlightgray}{gray}{0.955}
  - \definecolor{listwhite}{gray}{1.0}
geometry: margin=1.0in
fontsize: 12pt
linestretch: 1.5
mainfont: Georgia
---

