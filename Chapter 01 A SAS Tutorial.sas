*** Applided statistics and the SAS programming language
*** Chapter 1 A SAS Tutorial;
* A Introduction 
data test;
	input subject 1-2 gender $ 4 exam1 6-8 exam2 10-12 
	hwgrade $ 14;

datalines;
10 M  80  84 A
 7 M  85  89 A
 4 F  90  86 B
20 M  82  85 B
25 F  94  94 A
14 F  88  84 C
;
proc means data = test;
run; 

proc means data = test;
	var exam1 exam2;
run; 
*** don't use ',' between them, use space;
proc means data = test n mean std stderr maxdec = 1;
	var exam1 exam2;
run;

data example;
	input subject gender $ exam1 exam2
	hwgrade $;
final = (exam1 + exam2) / 2;
if final GE 0 and final LT 65 then grade = 'f';
else if final GE 65 and final LT 75 then grade = 'c';
else if final ge 75 and final lt 85 then grade = 'b';
else if final ge 85 then grade = 'a'; 

datalines;
10 M  80  84 A
 7 M  85  89 A
 4 F  90  86 B
20 M  82  85 B
25 F  94  94 A
14 F  88  84 C
;
proc sort data = example;
	by subject;
run;

*** sorted by subject number;
proc print data = example;
	title 'Roster in Student Number Order';
	id subject;
	var exam1 exam2 final hwgrade grade;
run;

*** Descriptive Statistics;
proc means data = example n mean std stderr maxdec = 1;
	title 'Descriptive Statistics';
	var exam1 exam2 final;
run;

*** freqency table;
proc freq data = example;
	tables gender hwgrade grade;
run;

*** sort by gender and subject;
proc sort data = example;
	by gender subject;
run;

proc print data = example;
	id subject;
	title 'Roster in student number order';
	var exam1 exam2 final hwgrade grade;
run;

proc means data = example N mean std maxdec = 1;
run;

proc means data = example n mean std maxdec = 1;
	title 'descriptive statistics on exam scores';
	var exam1 exam2;
run;

*** how to select options;
proc freq data = example;
	tables gender hwgrade grade / nocum;
run;

proc freq data = example order = freq;
	tables gender hwgrade grade / nocum;
run; 

*** ref 'http://ftp.sas.com/samples/A55984';
