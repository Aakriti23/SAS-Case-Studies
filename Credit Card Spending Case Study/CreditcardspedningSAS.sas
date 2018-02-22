/******************* Linear Regression Case Study ***********************/
/******************* E-mail-aakritijain96@gmail.com **********************/


/***************** Setting library name and importing the data *********************/


libname class '/folders/myfolders/del';

proc import datafile='/folders/myfolders/del/LinearRegression.csv' out=linearreg dbms=csv replace;
guessingrows=5000;
run;

ODS HTML FILE='/folders/myfolders/contents.xls';
proc contents data=linearreg;
run;
ODS HTML CLOSE;

/************* Changing data types of some variables **********************/

data linearreg;
set linearreg;
lnothdebt1=input(lnothdebt,best12.);
lncreddebt1=input(lncreddebt,best12.);
cardten1=input(cardten,best12.);
commutetime1=input(commutetime,best12.);
lncardmon1=input(lncardmon,best12.);	
lncardten1=input(lncardten,best12.);
lnequipmon1=input(lnequipmon,best12.);
lnequipten1=input(lnequipten,best12.);
lnlongten1=input(lnlongten,best12.);
lntollmon1=input(lntollmon,best12.);
lntollten1=input(lntollten,best12.);
lnwiremon1=input(lnwiremon,best12.);
lnwireten1=input(lnwireten,best12.);
longten1=input(longten,best12.);
townsize1=input(townsize,best12.);
run;

data linearreg;
set linearreg;
drop lnothdebt lncreddebt cardten commutetime lncardmon lncardten lnequipmon lnequipten lnlongten lntollmon lntollten lnwiremon lnwireten longten townsize ;
rename lnothdebt1=lnothdebt lncreddebt1=lncreddebt cardten1=cardten commutetime1=commutetime lncardmon1=lncardmon
lncardten1=lncardten lnequipmon1=lnequipmon lnequipten1=lnequipten lnlongten1=lnlongten lntollmon1=lntollmon
lntollten1=lntollten lnwiremon1=lnwiremon lnwireten1=lnwireten longten1=longten townsize1=townsize;
run;


/**************** Dealing with missing values ******************/
proc means data=linearreg nmiss;
run;


data linearreg(drop=cardmon cardten equipmon equipten LONGMON LONGTEN  tollmon tollten wiremon wireten 
CREDDEBT OTHDEBT birthmonth custid card2items carditems);
set linearreg;
/* if lnothdebt=. or lncreddebt=. or cardten=. OR commutetime=. OR lnlongten=. OR longten=. OR townsize=. then delete; */
if cardmon=0 then lncardmon=0;
if cardten=0 then lncardten=0;
if equipmon=0 then lnequipmon=0;
if equipten=0 then lnequipten=0;
if tollmon=0 then lntollmon=0;
if tollten=0 then lntollten=0;
if wiremon=0 then lnwiremon=0;
if wireten=0 then lnwireten=0;
if longten=0 then lnlongten=0;
run;

DATA LINEARREG;
SET LINEARREG;
if lnothdebt=. or lncreddebt=. or LNcardten=. OR commutetime=. OR lnlongten=. OR townsize=. then DELETE;
RUN;

/************** Creating a new variable 'Totalcredspend'(Primary card spending + Secondary Card Spending)***********/
data linearreg(DROP=CARDSPENT CARD2SPENT);
set linearreg;
totalcredspend=cardspent + card2spent;
run;
/************ Transforming the dependent variable *******************/
DATA LINEARREG;
SET LINEARREG;
LN_TOTALCREDSPEND=LOG(TOTALCREDSPEND);
RUN;


/************** Outlier treatment **************/

PROC MEANS DATA= LINEARREG NMISS ;
RUN;

data linearreg;
set linearreg;
drop pets_birds pets_cats pets_dogs pets_freshfish pets_reptiles pets_saltfish pets_small ;
run;

proc means data=linearreg N Nmiss mean std min P1 P5 P10 P25 P50 P75 P90 P95 P99 max ;
var LN_TOTALCREDSPEND TOTALCREDSPEND address age card2tenure lncardmon lncardten cardtenure cars carvalue
commute commutetime lncreddebt debtinc ed employ lnequipmon lnequipten hourstv lninc lncreddebt lnlongmon
lnlongten lnothdebt lnlongmon lnlongten lnothdebt pets reside spoused tenure lntollmon lntollten lnwiremon lnwireten lninc;
run;


