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
* survey to determine which chemicals are sensitive to people *;
PROC FORMAT;
	VALUE SYMPTOM	1 = 'ALCOHOL'
					2 = 'INK'
					3 = 'SULPHUR'
					4 = 'IRON'
					5 = 'TIN'
					6 = 'COPPER'
					7 = 'DDT'
					8 = 'CARBON'
					9 = 'SO2'
					10 = 'NO2';
RUN;

DATA SENSI;
	INPUT ID 1-4 (CHEM1-CHEM10) (1.);
	ARRAY CHEM(*)	CHEM1-CHEM10;
	DO I = 1 TO 10;
		IF CHEM[I] = 1 THEN DO;
			SYMPTOM = I;
			OUTPUT;
		END;
	END;
	KEEP ID SYMPTOM;
	FORMAT SYMPTOM SYMPTOM.;
DATALINES;
00011010101010
00021000010000
00031100000000
00041001001111
00051000010010
;
PROC PRINT DATA=SENSI;
RUN;

PROC FREQ DATA=SENSI ORDER=FREQ;
	TABLES SYMPTOM / NOCUM;
RUN;

*** H. COMPUTING A MOVING AVERAGE *** ;
* average over a window of period *;
DATA MOVING;
	INPUT COST @@;
	DAY + 1;
	COST1 = LOG(COST);
	COST2 = LOG2(COST);
	IF _N_ GE 3 THEN DO;
		MOV_AVG = MEAN(COST, COST1, COST2);
		OUTPUT;
	END;
	DROP COST1 COST2;
DATALINES;
1 2 3 4 . 6 8 12 8
;
PROC PRINT DATA = MOVING NOOBS;
	TITLE 'moving average - 3 points';
run;

DATA NEVER;
	INPUT X @@;
	IF X GT 3 THEN X_LAG = LAG(X);
DATALINES;
5 7 2 1 4
;
PROC PRINT DATA = NEVER NOOBS;
	TITLE 'never do it like this';
run;

*** I. soring within an observation *** ;
DATA SORT;
	INPUT L1-L5;
	ARRAY S[5];
	DO I = 1 TO 5;
		S[I] = ORDINAL(I, OF L1-L5);
	END;
	DROP I L1-L5;
DATALINES;
5 2 9 1 3
6 . 22 7 0
;

PROC PRINT DATA = SORT NOOBS;
	TITLE 'SORT WITHIN';
RUN;


*** J. computing coefficient alpha in a data step *** ;
DATA SCORE;
	ARRAY ANS[5] $ 1 ANS1-ANS5; *** student answers;
	ARRAY KEY[5] $ 1 KEY1-KEY5; *** answer key;
	ARRAY S[5] 3 S1-S5; *** score array 1 = right, 0 = wrong;
	RETAIN KEY1-KEY5;
	*** read the answer key;
	IF _N_ = 1 THEN INPUT (KEY1-KEY5)($1.);
	*** read student's answer;
	INPUT 	@1 ID 1-9
			@11 (ANS1-ANS5) ($1.);
	*** score the test;
	DO I = 1 TO 5;
		S[I] = (KEY[I] EQ ANS[I]);
	END;
	*** compute raw and percentile scores;
	RAW = SUM(OF S1-S5);
	PERCENT = 100*RAW / 5;
	KEEP ID RAW PERCENT S1-S5;
	LABEL ID		= 'SSN'
		  RAW		= 'RAW SCORE'
		  PERCENT	= 'PERCENT SCORE';
DATALINES;
ABCDE
123456789 ABCDE
035469871 BBBBB
111222333 ABCBE
212121212 CCCDE
867564733 ABCDA
876543211 DADDE
987876765 ABEEE
;
PROC PRINT DATA=SCORE;
RUN;

PROC MEANS DATA=SCORE;
	VAR S1-S5 RAW;
	OUTPUT OUT=VAROUT
		   VAR=VS1-VS5 VRAW;
	TITLE '';
RUN;
DATA _NULL_ ;
	FILE PRINT;
	SET VAROUT;
	SUMVAR = SUM(OF VS1-VS5);
	KR20 = (5/4)*(1-SUMVAR/VRAW);
	PUT KR20=;
RUN;

*** USE MICRO *** ;
* CALL ME FUNCTION PLELASE *;
%MACRO KR20(DSN, N, RAW, ARRAY);
	PROC MEANS NOPRINT DATA=&DSN;
	VAR &ARRAY.1 - &ARRAY&N &RAW;
	OUTPUT OUT=VAROUT
			VAR=VS1-VS&N VRAW;
	RUN;
	DATA _NULL_;
		FILE PRINT;
		SET VAROUT;
		SUMVAR = SUM(OF VS1-VS5);
		KR20 = (&N/%EVAL(&N -1))*(1-SUMVAR/VRAW);
		PUT KR20=;
	RUN;
%MEND KR20;

%KR20(SCORE, 5, RAW, S)
