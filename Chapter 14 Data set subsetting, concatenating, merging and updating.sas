*** Chapter 14 Data set subsetting, concatenating, merging and updating ***;
*** A. introduction *** ;
*** B. subsetting *** ;
/*
data women;
	set all;
	if gender = 'f';
run;
*/


/* older women
data oldwomen;
	set all;
	if gender = 'f' and age > 65;
run;
*/

/* older women
data oldwomen;
	set all;
	where gender = 'f' and age > 65 ;
run;
*/

/* proc freq
proc freq data = all;
	where gender = 'f';
	tables race income;
run;
*/

/* proc ttest
proc ttest data = data_set_name;
	where group = 'a' or group = 'b';
	class group;
	var variable-list;
run;
*/

/* where group in ('a' 'b')
proc ttest data = data_set_name;
	where group in ('a' 'b');
	class group;
	var variable-list;
run;
*/

*** C. combining similar data from multiple sas data sets *** ;
/*
data alldata;
	set men women;
run;
*/

*** D. combining different data from multiple sas data set *** ;

data master;
	input ss $ 1-11
	name $;
datalines;
123-45-6789 CODY
987-65-4321 SMITH
111-22-3333 GREGORY         
222-33-4444 HAMER
777-66-5555 CHAMBLISS
;

data test;
	input ss $ 1-11
	score;
datalines;
123-45-6789 100
987-65-4321 67              
222-33-4444 92
;

proc print data = master;
run;

proc sort data = master;
	by ss;
run;

proc sort data = test;
	by ss;
run;

data both;
	merge master test;
	by ss;
	*format ss ssn11.;
run;

proc print data = both;
run;

data both;
	merge master test (in=frodo);
	by ss;
	if frodo;
	*format ss ssn11.;
run;

proc print data = both;
run;

*** E. table look up *** ;
data worker;
	input id year wbc;
datalines;
1 1940 6000
2 1940 8000
3 1940 9000       
1 1941 6500
2 1941 8500
3 1941 8900
;

data exp;
	input year exposure;
datalines;
1940 200
1941 150
1942 100
1943 80
;

proc sort data=worker;
	by year;
run;
proc sort data = exp;
	by year;
run;
data combine;
	merge worker (in=inwork) exp;
	by year;
	if inwork;
run;

proc print data = combine;
run;

*** F. updating a master data set from an update data set *** ;
data main;
	input part_no price;
datalines;
   1      19
   4      23
   6      22
   7      45
;

data updates;
	input part_no price;
datalines;
   4      24             
   5      37
   7       .
;

data newmain;
	update main updates;
		by part_no;
run;

proc print data = newmain;
run;
