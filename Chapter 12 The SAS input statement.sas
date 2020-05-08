*** Chapter 12 The SAS input statement ***;

*** A. introduction ***;
*** B. list input: data values separated by spaces ***;

data quest;
	input id gender $ age height weight;
datalines;
1 M 23 68 155
2 F . 61 102
3   M  55  70     202
;

proc print data = quest;
run;

*** C. reading comma-delimited data *** ;
data htwt;
	infile 'Documents\My SAS Files\AS_SAS\data\survey.dta' dlm = ',';
	input id gender $ age height weight;
run;

proc print data = htwt;
run;

data htwt2;
	infile 'Documents\My SAS Files\AS_SAS\data\survey2.dta' dsd;
	input id gender $ age height weight;
run;

proc print data = htwt2;
run;

*** D. using informats with list input *** ;
*** you can see why people don't like SAS anymore ***;

data inform;
	informat dob visit mmddyy8.;
	input id dob visit dx;
datalines;
1 10/21/46 6/5/89 256.20
2 9/15/44 4/23/89 232.0
;

proc print data = inform;
run;

data form;
	input id dob: mmddyy8. visit: mmddyy8. dx;
datalines;
1 10/21/46 6/5/89 256.20
2 9/15/44 4/23/89 232.0
;

proc print data = form;
run;

* example with an informat statement * ;
data longname;
	informat last $ 20.;
	input id last score;
datalines;
1 STEVENSON 89
2 CODY 100
3 SMITH 55
4 GETTLEFINGER 92
;
proc print data = longname;
run;

* example with input informats;
data longname;
	input id last : $20. score;
datalines;
1 STEVENSON 89
2 CODY 100
3 SMITH 55
4 GETTLEFINGER 92
;

proc print data = longname;
run;

data firstlist;
	input id name & $30. score1 score2;
datalines;
1 RON CODY  97 98
2 JEFF SMITH  57 58
;

proc print data = firstlist;
run;

*** E. column input *** ;
data col;
	input id		1-2 
		  gender  $	4
		  height	5-6
		  weight	7-11;
datalines;
001M68155.5
2  F61 99.0
  3M  233.5
;
proc print data = col;
run;


*** F. formated input *** ;
data point;
	input 	@1 id 3.
			@4 gender $1.
			@9 age 2.
			@11 height 2.
			@15 v_date mmddyy6.;

*** G. reading more than one line per subject *** ;
data column;
	input #1	id	1-3
				age 5-6
				height 1-11
				weight 15-17 
		  #2	sbp 5-7 
		  		dbp 8-10;
datalines;
001 56   72   202
    140080
002 45   70   170
    130070
;

proc print data = column;
run;

*** H. changing the order and reading a column more than once *** ;

*** I. informat lists *** ;

*** J. holding the line - single and double trailing @S ***;
data quest;
	input year 79-80 @;
	if year = 89 then input @1 (ques1-ques10)(1.);
	else if year = 90 then input @1 (ques1-ques5)(1.)
		@6 ques5b 1. @7 (ques6-ques10)(1.);
datalines;
;

data xydata;
	input x y @@;
datalines;
1 2 7 9 3 4 10 12
15 18 23 67
;
proc print data = xydata;
run;

*** K. suppressing the error message for invalid data *** ;
*** L. reading unstructured data *** ;

* example 1-A * ;
data ex1a;
	input group $ x @@;
datalines;
C 20 C 25 C 23 C 27 C 30
T 40 T 42 T 35
;
proc ttest data = ex1a;
	class group;
	var x;
run;

* exmaple 1-B * ;
data ex1b;
	group = 'C';
	do i = 1 to 5;
		input x @;
		output;
	end;
	group = 'T';
	do i = 1 to 3;
		input x @;
		output;
	end;
	drop i;
datalines;
20 25 23 27 30
40 42 35
;
proc ttest data = ex1b;
	class group;
	var x;
run;

* example 1-C * ;
data ex1c;
	do group = 'C', 'T';
		do i = 1 to 5*(group eq 'C') + 3*(group eq 'T');
			input x @;
			output;
		end;
	end;
	drop i;
datalines;
20 25 23 27 30
40 42 35
;

data ex1d;
	do group = 'C', 'T';
		input n;
		do i = 1 to n;
			input x @;
			output;
		end;
	end;
	drop n i;
datalines;
5
20 25 23 27 30
3
40 42 35
;

proc print data = ex1d;
run;

* example 1-E * ;
data ex1e;
	retain group;
	input dummy $ @@;
	if dummy = 'C' or dummy = 'T' then group = dummy;
	else do;
		x = input(dummy, 5.0);
		output;
	end;
	drop dummy;
datalines;
C 20 25 23 27 30
T 40 42 35
;
proc print data = ex1e;
run;

* example 2-A * ;
data ex2a;
	do gender = 'M', 'F';
		do group = 'A', 'B', 'C';
			input dummy $ @;
			do while (dummy ne '#');
				score = input(dummy, 6.0);
				output;
				input dummy $ @;
			end;
		end;
	end;
	drop dummy;
datalines;
20 30 40 20 50 # 70 80 90
# 90 90 80 90 # 25 30 45 30
65 72 # 70 90 90 80 85 # 20 20 30 #
;

proc glm data = ex2a;
	class gender group;
	model score = gender ;
run; quit;

* ref ": https://stats.idre.ucla.edu/sas/output/glm/ * ;


* example 2-B * ;
data ex2b;
	retain group gender;
	length gourp gender $ 1;
	input dummy $ @@;
	if verify (dummy, 'ABCMF ') = 0 then do;
		group = substr (dummy, 1, 1);
		gender = substr (dummy, 2, 1);
		delete;
	end;
	else score = input (dummy, 6.);
	drop dummy;
datalines;
AM 20 30 40 20 50
BM 70 80 90
CM 90 80 80 90
AF 25 30 45 30 65 72
BF 70 90 90 80 85
CF 20 20 30
;
proc glm data = ex2b;
	class gender group;
	model score = gender ;
run; quit;