DATA class.LINEARREG;
SET LINEARREG;
IF LN_TOTALCREDSPEND>7.478311 THEN LN_TOTALCREDSPEND=7.478311;
IF totalcredspend>1769.25 THEN totalcredspend=1769.25;
IF address>48 THEN address=48;
IF age>79 THEN age=79;
IF card2tenure>30 THEN card2tenure=30;
IF lncardmon>4.16 THEN lncardmon=4.16;
IF lncardten>8.31 THEN lncardten=8.31;
IF cardtenure>40 THEN cardtenure=40;
IF cars>6 THEN cars=6;
IF carvalue>92.1 THEN carvalue=92.1;
IF commute>10 THEN commute=10;
IF commutetime>41 THEN commutetime=41;
IF lncreddebt>2.66 THEN lncreddebt=2.66;
IF debtinc>29.2 THEN debtinc=29.2;
IF ed>21 THEN ed=21;
IF employ>39 THEN employ=39;
IF lnequipmon>4.15 THEN lnequipmon=4.15;
IF lnequipten>8.21 THEN lnequipten=8.21;
IF hourstv>31 THEN hourstv=31;
IF lninc>5.61 THEN lninc=5.61;
IF lnlongmon>4.18 THEN lnlongmon=4.18;
IF lnlongten>8.46 THEN lnlongten=8.46;
IF lnothdebt>3.19 THEN lnothdebt=3.19;
IF pets>13 THEN pets=13;
IF reside>6 THEN reside=6;
IF spoused>20 THEN spoused=20;
IF tenure>72 THEN tenure=72;
IF lntollmon>4.07 THEN lntollmon=4.07;
IF lntollten>8.29 THEN lntollten=8.29;
IF lnwiremon>4.37 THEN lnwiremon=4.37;
IF lnwireten>8.42 THEN lnwireten=8.42;
RUN;


/**DATA IS CLEAN**/

/**/
DATA CONT(KEEP= LN_TOTALCREDSPEND TOTALCREDSPEND address age card2tenure lncardmon lncardten cardtenure cars carvalue
commute commutetime lncreddebt debtinc ed employ lnequipmon lnequipten hourstv lninc lncreddebt lnlongmon
lnlongten lnothdebt lnlongmon lnlongten lnothdebt pets reside spoused tenure lntollmon lntollten lnwiremon lnwireten) 
CAT(DROP= LN_TOTALCREDSPEND TOTALCREDSPEND address age card2tenure lncardmon lncardten cardtenure cars carvalue
commute commutetime lncreddebt debtinc ed employ lnequipmon lnequipten hourstv lninc lncreddebt lnlongmon
lnlongten lnothdebt lnlongmon lnlongten lnothdebt pets reside spoused tenure lntollmon lntollten lnwiremon lnwireten);
SET class.LINEARREG;
RUN;
/**/

/*******Checking linearity with dependent variables ***********/

PROC CONTENTS DATA=CONT;
RUN;
PROC CONTENTS DATA=CAT;
RUN;

%LET VARS=cardtenure;
%LIN;


%MACRO LIN;
PROC TRANSREG DATA=linearreg;
MODEL BOXCOX(&VARS./ lambda=-2 to 2 by 0.5 )=IDENTITY(LN_TOTALCREDSPEND);
RUN;
%MEND;

data linearreg(drop= age employ debtinc cars carvalue tenure address spoused cardtenure card2tenure);
set class.linearreg;
if age ne 0 then sq_age=sqrt(age); else sq_age=sqrt(age+1); /** lambda=0.5 **/
if employ ne 0 then ln_employ=log(employ); else ln_employ=log(employ+1); /** lambda=0 **/
if debtinc ge 0 then sq_debtinc=sqrt(debtinc); else sq_debtinc=sqrt(debtinc+1); /** lambda=0.5 **/
if cars ne 0 then ln_cars=log(cars); else ln_cars=log(cars+1); /** lambda=0 **/
if carvalue GT 0 then ln_carvalue=log(carvalue); else ln_carvalue=log(1); /** lambda=0 **/
if tenure ge 0 then sq_tenure=sqrt(tenure); else sq_tenure=sqrt(tenure+1); /** lambda=0.5 **/
if cardtenure ge 0 then sq_cardtenure=sqrt(cardtenure); else sq_cardtenure=sqrt(cardtenure+1);
if card2tenure ge 0 then sq_card2tenure=sqrt(cardtenure); else sq_card2tenure=sqrt(card2tenure+1);
run;

