---
title: "The Welfare Effects of Mobile Broadband Internet: Evidence from Nigeria"
output: github_document
---

# Overview

This repository contains the Stata codes required to replicate the analytical results presented in the paper ["The Welfare Effects of Mobile Broadband Internet: Evidence from Nigeria"](https://www.sciencedirect.com/science/article/pii/S0304387824000634) published in the Journal of Development Economics (JDE) in 2024.

## Replication Instructions

To replicate the results from the paper, follow these steps:

1. Ensure you have Stata installed on your computer.
2. Clone this repository to your local machine.
3. Set the Stata working directory to the cloned repository path.

Run the following Stata do-files in sequence:

1. **Nigeria_CSdid.do**: Performs all analysis done for the report.
    ```stata
    do "${code}/analysis/Nigeria_CSdid.do"
    ```

2. **Nigeria_CSdid_wgt.do**: Replicates the baseline analysis with survey weights.
    ```stata
    do "${code}/analysis/Nigeria_CSdid_wgt.do"
    ```

3. **Nigeria_CSdid_Dist.do**: Limits the analysis to the 6km-16km range.
    ```stata
    do "${code}/analysis/Nigeria_CSdid_Dist.do"
    ```

4. **GBdecomp.do**: Conducts the GB decomposition.
    ```stata
    do "${code}/analysis/GBdecomp.do"
    ```

5. **visualize_results.do**: Visualizes the heterogeneous effects.
    ```stata
    do "${code}/analysis/visualize_results.do"
    ```
