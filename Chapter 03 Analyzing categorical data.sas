*** Chapter 3 Analyzing categorical data *** ;

*** A Introduction *** ;

*** B Questionaire design and analysis;

data quest;
	input id 1-3 age 4-5 gender $ 6 race $ 7 marital $ 8 educ $ 9 
		  pres 10 arms 11 cities 12;

datalines;
001091111232
002452222422
003351324442
004271111121
005682132333
006651243425
;

proc means data = quest maxdec=2 n mean std;
	title 'questionare analysis';
	var age;
run;

proc freq data = quest;
	title 'freqency couts for categorical variables';
	tables gender race marital educ pres arms cities;
run;

*** C Adding variable labels *** ;
data quest;
	input id 		$ 1-3
		  age     	  4-5
		  gender 	$   6
		  race		$   7 
		  marital	$   8 
		  educatoin	$   9 
		  president    10
		  arms		   11 
		  cities       12 

label marital    = "marital status"
	  education  = "education level" 
	  president  = "president doing a good job" 
	  arms       = "arms budget increase" 
	  cities     = "federal aid to cities" ;

datalines;
001091111232
002452222422
003351324442
004271111121
005682132333
006651243425
; 

proc means data = quest maxdec = 2 n mean std;
	title 'questionare analysis';
	var age;
run;

proc freq data = quest;
	title 'frequency counts for categorical variables';
	tables gender race marital educ pres arms cities;
run;

*** D Adding value lables or formats *** ;
proc print data = quest;
run;
/* it is all digits */

proc format;
	value	$sexfmt		'1' = 'Male'  '2' = 'Female';
	value	$race		'1' = 'White' 
						'2' = 'African Am.'  
						'3' = 'Hispanic'
						'4' = 'Other';
	value 	$oscar		'1' = 'single' 
						'2' = 'married'  
						'3' = 'widowed'
						'4' = 'divorced';
	value 	$education	'1' = 'high sch or less'  
						'2' = 'two-year college'
						'3' = 'four-year college'
						'4' = 'graduate degree';
	value 	likert		1 = 'strong disagree'
						2 = 'disagree'
						3 = 'neutral'
						4 = 'agree'
						5 = 'strong agree'
run;

data quest;
	input id 		$ 1-3
		  age     	  4-5
		  gender 	$   6
		  race		$   7 
		  marital	$   8 
		  education	$   9 
		  president    10
		  arms		   11 
		  cities       12; 

label marital    = "marital status"
	  education  = "education level" 
	  president  = "president doing a good job" 
	  arms       = "arms budget increase" 
	  cities     = "federal aid to cities" ;

format  gender	$sexfmt.
		race	$race.
		marital	$oscar.
		education $ $educ.
		president arms cities likert.;

datalines;
001091111232
002452222422
003351324442
004271111121
005682132333
006651243425
; 

proc means data = quest maxdec = 2 n mean std clm;
	title 'questionare analysis';
	var age;
run;

proc freq data = quest;
	title 'frequency couts for categorical variables';
	tables gender race marital education
			president arms cities;
run;

*** take a look at the table with formatting *** ;
proc print data = quest;
run;

*** E recoding data *** ;
proc format;
	value	$sexfmt		'1' = 'Male'  '2' = 'Female';
	value	$race		'1' = 'White' 
						'2' = 'African Am.'  
						'3' = 'Hispanic'
						'4' = 'Other';
	value 	$oscar		'1' = 'single' 
						'2' = 'married'  
						'3' = 'widowed'
						'4' = 'divorced';
	value 	$education	'1' = 'high sch or less'  
						'2' = 'two-year college'
						'3' = 'four-year college'
						'4' = 'graduate degree';
	value 	likert		1 = 'strong disagree'
						2 = 'disagree'
						3 = 'neutral'
						4 = 'agree'
						5 = 'strong agree';
	value 	agefmt		1 = '0-20'
						2 = '21-40'
						3 = '41-60'
						4 = 'greater than 60';
run;

data quest;
	input id 		$ 1-3
		  age     	  4-5
		  gender 	$   6
		  race		$   7 
		  marital	$   8 
		  education	$   9 
		  president    10
		  arms		   11 
		  cities       12; 
	if 0 <= age <= 20 then agegrp = 1;
	if 20 <=age <= 40 then agegrp = 2;
	if 40 < age <= 60 then agegrp = 3;
	if age > 60 then       agegrp = 4;

  label marital    = "marital status"
	  	education  = "education level" 
	  	president  = "president doing a good job" 
	  	arms       = "arms budget increase" 
	  	cities     = "federal aid to cities" 
		agegrp 	   = "age group";

format  gender	$sexfmt.
		race	$race.
		marital	$oscar.
		education $ $educ.
		president arms cities likert.
		agegrp agefmt.;

datalines;
001091111232
002452222422
003351324442
004271111121
005682132333
006651243425
; 

