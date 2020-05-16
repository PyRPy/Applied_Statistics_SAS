*** Chapter 17 A review of SAS functions - other than char func *** ;
*** A. introduction *** ;
*** B. Arithmetic and mathematical functions *** ;
data func_eg;
	input id sex $ los height weight;
	loglos = log(los);
datalines;
1 M 5 68 155
2 F 100 62 98
3 M 20 72 220
;
proc print data = func_eg;
run;

data easyway;
	input (x1-x100)(2.);
	if n(of x1-x100) ge 75 then
	ave = mean(of x1-x100);
datalines;
;
*** C. random number functions *** ;
data shuffle;
	input name : $20. ;
	x = ranuni(0);
datalines;
CODY
SMITH
MARTIN
LAVERY
THAYER
;
proc sort data = shuffle;
	by x;
run;
proc print data = shuffle;
	title 'names in random order';
	var name;
run;

*** D. time and date functions *** ;
DATA DATES;
   INPUT ID 1-3 MONTH 4-5 DAY 10-11 YEAR 79-80;
   DATE = MDY(MONTH,DAY,YEAR);
   DROP MONTH DAY YEAR;
   FORMAT DATE MMDDYY8.;
DATALINES;

;

PROC FORMAT;
   VALUE DAYWK 1='SUN' 2='MON' 3='TUE' 4='WED' 5='THU'
               6='FRI' 7='SAT';
   VALUE MONTH 1='JAN' 2='FEB' 3='MAR' 4='APR' 5='MAY' 6='JUN'
               7='JUL' 8='AUG' 9='SEP' 10='OCT' 11='NOV' 12='DEC';
RUN;

DATA HOSP;
   INPUT @1 ADMIT MMDDYY6. etc. ;
   DAY = WEEKDAY(ADMIT);
   MONTH = MONTH(ADMIT);
   FORMAT ADMIT MMDDYY8. DAY DAYWK. MONTH MONTH.;
DATALINES;

;
PROC CHART DATA=HOSP;
   VBAR DAY / DISCRETE;
   VBAR MONTH / DISCRETE;
RUN;

*** E. input and put functions: converting numeric to char, and char to numeric ***;
proc format;
	value agegrp low-20='1' 21-40='2' 41-60='3' 61-high = '4';
run;

data puteg;
	input age @@;
	age4 = put (age, agegrp.);
datalines;
5 10 15 20 25 30 66 68 99
;

proc print data = puteg;
run;

data freeform;
	input test $ @@;
	retain group;
	if test = 'a' or test = 'b' then do;
		group = test;
		delete;
		return;
	end;
	
	else score = input(test, 5.);
	drop test;
datalines;
A 45 55 B 87 A 44 23 B 88 99
;
proc print data = freeform noobs;
	title 'listing of data set freeform';
run;
* somehow not working above *;

*** F. lag and dif function *** ;
data lageg;
	set orig;
	diff = x - lag(x);
	if time = 2 then output;
run;