data cont(drop=age employ debtinc cars carvalue tenure address spoused cardtenure card2tenure);
set cont;
if age ne 0 then sq_age=sqrt(age); else sq_age=sqrt(age+1); /** lambda=0.5 **/
if employ ne 0 then ln_employ=log(employ); else ln_employ=log(employ+1); /** lambda=0 **/
if debtinc ge 0 then sq_debtinc=sqrt(debtinc); else sq_debtinc=sqrt(debtinc+1); /** lambda=0.5 **/ 
if cars ne 0 then ln_cars=log(cars); else ln_cars=log(cars+1); /** lambda=0 **/
if carvalue GT 0 then ln_carvalue=log(carvalue); else ln_carvalue=log(1); /** lambda=0 **/
if tenure ge 0 then sq_tenure=sqrt(tenure); else sq_tenure=sqrt(tenure+1); /** lambda=0.5 **/
if cardtenure ge 0 then sq_cardtenure=sqrt(cardtenure); else sq_cardtenure=sqrt(cardtenure+1);
if card2tenure ge 0 then sq_card2tenure=sqrt(cardtenure); else sq_card2tenure=sqrt(card2tenure+1);
run;



/**No changes in ed **/

PROC MEANS DATA=LINEARREG NMISS;
RUN;

/***** Correlation matrix *****/
PROC CONTENTS DATA=CONT;
RUN;

PROC CORR DATA=CONT;
VAR LN_TOTALCREDSPEND commute commutetime ed hourstv ln_cars ln_carvalue ln_employ lncardmon lncardten lncreddebt
lnequipmon lnequipten lninc lnlongmon lnlongten lnothdebt lntollmon lntollten lnwiremon lnwireten pets reside
sq_age sq_card2tenure sq_cardtenure sq_debtinc sq_tenure totalcredspend
;
RUN;


/************* FACTOR ANALYSIS *************/
/**** 10 FACTORS-0.98(EIGENVALUE)-80% VARIANCE EXPLAINED *****/
proc factor data=linearreg
METHOD = PRINCIPAL SCREE MINEIGEN=0 NFACTOR = 10
ROTATE = VARIMAX REORDER;
VAR  LN_TOTALCREDSPEND commute commutetime ed hourstv ln_cars ln_carvalue ln_employ lncardmon lncardten lncreddebt
lnequipmon lnequipten lninc lnlongmon lnlongten lnothdebt lntollmon lntollten lnwiremon lnwireten pets reside
sq_age sq_card2tenure sq_cardtenure sq_debtinc sq_tenure totalcredspend;
RUN;


/******  Defining a Macro Variable for performing one way anova ********/

proc glm data=LINEARREG;
	class active addresscat agecat bfast callcard callid callwait carbought carbuy carcatvalue card card2 card2benefit
		card2fee card2tenurecat card2type cardbenefit cardfee cardtenurecat cardtype carown  cartype churn
		commutebike commutebus commutecar commutecarpool commutecat commutemotorcycle commutenonmotor commutepublic
		commuterail commutewalk confer default ebill edcat empcat equip forward gender homeown hometype inccat
		internet jobcat jobsat marital multline news owncd owndvd ownfax owngame ownipod ownpc ownpda owntv ownvcr
		pager polcontrib polparty polview reason region response_01 response_02 response_03 retire spousedcat
		telecommute tollfree townsize union voice vote wireless;
	model Ln_totalcredspend=active addresscat agecat bfast callcard callid callwait carbought carbuy carcatvalue card card2 card2benefit
		card2fee card2tenurecat card2type cardbenefit cardfee cardtenurecat cardtype carown  cartype churn
		commutebike commutebus commutecar commutecarpool commutecat commutemotorcycle commutenonmotor commutepublic
		commuterail commutewalk confer default ebill edcat empcat equip forward gender homeown hometype inccat
		internet jobcat jobsat marital multline news owncd owndvd ownfax owngame ownipod ownpc ownpda owntv ownvcr
		pager polcontrib polparty polview reason region response_01 response_02 response_03 retire spousedcat
		telecommute tollfree townsize union voice vote wireless;
