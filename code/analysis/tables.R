pacman::p_load(xtable, haven, here, dplyr, tidyverse, tidyr, reshape2)
source(here::here("code","analysis","R","0-directory.R"))
source(here::here("code","analysis","R","main_tables.R"))
source(here::here("code","analysis","R","subgroup_tables.R"))
source(here::here("code","analysis","R","gb_table.R"))
source(here::here("code","analysis","R","desc_tables.R"))
source(here::here("code","analysis","R","desc_tables_no_decimal.R"))
################################################################################
#descriptive stats
filename_hh = paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab1_HH.txt")
filename_hh_no_decimal = paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab1_HH_no_decimal.txt")
filename_ind = paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab1_IND.txt")

v_list <- c("totcons_adj",
            "totfd_adj",
            "totnfd_adj",
            "poor19",
            "poor32",
            "poor55",
            "HHwealthIndex",
            "dwellowned",
            "hhsize",
            "haselectricity",
            "female",
            "femaleHeaded",
            "highcons",
            "north",
            "urban",
            "treated_2g",
            "lfp",
            "employed",
            "self_employed",
            "wage_worker")
results <- read_dta(paste0(path,"/analysis/descriptive/descriptive_table.dta")) %>%
  filter(var_name %in% v_list) %>%
  dplyr::mutate(var_name = ifelse(var_name=="totcons_adj","Total Consumption", var_name),
                var_name = ifelse(var_name=="totfd_adj","Food Consumption", var_name),
                var_name = ifelse(var_name=="totnfd_adj","Non-food Consumption", var_name),
                var_name = ifelse(var_name=="poor19","Poverty $1.9", var_name),
                var_name = ifelse(var_name=="poor32","Poverty $3.2", var_name),
                var_name = ifelse(var_name=="poor55","Poverty $5.5", var_name),
                var_name = ifelse(var_name=="HHwealthIndex","Wealth index", var_name),
                var_name = ifelse(var_name=="dwellowned","=1 if dwelling is owned", var_name),
                var_name = ifelse(var_name=="hhsize","Household size", var_name),
                var_name = ifelse(var_name=="haselectricity","=1 if dwelling has electricity", var_name),
                var_name = ifelse(var_name=="female","Female", var_name),
                var_name = ifelse(var_name=="femaleHeaded","Female (headed)", var_name),
                var_name = ifelse(var_name=="highcons","High consumption", var_name),
                var_name = ifelse(var_name=="north","North", var_name),
                var_name = ifelse(var_name=="urban","Urban", var_name),
                var_name = ifelse(var_name=="treated_2g","2G coverage", var_name),
                #var_name = ifelse(var_name=="move","Moved", var_name),
                #var_name = ifelse(var_name=="lnuvn1","Unit price of rice", var_name),
                #var_name = ifelse(var_name=="lnuvn2","Unit price of palm oil", var_name),
                #var_name = ifelse(var_name=="lnuvn3","Unit price of beef", var_name),
                #var_name = ifelse(var_name=="lnuvn4","Unit price of white beans", var_name),
                #var_name = ifelse(var_name=="lnuvn5","Unit price of groundnut oil", var_name),
                var_name = ifelse(var_name=="lfp","LFP", var_name),
                var_name = ifelse(var_name=="employed","Employed", var_name),
                var_name = ifelse(var_name=="self_employed","Self emp.", var_name),
                var_name = ifelse(var_name=="wage_worker","Wage emp.", var_name)) 

no_decimal_list <- c("Total Consumption","Food Consumption","Non-food Consumption")

ind_var_list <- c("LFP","Employed","Self emp.","Wage emp.","Female")

results_hh_no_decimal <- results %>%
  filter(var_name %in% no_decimal_list)

results_hh <- results %>%
  filter(!var_name %in% ind_var_list & !var_name %in% no_decimal_list)

results_ind <- results %>%
  filter(var_name %in% ind_var_list)