proc freq data = quest;
	tables gender -- agegrp;
run;

*** F Using a format to recode a variable *** ;
proc format;
	value agroup low-20  = '0-20'
				 21-40   = '21-40'
				 41-60   = '41-60'
				 61-high = 'greater than 60';
run;


*** G two-way freqency tables ***;


*** H a shortcut way to request multiple tables ***;
proc freq data = quest;
	tables (president arms cities)*agegrp;
run;


*** I computing chi-square from frequency counts *** ;
data chisq1;
	input group $ outcome $ count;
datalines;
	drug alive 90 
	drug dead 10
	placebo alive 80 
	placebo dead 20 
;

proc freq data = chisq1;
	tables group*outcome / chisq;
	weight count;
run;

*** J. a useful program for multiple chi-square tables *** ;

data chisq;
	n + 1;
	do row = 1 to 2;
		do col = 1 to 2;
			input count @;
			output;
		end;
	end;
datalines;
3 5 8 6
10 20 30 40
;

proc freq data = chisq;
	by n;
	tables row*col / chisq;
	weight count;
run;

*** K. a useful macro for computing chi-square from freqency counts ***;

%macro chisq(a, b, c, d, options = chisq);
	data chisq;
		array cells[2,2] _temporary_ (&A &B &C &D);
		do row = 1 to 2;
			do col = 1 to 2;
				count = cells(row, col);
				output;
			end;
		end;
	run;
	proc freq data = chisq;
		tables row*col / &options;
		weight count;
	run;
%mend chisq;

%chisq(10,20,30,40)

*** L. Mcnemar's test for paired data *** ;
proc format;
	value $opinion 'p' = 'positive'
				   'n' = 'negative';
run;

data mcnemar;
	length after before $ 1;
	input after $ before $ count;
	format before after $opinion.;
datalines;
N N 32 
N P 30 
P N 15 
P P 23
;
proc freq data = mcnemar;
	title "macnemar's test for paired samples";
	tables before*after / agree;
	weight count;
run;

*** M. computing the kappa statistics - coef of agreement ***;
data x_ray;
	input radiologist_1 $ radiologist_2 $ count;
datalines;
No No 25 
No Yes 3 
Yes No 5 
Yes Yes 50 
;

proc freq data = x_ray;
	title 'computing coefficient kappa for two observers';
	tables radiologist_1 * radiologist_2 / agree;
	weight count;
run;

*** N. odds ratio *** ;
data odds;
	input outcome $ exposure $ count;
datalines;
case 1-yes 50
case 2-no 100 
control 1-yes 20 
control 2-no 130 
;
proc freq data = odds;
	title 'program to compute an odds ratio';
	tables exposure*outcome / chisq cmh;
	weight count;
run;

*** O. relative risk *** ;
data rr;
	length group $ 9;
	input group $ outcome $ count;
datalines;
high-chol mi 20 
high-chol no-mi 80 
low-chol mi 15 
low-chol no-mi 135 
;
proc freq data = rr;
	title 'program to compute a relative risk';
	tables group*outcome / cmh;
	weight count;
run;

*** P. chi-square test for trend *** ;
data trend;
	input result $ group $ count @@;
datalines;
fail a 10 fail b 15 fail c 14 fail d 25
pass a 90 pass b 85 pass c 86 pass d 75
;

proc freq data = trend;
	title 'chi-square test for trend';
	tables result*group /chisq;
	weight count;
run;

*** Q. mantel-haenszel chi-square for stratified tables 
and meta-analysis ***;

data ability;
	input gender $ results $ sleep $ count;
datalines;
BOYS FAIL 1-LOW 20    
BOYS FAIL 2-HIGH 15  
BOYS PASS 1-LOW 100
BOYS PASS 2-HIGH 150  
GIRLS FAIL 1-LOW 30  
GIRLS FAIL 2-HIGH 25
GIRLS PASS 1-LOW 100  
GIRLS PASS 2-HIGH 200
;
proc freq data = ability;
	title 'mantel-haenszel chi-square test';
	tables gender*sleep*results /all;
	weight count;
run;


*** R. check all that apply *** ;

DATA DIAG1;
   INPUT ID 1-3 DX1 DX2 DX3;
DATALINES;
1      3       4       .
2      1       3       7
3      5       .       .
;

proc freq data=diag1;
	tables dx1 - dx3;
run;

data diag2;
	set diag1;
	dx = dx1;
	if dx ne . then output;
	dx = dx2;
	if dx ne . then output;
	dx = dx3;
	if dx ne . then output;
	keep id dx;
run;

proc print data = diag2;
	title ' ';
run;

data diag3;
	set diag1;
	array d[*] dx1-dx3;
	do i = 1 to 3;
		dx = d[i];
		if d[i] ne . then output;
	end; 
	keep id dx;
run;

proc print data = diag3;
	title ' ';
run;