quit;

PROC CONTENTS DATA=CAT VARNUM;
RUN;




%LET var1=churn;
%ANOVA


%MACRO ANOVA;
proc anova data=LINEARREG;
class &var1.;
model ln_totalcredspend=&var1.;
RUN;
%MEND


/** Certain variables with small F values **/
/**
REGION 1.96 0.0985
UNION 2.70
DEFAULT 2.28
JOBSAT 5.SOME
MARITAL 1.71
telecommute 0.7
commutebike 3.21
commutenonmotor 0.68
commutewalk 0.01
commutemotorcyle 1.43
commutecarpool 0.18
commutebus 0.73
commuterail 0.73
commutepublic 0.13
commutecar 0.81
commutecat 0.97
carbuy 1.39
carbought 0.87
cartype 1.77
active 0.07
cardfee 1.60
card2benefit 1.93
card2type 0.36
cardfee 0.25
cardbenefit 0.87
cardtype 0.02
polcontrib 5.16
polparty 0.19
polview 1.48
townsize 0.24
response_02 3.31
response_01 0.46
news 3.91
ebill 5.12
callcard 1.84
churn 2.07
 */




data linearreg;
set linearreg;
drop UNION MARITAL telecommute  commutenonmotor commutewalk commutemotorcycle 
commutecarpool commutebus commuterail commutepublic commutecar  carbuy carbought cartype active 
cardfee card2benefit card2type cardfee cardbenefit cardtype polparty polview townsize response_02 
response_01 callcard INCCAT SPOUSEDCAT;
run;

data CAT;
set CAT;
drop UNION MARITAL telecommute  commutenonmotor commutewalk commutemotorcycle 
commutecarpool commutebus commuterail commutepublic commutecar  carbuy carbought cartype active 
cardfee card2benefit card2type cardfee cardbenefit cardtype polparty polview townsize response_02 
response_01 callcard INCCAT SPOUSEDCAT;
run;




/******** CREATING DUMMY VARIABLES *************/
proc contents data=CAT varnum;
run;


data linearreg1;
set linearreg;

if region=1 then region_1=1 ; else region_1=0;
if region=2 then region_2=1;else region_2=0;
if region=3 then region_3=1;else region_3=0;
if region=4 then region_4=1; else region_4=0;

if jobcat=1 then jobcat_1=1; else jobcat_1=0;
if jobcat=2 then jobcat_2=1; else jobcat_2=0;
if jobcat=3 then jobcat_3=1; else jobcat_3=0;
if jobcat=4 then jobcat_4=1; else jobcat_4=0;
if jobcat=5 then jobcat_5=1; else jobcat_5=0;
	

if jobsat=1 then jobsat_1=1; else jobsat_1=0;
if jobsat=2 then jobsat_2=1; else jobsat_2=0;
if jobsat=3 then jobsat_3=1; else jobsat_3=0;
if jobsat=4 then jobsat_4=1; else jobsat_4=0;


if hometype=1 then hometype_single=1; else hometype_single=0;
if hometype=2 then hometype_multiple=1; else hometype_multiple=0;
if hometype=3 then hometype_townhouse=1; else hometype_townhouse=0;

if addresscat=1 then address_1=1; else address_1=0;
if addresscat=2 then address_2=1; else address_2=0;
if addresscat=3 then address_3=1; else address_3=0;
if addresscat=4 then address_4=1; else address_4=0;

if carown=1 then carown_own=1; else carown_own=0;
if carown=0 then carown_leash=1; else carown_leash=0;

/* if cartype=0 then cartype_dom=1; else cartype_dom=0; */
/* if cartype=1 then cartype_import=1;else cartype_import=0; */

if carcatvalue=1 then carcat_eco=1; else carcat_eco=0;
if carcatvalue=2 then carcat_standard=1; else carcat_standard=0;
if carcatvalue=3 then carcat_lux=1; else carcat_lux=0;