#now separate between household-level and individual-level observations
desc_tables_no_decimal(results_hh_no_decimal, filename_hh_no_decimal)
desc_tables(results_hh, filename_hh)
desc_tables(results_ind, filename_ind)

################################################################################
#Table A-3: descriptive stats for the sample within 6-16km from the closest tower
filename_hh = paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-3.txt")
filename_hh_no_decimal = paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-3.txt")
filename_ind = paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-3.txt")


v_list <- c("totcons_adj",
            "totfd_adj",
            "totnfd_adj",
            "poor19",
            "poor32",
            "poor55",
            "HHwealthIndex",
            "dwellowned",
            "hhsize",
            "haselectricity",
            "female",
            "femaleHeaded",
            "highcons",
            "north",
            "urban",
            #"treated_2g",
            "lfp",
            "employed",
            "self_employed",
            "wage_worker")
results <- read_dta(paste0(path,"/analysis/descriptive/descriptive_table_6-16km.dta")) %>%
  filter(var_name %in% v_list) %>%
  dplyr::mutate(var_name = ifelse(var_name=="totcons_adj","Total Consumption", var_name),
                var_name = ifelse(var_name=="totfd_adj","Food Consumption", var_name),
                var_name = ifelse(var_name=="totnfd_adj","Non-food Consumption", var_name),
                var_name = ifelse(var_name=="poor19","Poverty $1.9", var_name),
                var_name = ifelse(var_name=="poor32","Poverty $3.2", var_name),
                var_name = ifelse(var_name=="poor55","Poverty $5.5", var_name),
                var_name = ifelse(var_name=="HHwealthIndex","Wealth index", var_name),
                var_name = ifelse(var_name=="dwellowned","=1 if dwelling is owned", var_name),
                var_name = ifelse(var_name=="hhsize","Household size", var_name),
                var_name = ifelse(var_name=="haselectricity","=1 if dwelling has electricity", var_name),
                var_name = ifelse(var_name=="female","Female", var_name),
                var_name = ifelse(var_name=="femaleHeaded","Female (headed)", var_name),
                var_name = ifelse(var_name=="highcons","High consumption", var_name),
                var_name = ifelse(var_name=="north","North", var_name),
                var_name = ifelse(var_name=="urban","Urban", var_name),
                #var_name = ifelse(var_name=="treated_2g","Covered by 2G", var_name),
                #var_name = ifelse(var_name=="move","Moved", var_name),
                #var_name = ifelse(var_name=="lnuvn1","Unit price of rice", var_name),
                #var_name = ifelse(var_name=="lnuvn2","Unit price of palm oil", var_name),
                #var_name = ifelse(var_name=="lnuvn3","Unit price of beef", var_name),
                #var_name = ifelse(var_name=="lnuvn4","Unit price of white beans", var_name),
                #var_name = ifelse(var_name=="lnuvn5","Unit price of groundnut oil", var_name),
                var_name = ifelse(var_name=="lfp","LFP", var_name),
                var_name = ifelse(var_name=="employed","Employed", var_name),
                var_name = ifelse(var_name=="self_employed","Self emp.", var_name),
                var_name = ifelse(var_name=="wage_worker","Wage emp.", var_name)) 

no_decimal_list <- c("Total Consumption","Food Consumption","Non-food Consumption")

ind_var_list <- c("LFP","Employed","Self emp.","Wage emp.","Female")

results_hh_no_decimal <- results %>%
  filter(var_name %in% no_decimal_list)

results_hh <- results %>%
  filter(!var_name %in% ind_var_list & !var_name %in% no_decimal_list)

results_ind <- results %>%
  filter(var_name %in% ind_var_list)

#now separate between household-level and individual-level observations
desc_tables_no_decimal(results_hh_no_decimal, filename_hh_no_decimal)
desc_tables(results_hh, filename_hh)
desc_tables(results_ind, filename_ind)


