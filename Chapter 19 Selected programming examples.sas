*** Chapter 19 Selected programming examples *** ;
*** A. indrocution *** ;
*** B. expressing data values as a percentage of the grand mean ***;
data test;
	input hr sbp dbp;
datalines;
80 160 100
70 150 90
60 140 80
;
proc means data = test;
	var hr sbp dbp;
	output out = mout(drop=_type_ _freq_)
		mean = M_hr M_sbp M_dbp;
run;

data new;
	set test;
	if _n_ = 1 then set mout;
	hrper = 100*hr/M_hr;
	sbpper = 100 * sbp / M_sbp;
	dbpper = 100 * dbp / M_dbp;
	drop M_hr M_sbp M_dbp;
run;

proc print data = new noobs;
	title 'listing of data set new';
run;

*** C. expressing a value as a percentage of a group mean *** ;
data test;
	input group $ hr sbp dbp @@;
datalines;
A 80 160 100 A 70 150 90 A 60 140 80 
B 90 200 180 B 80 180 140 B 70 140 80
;

proc sort data = test;
	by group;
run;

proc means data = test noprint nway;
	class group;
	var hr sbp dbp;
	output out = mout(drop = _type_ _freq_)
			mean = mhr msbp mdbp;
run;

data new (drop = mhr msbp mdbp);
	merge test mout;
		by group;
	hrper = 100*hr/mhr;
	sbpper = 100*sbp/msbp;
	dbpper = 100*dbp/mdbp;
run;

proc print data = new noobs;
	title 'group mean per cent';
run;

*** D. plotting means iwth error bars *** ;
data orig;
	input subj time dbp sbp;
datalines;
1 1 70 120
1 2 80 130
1 3 84 136
2 1 82 132
2 2 84 138
2 3 92 144
;
symbol1 value=none i = stdimt color=black line=1 width=2;
proc gplot data=orig;
	title 'plot of mean with error bars';
	footnote justify=left height=1
		'bars represent plus and minus one sd';
	plot (sbp dbp)*(time);
run; quit;
* not 100% right *;
PROC MEANS DATA=ORIG NOPRINT NWAY;
   CLASS TIME;
   VAR SBP DBP;
   OUTPUT OUT=MEANOUT MEAN= STDERR=SE_SBP SE_DBP;
RUN;

DATA TMP;
   SET MEANOUT;
   SBPHI=SBP+SE_SBP;
   SBPLO=SBP-SE_SBP;
   DBPHI=DBP+SE_DBP;
   DBPLO=DBP-SE_DBP;
RUN;

PROC PLOT DATA=TMP;
   PLOT SBP*TIME='o' SBPHI*TIME='-' SBPLO*TIME='-' / OVERLAY BOX;
   PLOT DBP*TIME='o' DBPHI*TIME='-' DBPLO*TIME='-' / OVERLAY BOX;
   TITLE 'Plot of Mean Blood Pressures at Each Time';
   TITLE2 'Error bars represent +- 1 standard error';
RUN;

*** E. using a macro variable to save coding time ***;
DATA TEST;
   %LET LIST=ONE TWO THREE;
   INPUT &LIST FOUR;
DATALINES;
1 2 3 4
4 5 6 6
;
PROC FREQ DATA=TEST;
   title '';
   TABLES &LIST;
RUN;  
*** F. computing reltative frequencies ***;
DATA ICD;
   INPUT ID YEAR ICD;
DATALINES;
001 1950 450
002 1950 440
003 1951 460
004 1950 450
005 1951 300
;
PROC FREQ DATA=ICD;
   TABLES YEAR*ICD / OUT=ICDFREQ NOPRINT;
   ***Data set ICDFREQ contains the counts 
   for each CODE in each YEAR;
RUN;

PROC FREQ DATA=ICD;
   TABLES YEAR / OUT=TOTAL;
   ***Data set ICD contains the total number 
   of obs for each YEAR;
RUN;

*** G. computing combined freq on different variables *** ;