/* if carbought=0 then carbought_no=1; else carbought_no=0; */
/* if carbought=1 then carbought_yes=1; else carbought_yes=0; */

if reason=1 then reason_prices=1; else reason_prices=0;
if reason=2 then reason_conven=1; else reason_conven=0;
if reason=3 then reason_serv=1; else reason_serv=0;
if reason=4 then reason_oth=1; else reason_oth=0;
if reason=8 then reason_na=1; else reason_na=0;

if polview=1 then polview_exlib=1; else polview_exlib=0;
if polview=2 then polview_lib=1; else polview_lib=0;
if polview=3 then polview_sllib=1; else polview_sllib=0;
if polview=4 then polview_mod=1; else polview_mod=0;
if polview=5 then polview_slcon=1; else polview_slcon=0;
if polview=6 then polview_con=1; else polview_con=0;

if card=1 then card_american=1; else card_american=0; 
if card=2 then card_visa=1; else card_visa=0;
if card=3 then card_master=1; else card_master=0;
if card=4 then card_discover=1; else card_discover=0;

if card2=1 then card2_american=1 ;else card2_american=0; 
if card2=2 then card2_visa=1; else card2_visa=0;
if card2=3 then card2_master=1; else card2_master=0;
if card2=4 then card2_discover=1; else card2_discover=0;


/* if cardbenefit=1 then cardbenefit_none=1; else cardbenefit_none=0; */
/* if cardbenefit=2 then cardbenefit_cashback=1; else cardbenefit_cashback=0; */
/* if cardbenefit=3 then cardbenefit_airlinemiles=1; else cardbenefit_airlinemiles=0; */

if card2benefit=1 then card2benefit_none=1; else card2benefit_none=0;
if card2benefit=2 then card2benefit_cashback=1; else card2benefit_cashback=0;
if card2benefit=3 then card2benefit_airlinemiles=1; else card2benefit_airlinemiles=0;


if card2tenurecat=1 then card2tenurecat_1=1; else card2tenurecat_1=0;
if card2tenurecat=2 then card2tenurecat_2=1; else card2tenurecat_2=0;
if card2tenurecat=3 then card2tenurecat_3=1; else card2tenurecat_3=0;
if card2tenurecat=4 then card2tenurecat_4=1; else card2tenurecat_4=0;

if cardtenurecat=1 then cardtenurecat_1=1; else cardtenurecat_1=0;
if cardtenurecat=2 then cardtenurecat_2=1; else cardtenurecat_2=0;
if cardtenurecat=3 then cardtenurecat_3=1; else cardtenurecat_3=0;
if cardtenurecat=4 then cardtenurecat_4=1; else cardtenurecat_4=0;


/* if cardtype=1 then cardtype_none=1; else cardtype_none=0; */
/* if cardtype=2 then cardtype_gold=1; else cardtype_gold=0; */
/* if cardtype=3 then cardtype_plat=1; else cardtype_plat=0; */

/* if card2type=1 then card2type_none=1; else card2type_none=0; */
/* if card2type=2 then card2type_gold=1; else card2type_gold=0; */
/* if card2type=3 then card2type_plat=1; else card2type_plat=0; */

if internet=1 then internetdial=1; else internetdial=0;
if internet=2 then internetDSL=1; else internetDSL=0;
if internet=3 then internetcable=1; else internetcable=0;
if internet=0 then internetnone=1; else internetnone=0;


/* if commutecat=1 then commutecat_single=1; else commutecat_single=0; */
/* if commutecat=2 then commutecat_multiple=1; else commutecat_multiple=0; */
/* if commutecat=3 then commutecat_public=1; else commutecat_public=0; */
/* if commutecat=4 then commutecat_nonmot=1; else commutecat_nonmot=0; */

if agecat=1 then agecat_less18=1; else agecat_less18=0;
if agecat=2 then agecat18_24=1; else agecat18_2=0;
if agecat=3 then agecat25_34=1; else agecat25_34=0;
if agecat=4 then agecat35_49=1; else agecat35_49=0;
if agecat=5 then agecat50_64=1; else agecat50_64=0;
if agecat=6 then agecatgr65=1; else agecatgr65=0;


