*** Chapter 10 Factor analysis *** ;
*** A. introduction *** ;
* features reduction ? * ;
*** B. type of factor analysis *** ;
*** C. principle component analysis *** ;
proc format;
	value likert 
	1 = 'v. strong dis.'
	2 = 'strongly dis.'
	3 = 'disagree'
	4 = 'no opinion'
	5 = 'agree'
	6 = 'strongly agree'
	7 = 'v. strong agree';
run;

data factor;
	input subj 1-2 @3(ques1-ques6)(1.);
	label ques1 = 'feel blue'
		  ques2 = 'people stare at me'
		  ques3 = 'peopel follow me' 
		  ques4 = 'basically happy'
		  ques5 = 'people want to hurt me'
		  ques6 = 'enjoy going to parties';
datalines;
 1723456
 2632132
 3367363
 4222534
 5342423
 6634232
 7123722
 8332343
 9211625
10623222
11354233
12676262
13511262
14211615
15121717
;
proc factor data = factor preplot plot rotate=varimax 
 			nfactors = 2 out = fact scree;
	title 'example of factor analysis';
	var ques1-ques6;
run;

*** D. oblique rotations *** ;
proc factor data = factor rotate = promax nfactors = 2;
	title 'example of factor analysis - oblique rotation';
	var ques1-ques6;
run;

*** E. using cummunalities other than one ***;
proc factor data = factor preplot plot rotate = varimax
			nfactors = 2 out = fact scree;
	title 'example factor analysis';
	var ques1-ques6;
	priors smc;
run;

*** F. how to reverse item scores *** ;
 
data factor2;
	input subj 1-2 @3(ques1-ques6)(1.);
	ques4 = 8 - ques4;
	ques6 = 8 - ques6;

	label ques1 = 'feel blue'
		  ques2 = 'people stare at me'
		  ques3 = 'peopel follow me' 
		  ques4 = 'basically happy'
		  ques5 = 'people want to hurt me'
		  ques6 = 'enjoy going to parties';
	format ques1-ques6 likert;
datalines;
 1723456
 2632132
 3367363
 4222534
 5342423
 6634232
 7123722
 8332343
 9211625
10623222
11354233
12676262
13511262
14211615
15121717
;

proc print data = factor2 noobs;
	title 'output data';
	title2 'question 4, 6 reversed';
run;
