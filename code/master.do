********************************************************************************
/*Description: This master do file runs all the codes to replicate results for 
"The welfare effects of mobile broadband internet: Evidence from Nigeria" published 
at Journal of Development Economics (https://www.sciencedirect.com/science/article/pii/S0304387824000634).*/
*download various packages
*cap ssc install outreg2 
*cap ssc install geodist
*cap ssc install povdeco
*cap ssc install csdid
*cap ssc install drdid
local username "`c(username)'"

*Set your path
gl code "***"
gl path "***"

if "`c(username)'" == "wb495141" | "`c(username)'" == "WB495141" {
gl code "C:/Users/`c(username)'/GitHub/JDE_2024_Bahia_etal/code"
gl path "C:/Users/`c(username)'/OneDrive - WBG/poverty/DT/nigeria"
}

/*These codes replicate all the analytical results*/
do "${code}/analysis/Nigeria_CSdid.do" //all analysis done for the report
do "${code}/analysis/Nigeria_CSdid_wgt.do" //replicate the baseline analysis with survey weights
do "${code}/analysis/Nigeria_CSdid_Dist.do" //limit analysis to 6km-16km range
do "${code}/analysis/GBdecomp.do" //GB decomposition
do "${code}/analysis/visualize_results.do" //visualize heterogenous effects
**run tables.R to generate tables which can be read in LaTex
