/************************** SAS ASSIGNMENT 3************************************/



libname class1 '/folders/myfolders/file_data';

/**************                 QUESTION 1                          ********************/

proc freq data=class1.car_sales;

data car_sales;
set class1.car_sales;
length orgc $8;
select(Manufacturer);
when ('Acura','Honda') orgc='Japan';
when ('Audi','BMW') orgc='Germany';
when ('Buick', 'Cadillac', 'Chevrolet','Chrysler','Dodge') orgc=' United States';
otherwise orgc='Others';
end;
run;


/**************                 QUESTION 2                         ********************/

data car_sales;
length id $ 30;
set class1.car_sales;
ID=Manufacturer || Model;              /**To concatenate**/ 
ID=compbl(ID);                        /**Using compbl function to remove extra spaces**/
run;

/****************                 QUESTION 3                          ********************/

data car_sales1(keep=ID manufacturer model latest_launch _4_year_resale_value price_in_thousands sales_in_thousands) car_sales2(drop=manufacturer model latest_launch _4_year_resale_value price_in_thousands sales_in_thousands);
set car_sales;
run;



/**************                 QUESTION 4                          ********************/

data hyundai;
input manufacturer $ model $ sales_in_thousands _4_year_resale_value latest_launch date8.;
format latest_launch date8.;
cards;
Hyundai Tuscon 19.919 16.36 2Feb12
Hyundai i45 39.384 19.875 3Jun11
Hyundai Verna 14.114 18.225 4Jan12
Hyundai Terracan 8.588 29.725 10Mar11
;
run;

data hyundai;              /*Adding the ID column in Hyundai Data set*/
length ID $ 30;
set hyundai;
ID= Manufacturer || Model;
ID=compbl(ID);
run;



/**************                 QUESTION 5                          ********************/
data total_sales;
set car_sales1 hyundai;
run;


/**************                 QUESTION 6                          ********************/

proc sort data=car_sales2;
by ID;
run;

proc sort data=total_sales;
by ID;
run;



data new_car_sales;
merge car_sales2 total_sales;
by  ID;
run;


/**************                 QUESTION 7                          ********************/
data new_car_sales2;
merge car_sales2(in=x) total_sales(in=y);
by ID;
if x=1 and y=1;
run;
