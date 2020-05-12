*** Chapter 07 Analysis of varaince *** ;
*** A. introduction *** ;
*** B. one-way analysis of variance *** ;
data reading;
	input group $ words @@;
datalines;
X 700   X 850   X 820   X 640   X 920
Y 480   Y 460   Y 500   Y 570   Y 580
Z 500   Z 550   Z 480   Z 600   Z 610
;
proc anova data = reading;
	title "analysis of reading data";
	class group;
	model words = group;
	means group;
run;

proc anova data = reading;
	title "analysis of reading data";
	class group;
	model words = group;
	means group / snk;
run;

*** C. computing contrasts *** ;
/* four rules for the coefficients:
	1. sum is zero
	2. match alpha order of levels
	3. zero means not included
	4. negativ sign vs positive sign for contrast !
*/
proc glm data = reading;
	title "analysis of reading data - planned comparisons";
	class group;
	model words = group;
	contrast 'x vs. y and z' group -2 1 1;
	contrast 'method y vs z' group 0 1 -1;
run;

*** D. analysis of variance: two independent variables *** ;
* factorial design * ;
* balanced desgin , anova, unbalanced, use glm * ;
data twoway;
	input	group $ gender $ words @@;
datalines;
X M 700  X M 850  X M 820  X M 640  X M 920
Y M 480  Y M 460  Y M 500  Y M 570  Y M 580
Z M 500  Z M 550  Z M 480  Z M 600  Z M 610
X F 900  X F 880  X F 899  X F 780  X F 899
Y F 590  Y F 540  Y F 560  Y F 570  Y F 555
Z F 520  Z F 660  Z F 525  Z F 610  Z F 645
;
* | means it includes interaction term * ;
proc anova data = twoway;
	title "analysis of reading data";
	class group gender;
	model words = group | gender;
	means group | gender / snk;
run;

*** E. interpreting significant interactions *** ;
data ritalin;
	do group = 'normal', 'hyper';
		do drug = 'placebo', 'ritalin';
			do subj = 1 to 4;
				input activity @;
				output;
			end;
		end;
	end;
datalines;
50 45 55 52  67 60 58 65  70 72 68 75  51 57 48 55
;
proc print data = ritalin;
run;

proc anova data = ritalin;
	title "acitivty study";
	class group drug;
	model activity = group | drug;
	means group | drug;
run;

proc means data = ritalin nway noprint;
	class group drug;
	var activity;
	output out = means mean = M_hr;
run;

symbol1 v=square color=black i=join;
symbol2 v=circle color=black i=join;
proc gplot data=means;
	title 'interaction plot';
	plot M_hr * drug = group;
run;

proc sort data = ritalin;
	by group;
run;
proc ttest data = ritalin;
	title "drug comparison for each group separately";
	by group;
	class drug;
	var activity;
run;
* not working here *;
proc anova data = ritalin;
	title 'one-way anova ritalin study';
	*condition = group || drug;
	class condition;
	model activity = condition;
	means condition / snk;
run;

proc glm data = ritalin;
	title 'contrast using glm';
	class group drug;
	model activity = group | drug /ss3;
	contrast 'hyperactive only' drug 1 -1 group*drug 1 -1 0 0;
	contrast 'normals only' drug 1 -1 group*drug 0 0 1 -1;
run;

* condition somehow missing * ;
PROC GLM DATA=RITALIN;
   TITLE 'One-way ANOVA Ritalin Study';
   CLASS COND;
   MODEL ACTIVITY = COND;
   CONTRAST 'Hyperactive only' COND 1 -1 0 0;
   CONTRAST 'Normals only'     COND 0 0 1 -1;
RUN;

*** F. n-way factorial designs *** ;

*** G. unbalanced design : proc glm *** ;
data puddings;
	input sweeet flavor $ rating @@;
datalines;
1 V 9  1 V 7  1 V 8  1 V 7
2 V 8  2 V 7  2 V 8
3 V 6  3 V 5  3 V 7
1 C 9  1 C 9  1 C 7  1 C 7  1 C 8
2 C 8  2 C 7  2 C 6  2 C 8
3 C 4  3 C 5  3 C 6  3 C 4  3 C 4
;
proc print data = puddings;
run;
data pudding;
	length flavor $ 9;
	input flavor $ sweet rating @@;
datalines;
VANILLA 1 9
VANILLA 1 7
VANILLA 1 8
VANILLA 1 7
CHOCOLATE 1 9
CHOCOLATE 1 9
CHOCOLATE 1 7
CHOCOLATE 1 7
CHOCOLATE 1 8

VANILLA 2 8
VANILLA 2 7
VANILLA 2 8

VANILLA 3 6
VANILLA 3 5
VANILLA 3 7
CHOCOLATE 2 8
CHOCOLATE 2 7
CHOCOLATE 2 6
CHOCOLATE 2 8

CHOCOLATE 3 4
CHOCOLATE 3 5
CHOCOLATE 3 6
CHOCOLATE 3 4
CHOCOLATE 3 4
;

proc print data = pudding;
run;

proc glm data = pudding;
	title 'pudding taste evaluation';
	title3 'two-way anova - unbalanced';
	title4 '---------------------------------';
	class sweet flavor;
	model rating = sweet | flavor /ss3;
	lsmeans sweet | flavor / pdiff adjust=tukey;
run;

*** H. analysis of covariance *** ;
data covar;
	length group $ 1;
	input group math iq @@;
datalines;
A 260 105  A 325 115  A 300 122  A 400 125  A 390 138
B 325 126  B 440 135  B 425 142  B 500 140  B 600 160
;
proc corr data = covar nosimple;
	title 'covariate example';
	var math iq;
run;

proc ttest data = covar;
	class group;
	var iq math;
run;

proc glm data = covar;
	class group;
	model math = iq group iq*group /ss3;
run;

proc glm data = covar;
	class group;
	model math = iq group / ss3;
	lsmeans group;
run;
