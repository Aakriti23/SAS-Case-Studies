/***************** Business Analytics Case Study-1 ******************/
/***************** E-mail- aakritijain96@gmail.com *****************/


/***************** IMPORTING THE FILE ****************************/
libname class '/folders/myfolders/del';

proc import datafile="/folders/myfolders/del/CCGENERAL.csv" out=customers dbms=csv replace;
guessingrows=10000;
run;

proc contents data=customers;
run;

/************* MISSING VALUE TREATMENT *******************/


/*There are 313 missing values in the "Minimum Payment" variable & one missing value in creditlimit.*/
/** Imputing missing values with mean **/
proc means data=customers nmiss mean;
run;


data customers;
set customers;
if minimum_payments=. then minimum_payments=864.2065423;
if credit_limit=. then credit_limit=4494.45;
run;



/*************** Deriving Key Performance Indicators ***********************/
data customers;
set customers;
monthly_avg_pur=purchases/12;
monthly_cash_adv=cash_advance/12;
avgamtperpurchase=(purchases/purchases_frequency)*12;
avgamtpercashadv=(cash_advance/cash_advance_frequency)*12;
limitusage=balance/credit_limit;
paymenttominpayment=payments/minimum_payments;
run;


data customers;
length purchase_type $20.;
set customers;

if ONEOFF_PURCHASES=0 & INSTALLMENTS_PURCHASES=0 then purchase_type = 'None' ;
if ONEOFF_PURCHASES>0 & INSTALLMENTS_PURCHASES=0 then purchase_type = 'One_Of';
if ONEOFF_PURCHASES=0 & INSTALLMENTS_PURCHASES>0 then purchase_type = 'Installment_Purchases';
if ONEOFF_PURCHASES>0 & INSTALLMENTS_PURCHASES>0 then purchase_type = 'Both';
run;


/************ Treating missing values in derived KPI's **************/
PROC MEANS DATA=CUSTOMERS NMISS MEAN;
RUN;

DATA CUSTOMERS;
SET CUSTOMERS;
IF avgamtperpurchase=. THEN avgamtperpurchase=25616.51;
IF avgamtpercashadv=. THEN avgamtpercashadv=95949.49;
RUN;

/******************** Factor analysis *****************************/
/******* PCA and scree plot show that the ideal number of factors would be 7
with Eigenvalue of 	0.99529791 & cumulative variance of 0.7615 *************************/


proc factor data=customers
method= Principal scree mineigen=0 nfactor=7 rotate=varimax reorder ;
var

BALANCE
BALANCE_FREQUENCY
CASH_ADVANCE
CASH_ADVANCE_FREQUENCY
CASH_ADVANCE_TRX
CREDIT_LIMIT
INSTALLMENTS_PURCHASES
MINIMUM_PAYMENTS
ONEOFF_PURCHASES
ONEOFF_PURCHASES_FREQUENCY
PAYMENTS
PRC_FULL_PAYMENT
PURCHASES
PURCHASES_FREQUENCY
PURCHASES_INSTALLMENTS_FREQUENCY
PURCHASES_TRX
TENURE
avgamtpercashadv
avgamtperpurchase
limitusage
monthly_avg_pur
monthly_cash_adv
paymenttominpayment
;
run;





/**************** OUTLIER TREATMENT *********************/
/*** Using Mean+3STD method for outlier treatment ***/

ODS HTML FILE='/folders/myfolders/BACS1.XLS';
PROC MEANS DATA=CUSTOMERS N NMISS MEAN STD MIN P5 P10 P25 P50 P75 P90 P95 P99 MAX;
RUN;
ODS HTML CLOSE;

DATA CUSTOMERS;
SET CUSTOMERS;
Valid_obs2=1;
if BALANCE>5727.53 or
PURCHASES>5276.46 or
ONEOFF_PURCHASES>3912.2173709 or
INSTALLMENTS_PURCHASES>2219.7438751 or
CASH_ADVANCE>5173.1911125 or
CASH_ADVANCE_FREQUENCY>0.535387 or
CASH_ADVANCE_TRX>16.8981202 or
PURCHASES_TRX>64.4251306 or
CREDIT_LIMIT>11771.67 or
PAYMENTS>7523.26 or
MINIMUM_PAYMENTS>5525.3865423 then 
Valid_obs2=0;

Valid_obs3=1;
if BALANCE>7809.06 or
PURCHASES>7413.09 or
ONEOFF_PURCHASES>5572.1073709 or
INSTALLMENTS_PURCHASES>3124.0819903 or
CASH_ADVANCE>7270.3511125 or
CASH_ADVANCE_FREQUENCY>0.7355084 or
CASH_ADVANCE_TRX>23.7227669 or
PURCHASES_TRX>89.2827797 or
CREDIT_LIMIT>15410.28 or
PAYMENTS>10418.32 or
MINIMUM_PAYMENTS>7855.9765423 then
Valid_obs3=0;

valid_obs95p=1;
if BALANCE>5911.51 or
PURCHASES>3999.92 or
ONEOFF_PURCHASES>2675 or
INSTALLMENTS_PURCHASES>1753.08 or
CASH_ADVANCE>4653.69 or
CASH_ADVANCE_FREQUENCY>0.583333 or
CASH_ADVANCE_TRX>15 or
PURCHASES_TRX>57 or
CREDIT_LIMIT>12000 or
PAYMENTS>6083.43 or
MINIMUM_PAYMENTS>2722.22 then
valid_obs95p=0;
RUN;

