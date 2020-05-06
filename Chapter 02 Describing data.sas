***Chapter 02 Describing data;
data htwt;
	input subject gender $ height weight;
datalines;
1 M 68.5 155
2 F 61.2  99
3 F 63.0 115
4 M 70.0 205
5 M 68.6 170
6 F 65.1 125
7 M 72.4 220
;
proc means data = htwt;
	title 'Simple descriptive statistics';
run;

proc means data = htwt n mean maxdec = 3;
	title 'simple descriptive statistics';
	var height;
run;

*** univariate;
proc univariate data = htwt normal plot;
	title 'more descriptive statistics';
	var height weight;
	id subject;
run; 

proc univariate data = htwt normal plot;
	title 'more descriptive statistics';
	var height weight;
run; 

*** broken down by subgroups;
proc sort data = htwt;
	by gender;
run;

proc means data = htwt n mean std maxdec = 2;
	by gender; 
	var height weight;
run;

*** use 'class' not 'by' get one table !;
proc means data = htwt n mean std maxdec = 2;
	class gender; 
	var height weight;
run;

*** frequency tables;
data htwt;
	input subject gender $ height weight;
datalines;
1 M 68.5 155
2 F 61.2  99
3 F 63.0 115
4 M 70.0 205
5 M 68.6 170
6 F 65.1 125
7 M 72.4 220
;
proc freq data=htwt;
	title 'using proc freq to compute frequencies';
	tables gender / nocum nopercent;
run;

proc chart data = htwt;
	title 'distribution of heights';
	vbar gender;
run;

proc plot data = htwt;
	plot weight*height;
run;

DATA HTWT;                     
   INPUT SUBJECT GENDER $ HEIGHT WEIGHT;
DATALINES;
1 M 68.5 155
2 F 61.2  99
3 F 63.0 115
4 M 70.0 205
5 M 68.6 170
6 F 65.1 125
7 M 72.4 220
;
PROC SORT DATA=HTWT;
   BY GENDER;
RUN;

PROC PLOT DATA=HTWT;
   BY GENDER;
   PLOT WEIGHT*HEIGHT;
RUN;

PROC PLOT DATA = HTWT;
	PLOT WEIGHT*HEIGHT = GENDER;
RUN;

PROC PLOT DATA = HTWT;
	PLOT WEIGHT*HEIGHT = '*';
RUN;

*** SUMMARY DATA SETS
DATA SCHOOL;
	LENGTH GENDER $ 1 TEACHER $ 5;
	INPUT SUBJECT GENDER $ TEACHER $ T_AGE PRETEST POSTTEST;
	GAIN = POSTTEST - PRETEST;
DATALINES;
   1        M      JONES      35      67        81
   2        F      JONES      35      98        86
   3        M      JONES      35      52        92
   4        M      BLACK      42      41        74
   5        F      BLACK      42      46        76
   6        M      SMITH      68      38        80
   7        M      SMITH      68      49        71
   8        F      SMITH      68      38        63
   9        M      HAYES      23      71        72
  10        F      HAYES      23      46        92
  11        M      HAYES      23      70        90
  12        F      WONG       47      49        64
  13        M      WONG       47      50        63
;

PROC MEANS DATA = SCHOOL N MEAN STD MAXDEC = 2;
	CLASS TEACHER;
	TITLE 'Means scores for each teacher';
	VAR PRETEST POSTTEST GAIN;
RUN;

*** PRODUCE A NEW DATA SET 'TEACHSUM';
PROC MEANS DATA=SCHOOL NOPRINT NWAY;
	CLASS TEACHER;
	VAR PRETEST POSTTEST GAIN;
	OUTPUT OUT = TEACHSUM
		   MEAN = M_PRE M_POST M_GAIN;
RUN;

PROC PRINT DATA = TEACHSUM;
	TITLE 'Listing of Data Set Teachsum';
RUN;

*** add ID t_age here;
PROC MEANS DATA = SCHOOL NOPRINT NWAY;
	CLASS TEACHER;
	ID T_AGE;
	VAR PRETEST POSTTEST GAIN;
	OUTPUT = OUT=TEACHSUM
			MEAN = M_PRE M_POST M_GAIN;
RUN;

PROC PRINT DATA = TEACHSUM;
	TITLE 'Listing of Data Set Teachsum';
RUN;

data demog;
	length gender $ 1 region $5;
	input subj gender $ region $ height weight;
datalines;
01  M  North  70  200
02  M  North  72  220
03  M  South  68  155
04  M  South  74  210
05  F  North  68  130
06  F  North  63  110
07  F  South  65  140
08  F  South  64  108
09  F  South   .  220
10  F  South  67  130
;

proc means data=demog n mean std maxdec=2;
	title 'Output from proc means';
	class gender region;
	var height weight;
run;

***output a new dataset;
proc means data=demog noprint;
	class gender region;
	var height weight;
	output out=summary
		   mean = M_height M_weight;
run; 

*** print out the 'summary' dataset;
proc print data = summary;
	title 'Listing of data set summary';
run;

***output a new dataset with nway option;
proc means data=demog noprint nway;
	class gender region;
	var height weight;
	output out=summary
		   mean = M_height M_weight;
run; 

*** print out the 'summary' dataset;
proc print data = summary;
	title 'Listing of data set summary with nway option';
run;

***output a new dataset with nway option;
proc means data=demog noprint nway;
	class gender region;
	var height weight;
	output out=summary
		   n = N_height N_weight
		   mean = M_height M_weight;
run; 

*** print out the 'summary' dataset;
proc print data = summary;
	title1 'Listing of data set summary with nway option';
	title2 'with requeses for N= and MEAN=';
run;

proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out=summary(drop=type_)
		   N=N_height N_weight
		   mean = M_height M_weight;
run;

proc print data = summary;
	title1 'Listing of data set summary with nway option';
	title2 'with drop type_';
run;

*** lazy way;
proc means data=demog noprint nway;
	class gender region;
	var height weight;
	output out=summary(drop=_type_)
			mean=;
run;
proc print data = summary;
	title1 'Listing of data set summary with nway option';
	title2 'with drop type_';
	title3 'lazy way';
run;

*** output stats other than means ***;
proc means data=demog noprint nway;
	class gender region;
	var height weight;
	output out=stats
		   mean = M_height M_weight
		   std = S_height S_weight 
		   max = Max_height Max_weight;
run;

proc print data=stats;
	title 'more stats';
run;

*** sorted by groups *** ;
proc sort data=demog;
	by gender region;
run;

*** data summary with a median ***;
proc univariate data = demog noprint;
	by gender region;
	var height weight;
	output out=sum
		   n      = N_ht N_wt
		   median = Med_ht Med_wt
		   mean   = Mean_ht Mean_wt;
run;

proc print data=sum;
	title 'listing of data set sum';
run;
