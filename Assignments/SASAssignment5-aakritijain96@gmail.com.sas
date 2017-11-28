/***********************        SAS ASSIGNMENT 5        *****************************/ 
/*********************** E-MAIL ID: aakritijain96@gmail.com*****************************/
/************************** BATCH-27TH AUGUST **************************************/

/****************************** QUESTION 1 **************************************/

libname class1 '/folders/myfolders/file_data';

data grocery_coupons;
set class1.grocery_coupons;
year_cur=intck('year',couponexpiry,today());
month_cur=intck('month',couponexpiry,today());
date_cur=intck('day',couponexpiry,today());
year_march=intck('year',couponexpiry, '31Mar14'd);
month_march=intck('month',couponexpiry, '31Mar14'd);
date_march=intck('day',couponexpiry, '31Mar14'd);
run;

/****************************** QUESTION 2 **************************************/
data grocery_coupons1;
set class1.grocery_coupons;
coupon_issuance_date=intnx('month',couponexpiry,-3,'s');
format coupon_issuance_date date8.;
run;

/****************************** QUESTION 3 **************************************/
data grocery_coupons2;
set class1.grocery_coupons;
no_of_days=datdif(couponexpiry,'30Sep14'd,30/360);
run;

/****************************** QUESTION 4 **************************************/
data ques4;
set class1.grocery_coupons;
int_val=int(amtspent);
round_val=round(amtspent,1);
margin=sum(round_val)-sum(int_val);
run;

proc means data=ques4 sum;
var int_val round_val margin;
run;                            /**Clearly, since the sum of round amount is more, therefore rounding off the**/
                                /**amtspent to nearest int value would be more profitable by 667rs.**/
                               
                               
                               
/****************************** QUESTION 5,6,7 **************************************/
data department;
set class1.department;
last_name=scan(name,1,',');
start_pos=index(name,',')+2;
first_name=substr(name,start_pos,length(scan(name,2,','))-3);
run;                      
                               