################################################################################
results <- read_dta(paste0(path,"/Draft/Submission JDE/RR Oct 23/csdid.dta")) %>%
  mutate(gt = "",
         gt = ifelse( g == "Group" & t >= 1 & t < 2, "Early - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 2 & t < 3, "Early - Wave 3", gt), 
         gt = ifelse( g == "Group" & t >= 3 & t < 4, "Late - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 4 & t < 5, "Late - Wave 3", gt), 
         gt = ifelse( g == "ATT" ,  "Simple ATT", gt))

results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 1 & method == "drimp") %>%
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)

################################################################################
#Table 2
#get coefficients on welfare outcomes
main_v <- c("lntotcons_adj","lntotfd_adj","lntotnfd_adj","poor19","poor32","poor55","lfp","employed","self_employed","wage_worker")
filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab2.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))

################################################################################
#Table 3
##No control
results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 0 & method == "drimp") %>% #no control
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)

#Robustness checks
#get coefficients on welfare outcomes
main_v <- c("lntotcons_adj","lntotfd_adj","lntotnfd_adj","poor19","poor32","poor55","lfp","employed","self_employed","wage_worker")
filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab3_no_control.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))


##IPW
results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 1 & method == "ipw") %>% #no control
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)
  
filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab3_ipw.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))


##Only outcome regression
results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 1 & method == "reg") %>% #no control
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)
  
  filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab3_reg.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))

################################################################################
#Table A-6: Heterogenous effects
results <- read_dta(paste0(path,"/Draft/Submission JDE/RR Oct 23/csdid_sub_group.dta")) %>%
  mutate(gt = "",
         gt = ifelse( g == "Group" & t >= 1 & t < 2, "Early - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 2 & t < 3, "Early - Wave 3", gt), 
         gt = ifelse( g == "Group" & t >= 3 & t < 4, "Late - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 4 & t < 5, "Late - Wave 3", gt), 
         gt = ifelse( g == "ATT" ,  "Simple ATT", gt)) %>%
  filter(control==1)

results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 1 & method == "drimp") %>%
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,i,sub_group,b_coef,se,t,pval_pre,n_obs)

main_v <- c("lntotcons_adj","lntotfd_adj","lntotnfd_adj","poor19","poor32","poor55")
subgroup <- c("femaleHeaded","highcons","north","urban")

for(v in main_v) {
  #v <- "lntotcons_adj"
  filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-6_",v,".txt")
  subgroup_tables(dt=results_main, subgroup=subgroup, varlist = v, filename=filename)
}

main_v <- c("lfp","employed","self_employed","wage_worker")
subgroup <- c("female","highcons","north","urban")

for(v in main_v) {
  #v <- "lntotcons_adj"
  filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-6_",v,".txt")
  subgroup_tables(dt=results_main, subgroup=subgroup, varlist = v, filename=filename)
}

################################################################################
#Table 4: Spatial discontinuity
results <- read_dta(paste0(path,"/Draft/Submission JDE/RR Oct 23/csdid_exogeneity.dta")) %>%
  mutate(gt = "",
         gt = ifelse( g == "Group" & t >= 1 & t < 2, "Early - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 2 & t < 3, "Early - Wave 3", gt), 
         gt = ifelse( g == "Group" & t >= 3 & t < 4, "Late - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 4 & t < 5, "Late - Wave 3", gt), 
         gt = ifelse( g == "ATT" ,  "Simple ATT", gt))

results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 1 & method == "drimp" & lower==6) %>% #with controls
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)


main_v <- c("lntotcons_adj","lntotfd_adj","lntotnfd_adj","poor19","poor32","poor55","lfp","employed","self_employed","wage_worker")
filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/Tab4.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))

################################################################################
#Table A-5: Other channels
results <- read_dta(paste0(path,"/Draft/Submission JDE/RR Oct 23/csdid.dta")) %>%
  mutate(gt = "",
         gt = ifelse( g == "Group" & t >= 1 & t < 2, "Early - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 2 & t < 3, "Early - Wave 3", gt), 
         gt = ifelse( g == "Group" & t >= 3 & t < 4, "Late - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 4 & t < 5, "Late - Wave 3", gt), 
         gt = ifelse( g == "ATT" ,  "Simple ATT", gt))

results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 0 & method == "drimp") %>%
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)


