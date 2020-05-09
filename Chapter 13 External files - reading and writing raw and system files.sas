*** Chapter 13 External files: reading and writing raw and system files ***;
*** A. introduction ***;
*** B. data in the program itself ***;
data ex1;
	input group $ x y z;
datalines;
CONTROL 12 17 19
TREAT 23 25 29
CONTROL 19 18 16
TREAT 22 22 29
;
proc means data = ex1 n mean std stderr maxdec=2;
	title 'means for each group';
	class group;
	var x y z;
run;

* not reading correctly *;
data test;
	input author $10. title $40.;
datalines;
SMITH    The Use of the   in Writing
FIELD    Commentary on Smith's Book
;

* not reading correctly * ;
data test;
	input author $10. title $40.;
datalines4;
SMITH The Use of the ; in Writing
FIELD Commentary on Smith's Book
;;;;
proc print data = test;
run;

*** C. reading data from an external text file *** ;
data ex2a;
	infile 'Documents\My SAS Files\AS_SAS\data\mydata.dta';
	input group $ x y z;
run;
proc means data = ex2a n mean std stderr maxdec=2;
	var x y z;
run;

* use filename to nickname the file path * ;
data ex2b;
	filename dataminer 'Documents\My SAS Files\AS_SAS\data\mydata.dta';
	infile dataminer;
	input group $ x y z;
run;
proc means data = ex2a n mean std stderr maxdec=2;
	var x y z;
	title 'nickname of input file';
run;

*** D. infile options *** ;
data ex2e;
	if testend ne 1 then infile 'Documents\My SAS Files\AS_SAS\data\mydata.dta' end=testend;
	else infile 'Documents\My SAS Files\AS_SAS\data\mydata2.dta';
	input group $ x y z;
run;

proc means data = ex2e n mean std stderr maxdec=2;
	var x y z;
	title 'infile options END';
run;

* option missover * ;
data ex2f;
	infile 'Documents\My SAS Files\AS_SAS\data\mymissover.dta' missover;
	input group $ x y z;
run;
proc means data = ex2f n mean std stderr maxdec=2;
	var x y z;
	title 'infile option with missover';
run;

* option PAD * ;
data ex2g;
	infile 'Documents\My SAS Files\AS_SAS\data\mypad.txt' pad;
	input group $ 1
		  x 2-3
		  y 4-5
		  z 6-7;
run;
proc means data = ex2g n mean std stderr maxdec=2;
	var x y z;
	title 'infile option with pad';
run;
proc print data = ex2g;
run;

*** E. reading data from multiple files ***;
/*
data read_many;
	filename dataminer2 ('Documents\My SAS Files\AS_SAS\data\mymissover.dta' 'Documents\My SAS Files\AS_SAS\data\mydata.dta');
	infile dataminer2 missover;
	input x y z;
run;
*/

*** F. writing ascii or raw data to an external file *** ;
data ex3a;
	infile 'Documents\My SAS Files\AS_SAS\data\mydata.dta';
	input group $ x y z;
	total = sum(of x y z);
	put group $ 1-7 @11 (x y z total) (5.);
run;

proc print data = ex3a;
run;

*** G. writing csv file using sas *** ;
options missing = " ";
data comma_delimited;
	input name $ x y z;
datalines;
CODY 1 2 3
SMITH 4 5 6
MISS . 8 9
;

ods listing close;
ods csv file = 'Documents\My SAS Files\AS_SAS\data\mycsvdata.csv';
proc print data = comma_delimited noobs;
	title;
run;
ods csv close;
ods listing;

*** H. creating a permanent SAS data set *** ;
libname miner 'Documents\My SAS Files\AS_SAS\data';
data miner.ex4a;
	input group $ x y z;
datalines;
CONTROL 12 17 19
TREAT 23 25 29
CONTROL 19 18 16
TREAT 22 22 29
;
/*
proc print data = ex4a.sas7bdat noobs;
	title;
run;
*/

*** I. reading permanent SAS data sets *** ;
libname abc 'Documents\My SAS Files\AS_SAS\data';
proc means data = abc.ex4a n mean std stderr maxdec=3;
	var x y z;
run;

*** J. how to determine the contents of a SAS data set *** ;
libname sugi 'Documents\My SAS Files\AS_SAS\data';
proc contents data = sugi.ex4a varnum;
	title "demonstrating PROC contents";
run;

*** K. permanent SAS data sets with formats *** ;
libname felix 'Documents\My SAS Files\AS_SAS\data';
options fmtsearch = (felix);
proc format library = felix;
	value $xgroup 'treat' = 'treatment group'
				  'control' = 'control group';
run;

data felix.ex4a;
	input group $ x y z;
	format group $xgroup.;
datalines;
CONTROL 12 17 19
TREAT 23 25 29
CONTROL 19 18 16
TREAT 22 22 29
;

* read a permanent SAS data set with formats *** ;
libname C 'Documents\My SAS Files\AS_SAS\data';
options fmtsearch = (C);
proc print data = c.ex4a;
run;

*** L. working with large data sets *** ;

* 1 don't read unecessary file *;
* 2 drop all unnecessary variables *;
* 3 use drop or keep option *;
* 4 don't sort if not necessary * ;
* 5 use class instead of 'by; * ;
* 6 use where statement * ;
* 7 where statement in proc *;
* 8 else if - instead of if if .. * ;
* 9 when use if, place first the one most likely to be true *;
* 10 save summary stats in a sas file for later use * ;
* 11 use __null__ when you don't want to keep the data set * ;
* 12 as data as sas data file, more efficient * ;
* 13 use option 'obs=n' ;
* 14 proc datasets , when do rename... * ;
* 15 proc append , when adding a new data set * ;
/* this rule of thumbs need to verify when in use * /
