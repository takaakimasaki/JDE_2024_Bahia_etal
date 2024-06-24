/* This file implements the Goodman-Bacon(2019) decomposition as robustness checks for the paper's principal results */
 /* Tobias Pfutze, May 2020 */
clear matrix
clear mata
*set maxvar 30000
cap log close
log using "${path}/output/GB_Results.txt", replace
gl control_list "HHwealthIndex dwellowned hhsize haselectricity"


clear all
#delimit;
set more off;
*ssc install bacondecomp;
use "${path}/processed/Bahia_etal_2024_JDE_replication_dataset.dta", clear ;
/*wave dummies*/
/*
gen d_wave1=wave==1;
gen d_wave2=wave==2;
*/
xtset indiv_id wave;

/* Create balanced panel*/
by indiv_id: gen numwaves=_N;
keep if numwaves==3;
drop numwaves;

local treatments treated_MBB /*treated1more_MBB treated2more_MBB treated3more_MBB*/;

foreach i of local treatments {;
gen diff_`i'=`i'-l.`i';
by indiv_id: egen diff_`i'_min=min(diff_`i');
drop if diff_`i'_min<0;
*drop diff_`i' diff_`i'_min;
};

#d ;
local outcomesHH lntotcons_adj lntotfd_adj lntotnfd_adj poor19 poor32 poor55 ;

local outcomesIndiv lfp employed unemployed self_employed worked_on_own_farm wage_worker  ;

/*Matrices for results*/
matrix Beta==J(1,1,0);
matrix Var==J(1,1,0);
matrix B2by2==J(1,7,0);
matrix Weights==J(1,7,0);

/* HH level outcomes */
foreach i of local outcomesHH{;

bacondecomp `i' treated_MBB ${control_list} if hhhead==1, robust cluster(lgaw1);
graph save "${path}/output/GBgraph_`i'_1", replace;
matrix Beta==[Beta\e(b)];
matrix Var==[Var\e(V)];
matrix B2by2=[B2by2\e(dd)];
matrix Weights=[Weights\e(wt)];

};

/* Individual level outcomes */
foreach i of local outcomesIndiv{;

bacondecomp `i' treated_MBB ${control_list} if age>=15 & age<65, robust cluster(lgaw1);
graph save "${path}/output/GBgraph_`i'_1", replace;
matrix Beta==[Beta\e(b)];
matrix Var==[Var\e(V)];
matrix B2by2=[B2by2\e(dd)];
matrix Weights=[Weights\e(wt)];

};


/* Convert matrices into data*/
svmat double Beta, names(beta);
svmat double Var, names(var);
svmat double B2by2, names(b2by2);
svmat double Weights, names(weights);
gen ste1=sqrt(var1);

/*Create std errors*/
#d ;
local outcomesHH lntotcons_adj lntotfd_adj lntotnfd_adj poor19 poor32 poor55 ;

local outcomesIndiv lfp employed unemployed self_employed worked_on_own_farm wage_worker  ;

order beta* b2by2* ste* weights*;
keep beta* b2by2* ste* weights*;
local outcomes "`outcomesHH' `outcomesIndiv'" ;
gen id = _n ;
gen var_name = "" ;
local n = 1 ;
foreach v of local outcomes { ;
	local n = `n' + 1 ;
	replace var_name = "`v'" if id==`n' ;
} ;
drop if missing(beta1) ;
drop id ;
save "${path}/output/GB_Results.dta", replace;


log close