/* This dofile runs the Callaway, Sant'Anna analysis on the Nigeria 3/4g cell phone data on Stata with the limited sample within 6-16km from the closest tower*/
*ssc install drdid, replace
*ssc install csdid, replace

clear all
use "${path}/processed/Bahia_etal_2024_JDE_replication_dataset.dta", clear

********************************************************************************
/*check if data is properly prepared for CSDID application*/
********************************************************************************
tab wave treatfirst
gen popweight = hhweight * hhsize

********************************************************************************
/*visualize coefficient plots*/
********************************************************************************
local method "drimp"
local v_list "lntotcons_adj lntotfd_adj lntotnfd_adj lntotcons_exc_nfdcomm_adj lntotnfd_exc_nfdcomm_adj poor19 poor32 poor55"
local v_ind_list "lfp employed unemployed self_employed worked_on_own_farm wage_worker"

cap postclose output
postfile output str20 g str30 v t b se z pval ll ul pval_pre str10 method control lower upper n_obs using "${path}/Draft/Submission JDE/RR Oct 23/csdid_exogeneity.dta", replace 

foreach lower in /*5*/ 6 {
	foreach upper in 16 /*14*/ {
local first = 0
foreach m of local method {
foreach v of local v_list {
	local control = 0
	local first = `first' + 1
	
	/*DID household level without controls*/
	csdid `v' if indiv==1 & treatfirst!=1 & dist_3gtower_2015>`lower' & dist_3gtower_2015<`upper'  & migrate!=1 /*[weight=popweight]*/, i(hhid) t(wave) gvar(treatfirst) method(`m')
	local n_obs = e(N) 
	matrix table = r(table)
	matrix b=e(b)
	matrix v=e(V)
	matrix G_NC=[b[1,1..4]'\.\v[1,1]\v[2,2]\v[3,3]\v[4,4]]
	csdid_estat simple
	matrix ATT_NC=r(table)
	csdid_estat event
	matrix e=r(table)
	matrix E_NC=[e[1,1]\e[2,1]\e[4,1]\.\e[1,2]\e[2,2]\e[4,2]\.\e[1,3]\e[2,3]\e[4,3]]
	estat pretrend
	local pval_pre = `r(pchi2)'
	forv t = 1/`=colsof(table)' {
		local b_`t' = table[1, `t'] 
		local se_`t' = table[2, `t'] 
		local z_`t' = table[3, `t'] 
		local pval_`t' = table[4, `t'] 
		local ll_`t' = table[5, `t'] 
		local ul_`t' = table[6, `t']  
		post output ("Group") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(ATT_NC)' {
		local b_`t' = ATT_NC[1, `t'] 
		local se_`t' = ATT_NC[2, `t'] 
		local z_`t' = ATT_NC[3, `t'] 
		local pval_`t' = ATT_NC[4, `t'] 
		local ll_`t' = ATT_NC[5, `t'] 
		local ul_`t' = ATT_NC[6, `t']  
		post output ("ATT") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(e)' {
		local b_`t' = e[1, `t'] 
		local se_`t' = e[2, `t'] 
		local z_`t' = e[3, `t'] 
		local pval_`t' = e[4, `t'] 
		local ll_`t' = e[5, `t'] 
		local ul_`t' = e[6, `t']  
		post output ("Event") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}

	/*DID household level with controls*/
	local control = 1
	csdid `v' HHwealthIndex dwellowned hhsize haselectricity if indiv==1 & treatfirst!=1 & dist_3gtower_2015>`lower' & dist_3gtower_2015<`upper'  & migrate!=1, i(hhid) t(wave) gvar(treatfirst) method(`m') 
	matrix table = r(table)
	matrix b=e(b)
	matrix v=e(V)
	matrix G_NC=[b[1,1..4]'\.\v[1,1]\v[2,2]\v[3,3]\v[4,4]]
	csdid_estat simple
	matrix ATT_NC=r(table)
	csdid_estat event
	matrix e=r(table)
	matrix E_NC=[e[1,1]\e[2,1]\e[4,1]\.\e[1,2]\e[2,2]\e[4,2]\.\e[1,3]\e[2,3]\e[4,3]]
	estat pretrend
	local pval_pre = `r(pchi2)'
	forv t = 1/`=colsof(table)' {
		local b_`t' = table[1, `t'] 
		local se_`t' = table[2, `t'] 
		local z_`t' = table[3, `t'] 
		local pval_`t' = table[4, `t'] 
		local ll_`t' = table[5, `t'] 
		local ul_`t' = table[6, `t']  
		post output ("Group") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(ATT_NC)' {
		local b_`t' = ATT_NC[1, `t'] 
		local se_`t' = ATT_NC[2, `t'] 
		local z_`t' = ATT_NC[3, `t'] 
		local pval_`t' = ATT_NC[4, `t'] 
		local ll_`t' = ATT_NC[5, `t'] 
		local ul_`t' = ATT_NC[6, `t']  
		post output ("ATT") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(e)' {
		local b_`t' = e[1, `t'] 
		local se_`t' = e[2, `t'] 
		local z_`t' = e[3, `t'] 
		local pval_`t' = e[4, `t'] 
		local ll_`t' = e[5, `t'] 
		local ul_`t' = e[6, `t']  
		post output ("Event") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
}


/*DID individual level without controls*/
foreach v of local v_ind_list {
	local control = 0
	csdid `v' if age>=15 & age<65 & treatfirst!=1 & dist_3gtower_2015>`lower' & dist_3gtower_2015<`upper'  & migrate!=1, i(indiv_id) t(wave) gvar(treatfirst) method(`m')
	matrix table = r(table)
	csdid_estat simple
	matrix ATT_NC=r(table)
	csdid_estat event
	matrix e=r(table)
	estat pretrend
	local pval_pre = `r(pchi2)'
	forv t = 1/`=colsof(table)' {
		local b_`t' = table[1, `t'] 
		local se_`t' = table[2, `t'] 
		local z_`t' = table[3, `t'] 
		local pval_`t' = table[4, `t'] 
		local ll_`t' = table[5, `t'] 
		local ul_`t' = table[6, `t']  
		post output ("Group") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(ATT_NC)' {
		local b_`t' = ATT_NC[1, `t'] 
		local se_`t' = ATT_NC[2, `t'] 
		local z_`t' = ATT_NC[3, `t'] 
		local pval_`t' = ATT_NC[4, `t'] 
		local ll_`t' = ATT_NC[5, `t'] 
		local ul_`t' = ATT_NC[6, `t']  
		post output ("ATT") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(e)' {
		local b_`t' = e[1, `t'] 
		local se_`t' = e[2, `t'] 
		local z_`t' = e[3, `t'] 
		local pval_`t' = e[4, `t'] 
		local ll_`t' = e[5, `t'] 
		local ul_`t' = e[6, `t']  
		post output ("Event") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	
	local control = 1
	csdid `v' HHwealthIndex dwellowned hhsize haselectricity if age>=15 & age<65 & treatfirst!=1 & dist_3gtower_2015>`lower' & dist_3gtower_2015<`upper'  & migrate!=1 /*[weight=hhweight]*/, i(indiv_id) t(wave) gvar(treatfirst) method(`m')
	matrix table = r(table)
	csdid_estat simple
	matrix ATT_NC=r(table)
	csdid_estat event
	matrix e=r(table)
	estat pretrend
	local pval_pre = `r(pchi2)'
		forv t = 1/`=colsof(table)' {
		local b_`t' = table[1, `t'] 
		local se_`t' = table[2, `t'] 
		local z_`t' = table[3, `t'] 
		local pval_`t' = table[4, `t'] 
		local ll_`t' = table[5, `t'] 
		local ul_`t' = table[6, `t']  
		post output ("Group") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(ATT_NC)' {
		local b_`t' = ATT_NC[1, `t'] 
		local se_`t' = ATT_NC[2, `t'] 
		local z_`t' = ATT_NC[3, `t'] 
		local pval_`t' = ATT_NC[4, `t'] 
		local ll_`t' = ATT_NC[5, `t'] 
		local ul_`t' = ATT_NC[6, `t']  
		post output ("ATT") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}
	forv t = 1/`=colsof(e)' {
		local b_`t' = e[1, `t'] 
		local se_`t' = e[2, `t'] 
		local z_`t' = e[3, `t'] 
		local pval_`t' = e[4, `t'] 
		local ll_`t' = e[5, `t'] 
		local ul_`t' = e[6, `t']  
		post output ("Event") ("`v'") (`t') (`b_`t'') (`se_`t'') (`z_`t'') (`pval_`t'') (`ll_`t'') (`ul_`t'') (`pval_pre') ("`m'") (`control') (`lower') (`upper') (`n_obs')
	}	
}
}
}
}
postclose output 
