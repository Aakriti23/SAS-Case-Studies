/*SAS ASSIGNMENT-1*/
/* E-mail id- aakritijain96@gmail.com*/


libname class1 '/folders/myfolders/file_data';

/*Question 1*/
proc import datafile='/folders/myfolders/file_data/car_sales.csv' out=class1.car_sales dbms=csv ; /*Importing the csv data file*/
run;

/*Question 2*/
data car_sales;                              /*Output SAS file to be created in the work library.*/
set class1.car_sales;                       /*Input SAS data file to be used.*/
if _4_year_resale_value=. OR price_in_thousands=. then delete; 
run;

/*Question 3*/

Data cars1 cars2 cars3 cars4 cars5;                    /*Create five SAS data sets.*/
set class1.car_sales;
if price_in_thousands<=15 then output cars1;           /* Condition for SAS data set 1*/
if 15<price_in_thousands<20 then output cars2;        /* Condition for SAS data set 2*/
if 20<price_in_thousands<=30 then output cars3;      /* Condition for SAS data set 3*/
if 30<price_in_thousands<=40 then output cars4;     /* Condition for SAS data set 4*/
if price_in_thousands>40 then output cars5;        /* Condition for SAS data set 5*/
run;

/*Question 4*/

data car_sales;
set class1.car_sales;
keep Manufacturer Model price_in_thousands sales_in_thousands;   /* Keep only four columns and drop the rest.*/
run;


/*Question 5*/
data car_sales;
set class1.car_sales;
where vehicle_type='Passenger' and latest_launch>'01-Oct-14'd; 
run;