if edcat=1 then edcat_1=1; else edcat_1=0;
if edcat=2 then edcat_2=1; else edcat_2=0;
if edcat=3 then edcat_3=1; else edcat_3=0;
if edcat=4 then edcat_4=1; else edcat_4=0;

if empcat=1 then empcatless2=1; else empcatless2=0;
if empcat=2 then empcat2to5=1; else empcat2to5=0;
if empcat=3 then empcat6to10=1; else empcat6to10=0;
if empcat=4 then empcat11to15=1; else empcat11to15=0;
if empcat=5 then empcatmore15=1; else empcatmore15=0;

run;

/********** Dividing the data into Dev and Valid samples *************/

proc surveyselect data=linearreg1 out=linearreg2 outall samprate=0.7 seed=123; run;

data dev val;
set linearreg2;
if selected=1 then output dev;
else output val;
run;

PROC CONTENTS DATA=DEV;
RUN;


/** Iteration 1 -using all variables **/
proc reg data=dev;
model ln_totalcredspend=
empcatless2
empcat2to5
empcat6to10
empcat11to15
empcatmore15
DEFAULT
news
commutebike
churn
ebill
region_1
region_2
region_3
region_4
address_1
address_2
address_3
address_4
bfast
callid
callwait
carcat_eco
carcat_lux
carcat_standard
card2_american
card2_discover
card2_master
card2_visa
card2benefit_airlinemiles
card2benefit_cashback
card2benefit_none
/* cardbenefit_airlinemiles */
/* cardbenefit_cashback */
/* cardbenefit_none */
card2fee
card2tenurecat_1
card2tenurecat_2
card2tenurecat_3
card2tenurecat_4
/* card2type_gold */
/* card2type_none */
/* card2type_plat */
card_american
card_discover
card_master
card_visa
cardtenurecat_1
cardtenurecat_2
cardtenurecat_3
cardtenurecat_4
/* cardtype_gold */
/* cardtype_none */
/* cardtype_plat */
carown_leash
carown_own
commute
commutetime
confer
edcat_1
edcat_2
edcat_3
edcat_4
equip
forward
gender
homeown
hometype_multiple
hometype_single
hometype_townhouse
hourstv
internetDSL
internetcable
internetdial
internetnone
jobcat_1
jobcat_2
jobcat_3
jobcat_4
jobcat_5
jobsat_1
jobsat_2
jobsat_3
jobsat_4
ln_cars
ln_carvalue
ln_employ
lncardmon
lncardten
lncreddebt
lnequipmon
lnequipten
lninc
lnlongmon
lnlongten
lnothdebt
lntollmon
lntollten
lnwiremon
lnwireten
multline
owncd
owndvd
ownfax
owngame
ownipod
ownpc
ownpda
owntv
ownvcr
pager
pets
reason_conven
reason_na
reason_oth
reason_prices
reason_serv
reside
response_03
retire
agecat_less18
agecat18_2
agecat25_34
agecat35_49
agecat50_64
agecatgr65
/* sq_card2tenure */
/* sq_cardtenure */
sq_debtinc
sq_tenure
tollfree
voice
vote
wireless/SELECTION=STEPWISE VIF STB;
output out=dev1 cookd=cd;
run;

/*** Removing influential obs ***/

data dev2;
set dev1;
if cd<(4/3496);
run;


