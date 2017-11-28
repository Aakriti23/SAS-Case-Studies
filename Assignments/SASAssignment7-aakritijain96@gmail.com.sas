/****************** SAS Assignment 7-Macros**************************/
/******************* QUESTION 1  ************************************/


libname class1 '/folders/myfolders/file_data';

data models;
input Name $ T_or_R $ price Material $;
datalines;
Black Track 796 Aluminum
Delta Road 399 CroMoly
Jet Track 1130 CroMoly
Mistral Road 1995 Carbon
Noreaster Mountain 899 Aluminum
Santa Mountain 459 Aluminum
Scirocco Mountain 2256 Titanium
Trade Road 759 Aluminum
;
run;

%let dataset = models;
%let sortvar= price;
%let dispsortvar=price;
%let ascdesc=ascending;

%put &dataset;
%put &sortvar;
%put &ascdesc;

%macro print;

proc sort data=&dataset.;
by &sortvar.;
run;

proc print data=&dataset.;
title "Sorted by &dispsortvar. &ascdesc.";
run;

%mend;

%print


/***************************** QUESTION 2************************************/

proc import datafile='/folders/myfolders/file_data/Assignments/Datasets/SAS Assignment 7/Orders.txt' out=class1.orders dbms=txt replace;
delimiter= " ";
run;

if %put &sysday='Tuesday' then  1;

data class1.orders;
infile datalines dlm=",";
length model $20.;
input custid date date7. model $ no_of_orders;
format date date7.;
datalines;
287,15OCT03,Delta Breeze,15
287,15OCT03,Santa Ana,15
274,16OCT03,Jet Stream,1
174,17OCT03,Santa Ana,20
174,17OCT03,Noreaster,5
174,17OCT03,Scirocco,1
347,18OCT03,Mistral,1
287,21OCT03,Delta Breeze,30
287,21OCT03,Santa Ana,25
;
run;


%macro friday;

proc sort data=class1.orders;
by custid;
run;

proc report data=class1.orders;
by custid;
run;

%mend;
 
%macro monday;
proc print data=class1.orders;
var custid, date, no_of_orders;
run;
%mend;


%macro notmonfri;
proc print data=class1.orders;
run;
%mend;

%let day=&sysday;
%put &day;


%macro question2;

data orders;
set class1.orders;
%if &day.='Friday' %then %friday;
%if &day.='Monday' %then %monday;
%else %notmonfri;

run;

%mend;

%question2;



/************************ QUESTION 5 ****************************************/

%macro question5(a,b);
proc freq data= class1.car_sales;
table &a.*&b./crosslist ;
run;
%mend;


%question5(Model,Manufacturer);



%macro question5_1(avar1=,bvar2=);
proc freq data= class1.car_sales;
table &avar1*&bvar2/crosslist ;
run;
%mend;


%question5_1(avar1=Model,bvar2=Manufacturer);