proc freq data=customers;
table valid_obs2 valid_obs3 valid_obs95p;
run;

/******************** Creating dummy variables **********************/

data cluster;
set customers;
Z_PURCHASES=PURCHASES;
Z_ONEOFF_PURCHASES=ONEOFF_PURCHASES;
Z_PAYMENTS=PAYMENTS;
Z_CASH_ADVANCE_FREQUENCY=CASH_ADVANCE_FREQUENCY;
Z_CASH_ADVANCE=CASH_ADVANCE;
Z_PURCHASES_INSTALLMENTS_FREQ=PURCHASES_INSTALLMENTS_FREQUENCY;
Z_PURCHASES_FREQUENCY=PURCHASES_FREQUENCY;
Z_INSTALLMENTS_PURCHASES=INSTALLMENTS_PURCHASES;
Z_PRC_FULL_PAYMENT=PRC_FULL_PAYMENT;
Z_BALANCE=BALANCE;
Z_ONEOFF_PURCHASES_FREQUENCY=ONEOFF_PURCHASES_FREQUENCY;
Z_CREDIT_LIMIT=CREDIT_LIMIT;
where valid_obs3=1;
run;


/****************** Standarizing our data ******************/
proc standard data=cluster mean=0 std=1 out=cluster;
var
Z_PURCHASES
Z_ONEOFF_PURCHASES
Z_PAYMENTS
Z_CASH_ADVANCE_FREQUENCY
Z_CASH_ADVANCE
Z_PURCHASES_INSTALLMENTS_FREQ
Z_PURCHASES_FREQUENCY
Z_INSTALLMENTS_PURCHASES
Z_PRC_FULL_PAYMENT
Z_BALANCE
Z_ONEOFF_PURCHASES_FREQUENCY
Z_CREDIT_LIMIT

;
run;


/*************** Creating 3, 4 , 5 and 6 cluster-segmentation ***********************/
proc fastclus data=cluster out=cluster maxclusters=3 cluster=clus_3 maxiter=100 ;
var Z_PURCHASES
Z_ONEOFF_PURCHASES
Z_PAYMENTS
Z_CASH_ADVANCE_FREQUENCY
Z_CASH_ADVANCE
Z_PURCHASES_INSTALLMENTS_FREQ
Z_PURCHASES_FREQUENCY
Z_INSTALLMENTS_PURCHASES
Z_PRC_FULL_PAYMENT
Z_BALANCE
Z_ONEOFF_PURCHASES_FREQUENCY
Z_CREDIT_LIMIT
;
run;

proc fastclus data=cluster out=cluster maxclusters=4 cluster=clus_4 maxiter=100 ;
var Z_PURCHASES
Z_ONEOFF_PURCHASES
Z_PAYMENTS
Z_CASH_ADVANCE_FREQUENCY
Z_CASH_ADVANCE
Z_PURCHASES_INSTALLMENTS_FREQ
Z_PURCHASES_FREQUENCY
Z_INSTALLMENTS_PURCHASES
Z_PRC_FULL_PAYMENT
Z_BALANCE
Z_ONEOFF_PURCHASES_FREQUENCY
Z_CREDIT_LIMIT
;
run;

proc fastclus data=cluster out=cluster maxclusters=5 cluster=clus_5 maxiter=100 ;
var Z_PURCHASES
Z_ONEOFF_PURCHASES
Z_PAYMENTS
Z_CASH_ADVANCE_FREQUENCY
Z_CASH_ADVANCE
Z_PURCHASES_INSTALLMENTS_FREQ
Z_PURCHASES_FREQUENCY
Z_INSTALLMENTS_PURCHASES
Z_PRC_FULL_PAYMENT
Z_BALANCE
Z_ONEOFF_PURCHASES_FREQUENCY
Z_CREDIT_LIMIT
;
run;

proc fastclus data=cluster out=cluster maxclusters=6 cluster=clus_6 maxiter=100 ;
var Z_PURCHASES
Z_ONEOFF_PURCHASES
Z_PAYMENTS
Z_CASH_ADVANCE_FREQUENCY
Z_CASH_ADVANCE
Z_PURCHASES_INSTALLMENTS_FREQ
Z_PURCHASES_FREQUENCY
Z_INSTALLMENTS_PURCHASES
Z_PRC_FULL_PAYMENT
Z_BALANCE
Z_ONEOFF_PURCHASES_FREQUENCY
Z_CREDIT_LIMIT
;
run;

proc freq data=cluster;
table clus_3 clus_4 clus_5 clus_6  ;
run;

proc tabulate data=cluster;
 var PURCHASES
ONEOFF_PURCHASES
PAYMENTS
CASH_ADVANCE_FREQUENCY
CASH_ADVANCE
PURCHASES_INSTALLMENTS_FREQUENCY
PURCHASES_FREQUENCY
INSTALLMENTS_PURCHASES
PRC_FULL_PAYMENT
BALANCE
ONEOFF_PURCHASES_FREQUENCY
CREDIT_LIMIT

;
class  clus_3 clus_4 clus_5 clus_6;
table (PURCHASES
ONEOFF_PURCHASES
PAYMENTS
CASH_ADVANCE_FREQUENCY
CASH_ADVANCE
PURCHASES_INSTALLMENTS_FREQUENCY
PURCHASES_FREQUENCY
INSTALLMENTS_PURCHASES
PRC_FULL_PAYMENT
BALANCE
ONEOFF_PURCHASES_FREQUENCY
CREDIT_LIMIT)*mean, clus_3 clus_4 clus_5 clus_6 All;
run;
