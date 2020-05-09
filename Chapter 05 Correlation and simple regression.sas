*** Chapter 05 Correlation and simple regression *** :
*** A. introduction *** ;
*** B. correlation *** ;
DATA CORR_EG;
	INPUT GENDER $ HEIGHT WEIGHT AGE;
	height2 = height**2;
DATALINES;
M 68 155 23
F 61  99 20
F 63 115 21
M 70 205 45
M 69 170  .
F 65 125 30
M 72 220 48
;
PROC CORR DATA = CORR_EG;
	TITLE "Example of a correlation matrix";
	VAR HEIGHT WEIGHT AGE;
RUN;

PROC CORR DATA = CORR_EG PEARSON SPEARMAN NOSIMPLE;
	TITLE "Example of a correlation matrix";
	VAR HEIGHT WEIGHT AGE;
RUN;

/* NO DATA FOR THIS CODE

PROC CORR DATA = RESULTS;
	VAR IQ GPA;
	WITH TEST1-TEST10;
RUN;
*/

*** C. significance of a correlation coefficient *** ;
*** D. how to interpret a correlation coefficient *** ;
*** E. partial correlation *** ;

PROC CORR DATA = CORR_EG NOSIMPLE;
	TITLE "Example of a partia correlation";
	VAR HEIGHT WEIGHT;
	PARTIAL AGE;
RUN;

*** F. linear regression *** ;
PROC REG DATA = CORR_EG;
	TITLE 'REGRESSOIN LINE FOR HEIGHT-WEIGHT DATA';
	MODEL WEIGHT = HEIGHT;
RUN;

*** G. PARTITIONING THE TOTAL SUM OF SQUARES *** ;
/*
F = mean square model / mean square error 
*/

*** H. producing a scatter plot and the regression line *** ;
PROC GPLOT DATA = CORR_EG;
	PLOT WEIGHT*HEIGHT;
RUN;

SYMBOL VALUE=DOT COLOR=BLACK;
PROC GPLOT DATA = CORR_EG;
	PLOT WEIGHT*HEIGHT;
RUN;

SYMBOL1 VALUE=DOT COLOR=BLACK;
PROC REG DATA=CORR_EG;
	TITLE 'REGRESSION AND RESIDUAL PLOTS';
	MODEL WEIGHT = HEIGHT;
	PLOT WEIGHT * HEIGHT
		RESIDUAL. * HEIGHT;
RUN;
QUIT;

GOPTIONS CSYMBOL=BLACK;
SYMBOL1 VALUE = DOT;
SYMBOL2 VALUE=NONE I = RLCLM95;
SYMBOL3 VALUE = NONE; I = RLCLI95 LINE=3;
PROC GPLOT DATA=CORR_EG;
	TITLE 'REGRESSION LINE WITH 95% CI';
	PLOT WEIGHT * HEIGHT = 1 
		 WEIGHT * HEIGHT = 2 
		 WEIGHT * HEIGHT = 3 /OVERLAY;
RUN;
QUIT;

*** I. adding a quadratic term to the regression equation *** ;
symbol value=dot color=black;
proc reg data=corr_eg;
	model weight = height height2;
	plot r. *height;
	*** r. is for residual;
run;

*** J. transforming data ***;
data heart;
	input dose hr @@;
datalines;
2 60 2 58 4 63 4 62 8 67 8 65 16 70 16 70 32 74 32 73
;
symbol value=dot color=black i=sm;
proc gplot data=heart;
	plot hr*dose;
run;

proc reg data = heart;
	model hr = dose;
run;

* log transformation * ;
data heart;
	input dose hr @@;
	ldose = log(dose);
	label ldose = "log of dose";
datalines;
2 60 2 58 4 63 4 62 8 67 8 65 16 70 16 70 32 74 32 73
;

proc reg data = heart;
	title 'log dose';
	model hr = ldose;
run;

symbol value=dot;
proc gplot data=heart;
	plot hr*ldose;
run;