/*** Iteration 2 ***/
proc reg data=dev2;
model ln_totalcredspend=
empcatless2
empcat2to5
empcat6to10
empcat11to15
empcatmore15
DEFAULT
news
commutebike
churn
ebill
region_1
region_2
region_3
region_4
address_1
address_2
address_3
address_4
bfast
callid
callwait
carcat_eco
carcat_lux
carcat_standard
card2_american
card2_discover
card2_master
card2_visa
card2benefit_airlinemiles
card2benefit_cashback
card2benefit_none
/* cardbenefit_airlinemiles */
/* cardbenefit_cashback */
/* cardbenefit_none */
card2fee
card2tenurecat_1
card2tenurecat_2
card2tenurecat_3
card2tenurecat_4
/* card2type_gold */
/* card2type_none */
/* card2type_plat */
card_american
card_discover
card_master
card_visa
cardtenurecat_1
cardtenurecat_2
cardtenurecat_3
cardtenurecat_4
/* cardtype_gold */
/* cardtype_none */
/* cardtype_plat */
carown_leash
carown_own
commute
commutetime
confer
edcat_1
edcat_2
edcat_3
edcat_4
equip
forward
gender
homeown
hometype_multiple
hometype_single
hometype_townhouse
hourstv
internetDSL
internetcable
internetdial
internetnone
jobcat_1
jobcat_2
jobcat_3
jobcat_4
jobcat_5
jobsat_1
jobsat_2
jobsat_3
jobsat_4
ln_cars
ln_carvalue
ln_employ
lncardmon
lncardten
lncreddebt
lnequipmon
lnequipten
lninc
lnlongmon
lnlongten
lnothdebt
lntollmon
lntollten
lnwiremon
lnwireten
multline
owncd
owndvd
ownfax
owngame
ownipod
ownpc
ownpda
owntv
ownvcr
pager
pets
reason_conven
reason_na
reason_oth
reason_prices
reason_serv
reside
response_03
retire
agecat_less18
agecat18_2
agecat25_34
agecat35_49
agecat50_64
agecatgr65
/* sq_card2tenure */
/* sq_cardtenure */
sq_debtinc
sq_tenure
tollfree
voice
vote
wireless/selection=stepwise VIF STB;
/* output out=dev3 cookd=cd; */
run;


/********* PREDICTION ON DEVELOPMENT SAMPLE *********/
data dev3;
set dev;
ln_prespend=(4.70917+(commutebike*-0.09609)+(region_1*-0.06239)+(region_3*-0.0443)+(card2_american*0.3326)+
			(card2_discover*-0.05615)+(card2benefit_airlinemiles*-0.02822)+(card2tenurecat_2*-0.05079)+
			(card_american*0.53552)+(card_discover*-0.08873)+(cardtenurecat_2*0.08256)+(carown_own*0.04656)+
			(edcat_4*-0.05468)+(gender*-0.04185)+(internetdial*-0.04616)+(jobcat_1*0.04772)+(jobsat_1*0.05658)+
			(jobsat_4*0.05018)+(lninc*0.30521)+(owndvd*0.0562)+(pager*-0.03476)+(reason_conven*0.21467)+
			(reason_oth*-0.11794)+(reason_prices*-0.1332)+(reason_serv*-0.11811)+(reside*0.012)+(response_03*0.05805));
pretotspend=exp(ln_prespend);
run;	


proc rank data=dev3 out=dev4 ties=low 
 descending groups=10; 
 var Pretotspend; 
 ranks Decile; 
run; 


proc means data=dev4 ;  
 class Decile; 
 var totalcredspend pretotspend; 
 output out=report 
 mean=actualavg predicted_avg
 sum=totalcredspend;
run; 

proc export file=report outfile='/folders/myfolders/dev.xls' dbms=xls replace;
run;


		
/********* PREDICTION ON VALIDATION SAMPLE *********/

data val1;
set val;
ln_prespend=(4.70917+(commutebike*-0.09609)+(region_1*-0.06239)+(region_3*-0.0443)+(card2_american*0.3326)+
			(card2_discover*-0.05615)+(card2benefit_airlinemiles*-0.02822)+(card2tenurecat_2*-0.05079)+
			(card_american*0.53552)+(card_discover*-0.08873)+(cardtenurecat_2*0.08256)+(carown_own*0.04656)+
			(edcat_4*-0.05468)+(gender*-0.04185)+(internetdial*-0.04616)+(jobcat_1*0.04772)+(jobsat_1*0.05658)+
			(jobsat_4*0.05018)+(lninc*0.30521)+(owndvd*0.0562)+(pager*-0.03476)+(reason_conven*0.21467)+
			(reason_oth*-0.11794)+(reason_prices*-0.1332)+(reason_serv*-0.11811)+(reside*0.012)+(response_03*0.05805));
pretotspend=exp(ln_prespend);
run;	



proc rank data=val1 out=val2 ties=low 
 descending groups=10; 
 var Pretotspend; 
 ranks Decile; 
run; 


proc means data=val2 ;  
 class Decile; 
 var totalcredspend pretotspend; 
 output out=report 
 mean=actualavg predicted_avg
 sum=totalcredspend;
run; 

proc export file=report outfile='/folders/myfolders/val.xls' dbms=xls replace;
run;


