
********************************************************************************
*Heterogenous effects
********************************************************************************
use "${path}/Draft/Submission JDE/RR Oct 23/csdid_sub_group.dta", clear
drop if t > 4 & g == "Group"
sort control method i sub_group v g t
bys control method i sub_group v g: gen category = _n * 10

lab var ul "95% CI (upper)"
lab var ll "95% CI (lower)"

//adjust category values so that coefficients can be compared
keep if g == "ATT"
replace category = category + 3 if v == "lntotfd_adj" & sub_group==0
replace category = category + 6 if v == "lntotnfd_adj" & sub_group==0
replace category = category + 9 if v == "poor19" & sub_group==0
replace category = category + 12 if v == "poor32" & sub_group==0
replace category = category + 15 if v == "poor55" & sub_group==0
replace category = category + 18 if v == "lfp" & sub_group==0
replace category = category + 21 if v == "employed" & sub_group==0
replace category = category + 24 if v == "self_employed" & sub_group==0
replace category = category + 27 if v == "wage_worker" & sub_group==0

replace category = category + 1 if v == "lntotcons_adj" & sub_group==1
replace category = category + 4 if v == "lntotfd_adj" & sub_group==1
replace category = category + 7 if v == "lntotnfd_adj" & sub_group==1
replace category = category + 10 if v == "poor19" & sub_group==1
replace category = category + 13 if v == "poor32" & sub_group==1
replace category = category + 16 if v == "poor55" & sub_group==1
replace category = category + 19 if v == "lfp" & sub_group==1
replace category = category + 22 if v == "employed" & sub_group==1
replace category = category + 25 if v == "self_employed" & sub_group==1
replace category = category + 28 if v == "wage_worker" & sub_group==1

********************************************************************************
*Generate coefficient plots (baseline)
*Variable list
local v_list "lntotcons_adj lntotfd_adj lntotnfd_adj poor19 poor32 poor55 lfp employed self_employed wage_worker"

*Sub-group list
local sub female highcons north urban 
*local sub female 

local t_threshold = 42

*local method "drimp reg ipw" 
local method "drimp" 

*for household level outcomes, we look at only female vs. male headed households
drop if ///
(v == "lntotcons_adj" | ///
v == "lntotfd_adj" | ///
v == "lntotnfd_adj" | ///
v == "poor19" | ///
v == "poor32" | ///
v == "poor55" | ///
v == "lntotcons_adj" | ///
v == "lntotfd_adj" | ///
v == "lntotnfd_adj" | ///
v == "poor19" | ///
v == "poor32" | ///
v == "poor55") & /// 
i == "female"

replace i = "female" if ///
(v == "lntotcons_adj" | ///
v == "lntotfd_adj" | ///
v == "lntotnfd_adj" | ///
v == "poor19" | ///
v == "poor32" | ///
v == "poor55" | ///
v == "lntotcons_adj" | ///
v == "lntotfd_adj" | ///
v == "lntotnfd_adj" | ///
v == "poor19" | ///
v == "poor32" | ///
v == "poor55") & /// 
i=="femaleHeaded"

local v1 "lntotcons_adj"
local v2 "lntotfd_adj" 
local v3 "lntotnfd_adj"
local v4 "poor19" 
local v5 "poor32" 
local v6 "poor55" 
local v7 "lfp" 
local v8 "employed" 
local v9 "self_employed" 
local v10 "wage_worker" 

foreach i of local sub {
foreach m of local method {
if "`i'" == "female" {
	local lab_0 "Male"
	local lab_1 "Female"
}

if "`i'" == "highcons" {
	local lab_0 "Low"
	local lab_1 "High"
}

if "`i'" == "north" {
	local lab_0 "South"
	local lab_1 "North"
}

if "`i'" == "urban" {
	local lab_0 "Rural"
	local lab_1 "Urban"
}


twoway scatter b category if category<`t_threshold' & v=="`v1'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold' & v=="`v1'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black) || ///
scatter b category if category<`t_threshold'  & v=="`v1'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lp(dash) mfcolor(white) ms(*2) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v1'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black) || ///
scatter b category if category<`t_threshold'  & v=="`v2'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v2'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold' & v=="`v2'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lp(dash) mfcolor(white) ms(*2.5) m(triangle) mlc(black) || /// 
rcap ul ll category if category<`t_threshold' & v=="`v2'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v3'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v3'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v3'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lp(dash) mfcolor(white) ms(*2.5) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v3'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold' & v=="`v4'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || /// 
rcap ul ll category if category<`t_threshold' & v=="`v4'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v4'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lp(dash) mfcolor(white) ms(*2.5) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v4'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v5'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v5'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v5'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lp(dash) mfcolor(white) ms(*2.5) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v5'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold' & v=="`v6'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold' & v=="`v6'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black) || ///
scatter b category if category<`t_threshold'  & v=="`v6'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lp(dash) mfcolor(white) ms(*2) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v6'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black) || ///
scatter b category if category<`t_threshold'  & v=="`v7'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v7'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v7'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, mfcolor(white) ms(*2.5) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v7'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold' & v=="`v8'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || /// 
rcap ul ll category if category<`t_threshold' & v=="`v8'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v8'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, mfcolor(white) ms(*2.5) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v8'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v9'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v9'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold' & v=="`v9'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, mfcolor(white) ms(*2.5) m(triangle) mlc(black) || /// 
rcap ul ll category if category<`t_threshold' & v=="`v9'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v10'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, mfcolor(black) ms(*2) m(circle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v10'" & control==1 & method=="`m'" & i == "`i'" & sub_group==0, lc(black)  || ///
scatter b category if category<`t_threshold'  & v=="`v10'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, mfcolor(white) ms(*2.5) m(triangle) mlc(black) || ///
rcap ul ll category if category<`t_threshold'  & v=="`v10'" & control==1 & method=="`m'" & i == "`i'" & sub_group==1, lc(black)  || , ytitle("Simple ATT", size(*1.3)) xtitle("") ylab(-.4(.1).4) yline(0) xline(12 15 18 21 24 27 30 33 36 39, lp(solid)) ///
xlab(11 "Total cons." 14 "Food cons." 17 "Non-food cons." 20 "Poverty $1.9" 23 "Poverty $3.2" 26 "Poverty $5.5" 29 "LFP" 32 "Employed" 35 "Self emp." 38 "Wage emp.", nogrid labsize(small) angle(45)) graphregion(fcolor(white)) legend(order(1 "`lab_0'" 3 "`lab_1'") cols(2) position(6) size(*1.3)) 
graph export "${path}\Draft\Submission JDE\RR Oct 23\figures\csdid_`m'_`i'.png", as("png") replace
}
}