main_v <- c("move","lntotcons_exc_nfdcomm_adj","lntotnfd_exc_nfdcomm_adj","lnuvn1","lnuvn2","lnuvn3","lnuvn4","lnuvn5")
filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-5.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))

################################################################################
#GB tables
main_v <- c("lntotcons_adj","lntotfd_adj","lntotnfd_adj","poor19","poor32","poor55","lfp","employed","self_employed","wage_worker")
gb_results <- read_dta(paste0(path,"/output/GB_Results.dta")) %>%
  dplyr::select(var_name, b2by21, b2by22, b2by23, b2by24, b2by25) %>%
  filter(var_name %in% main_v) %>%
  dplyr::mutate(var_name = ifelse(var_name=="lntotcons_adj","Total Consumption", var_name),
                var_name = ifelse(var_name=="lntotfd_adj","Food Consumption", var_name),
                var_name = ifelse(var_name=="lntotnfd_adj","Non-food Consumption", var_name),
                var_name = ifelse(var_name=="poor19","Poverty $1.9", var_name),
                var_name = ifelse(var_name=="poor32","Poverty $3.2", var_name),
                var_name = ifelse(var_name=="poor55","Poverty $5.5", var_name),
                var_name = ifelse(var_name=="lfp","LFP", var_name),
                var_name = ifelse(var_name=="employed","Employed", var_name),
                var_name = ifelse(var_name=="self_employed","Self emp.", var_name),
                var_name = ifelse(var_name=="wage_worker","Wage emp.", var_name)) %>%
 mutate(b2by21 = round(b2by21,4),
         b2by22 = round(b2by22,4),
         b2by23 = round(b2by23,4),
         b2by24 = round(b2by24,4),
         b2by25 = round(b2by25,4))

gb_table(gb_results, filename=filename)

filename = paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-2.txt")
gb_results <- read_dta(paste0(path,"/output/GB_Results.dta")) %>%
  filter(var_name=="lntotcons_adj" | var_name=="lfp") %>%
  dplyr::select(var_name, weights1, weights2, weights3, weights4, weights5) %>%
  dplyr::mutate(var_name = ifelse(var_name=="lntotcons_adj","Household-level", var_name),
                var_name = ifelse(var_name=="lfp","Individual-level", var_name)) %>%
  filter(var_name!="") %>%
  mutate(weights1 = round(weights1,4),
         weights2 = round(weights2,4),
         weights3 = round(weights3,4),
         weights4 = round(weights4,4),
         weights5 = round(weights5,4))

gb_table(gb_results, filename=filename)

################################################################################
#Table A-7: Results with sampling weights
results <- read_dta(paste0(path,"/Draft/Submission JDE/RR Oct 23/csdid_wgt.dta")) %>%
  mutate(gt = "",
         gt = ifelse( g == "Group" & t >= 1 & t < 2, "Early - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 2 & t < 3, "Early - Wave 3", gt), 
         gt = ifelse( g == "Group" & t >= 3 & t < 4, "Late - Wave 2", gt), 
         gt = ifelse( g == "Group" & t >= 4 & t < 5, "Late - Wave 3", gt), 
         gt = ifelse( g == "ATT" ,  "Simple ATT", gt))

results_main <- results %>%
  filter((g == "Group" | g == "ATT") & control == 1 & method == "drimp") %>%
  filter(gt != "") %>%
  mutate(star = ifelse(pval < 0.05,"*",""),
         b_coef = paste0(round(b,3),star)) %>%
  dplyr::select(gt,v,b_coef,se,t,pval_pre, n_obs)

main_v <- c("lntotcons_adj","lntotfd_adj","lntotnfd_adj","poor19","poor32","poor55","lfp","employed","self_employed","wage_worker")
filename <- paste0(path,"/Draft/Submission JDE/RR Oct 23/TabA-7.txt")
main_tables(dt = results_main, varlist = main_v, filename = filename, ncol=length(main_v))
