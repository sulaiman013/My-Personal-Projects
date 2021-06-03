*************************************************************
* The Corrosive Effect of Corruption in Trust in Politicians
* Last updated: 17/04/2017
*************************************************************

* Introduce path where files have been saved" 
cd ""




* Data management: Lines 16-97
* Figures and tables included in paper: Lines 101-152
* Appendixes tables and figures: Lines 153-386
version 13.1
******************
* Loading dataset
******************
use ess_6_spain.dta, clear

******************
* Data management
******************
* Generating the D_exposure_barcenas variable
gen D_exposure_barcenas = . 
tab1 inwdds inwmms   
recode D_exposure_barcenas (.=0) if inwmms == 1 & inwdds < 31
recode D_exposure_barcenas (.=1) if inwmms > 1 
recode D_exposure_barcenas (.=1) if inwmms == 1 & inwdds == 31
recode D_exposure_barcenas (1=.) if inwmms > 2

* Time variable for the months of January and February
gen time = inwdds 
replace time = . if D_exposure_barcenas == . 
replace time = (time - 31) if D_exposure_barcenas == 0
replace time = 0 if time == 31


* Time variable for the whole survey fieldwork period 
tab1 inwdds inwmms   
gen time_whole=time
replace time_whole= 28 + inwdds if inwmms==3
replace time_whole= 59 + inwdds if inwmms==4
replace time_whole= 89 + inwdds if inwmms==5

* Alternative D_exposure_barcenas variable considering the whole survey fieldwork (to study decay of the D_exposure_barcenas effect)
gen treatment1 = . 
tab1 inwdds inwmms   
recode treatment1 (.=0) if inwmms == 1 & inwdds < 31
recode treatment1 (.=1) if inwmms > 1 
recode treatment1 (.=1) if inwmms == 1 & inwdds == 31


* Time variable with positive values for the whole fieldwork period (for simulation)
gen fieldwork_time = time_whole + 8 

* Dummies for party voted to 
tab prtvtces, m gen(party_voted)

* Recoding activty variabe and generating dummies
recode mnactic (4=3) (6=5) (8=5), gen(employment)
ta employment, gen(activity_rec_)
label def employment 1"Paid Work" 2"In education" 3"Unemployed" 5"Out of labor market" 9"Other"
label val employment employment
rename activity_rec_1 emp_paid_work
rename activity_rec_2 emp_in_education
rename activity_rec_3 emp_unemployed
rename activity_rec_4 emp_out_labor
rename activity_rec_5 emp_other


* Elections winner variable (coded 1 for PP voters)
gen election_winner =party_voted1

* Number of times a respondent refused to answer to the survey (reachability bias). From ESS paradata
foreach var of varlist outnic1-outnic69{
	recode `var' (1=0) (2=1) (3/13=.)
}
egen refusals = rowtotal(outnic1-outnic69)

* Voting and abstention 
recode vote (3=.) (2=0)

* Encoding regions 
encode region, gen(regionnum)

* Identifying regions that are only present in D_exposure_barcenas = 1 
gen region_treatment = 0
forval i = 1/18{
	sum D_exposure_barcenas if regionnum == `i'
	recode region_treatment (0=1) if `r(mean)' < 1 & regionnum == `i'
}


* Saving the recoded dataset to run simulations 
save ess_6_spain_recoded.dta, replace 
