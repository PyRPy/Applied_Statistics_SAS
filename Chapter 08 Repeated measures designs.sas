*** Chapter 08 Repeated measures designs *** ;
*** A. introduction *** ;
* know when to use repeated and when not to *;
* random factors vs fixed factors * ;
* proc mixed * ;

*** B. one-factor experiments *** ;
data pain;
	input subj @;
	do drug = 1 to 4;
		input pain @;
		output;
	end;
datalines;
1 5 9 6 11
2 7 12 8 9
3 11 12 10 14
4 3 8 5 8
;
proc print data = pain noobs;
run;

* or alternatively *;
data pain2;
	subj + 1;
	do drug = 1 to 4;
		input pain @;
		output;
	end;
datalines;
1 5 9 6 11
2 7 12 8 9
3 11 12 10 14
4 3 8 5 8
;

proc anova data = pain;
	title 'one-way repeated measures anova';
	class subj drug;
	model pain = subj drug;
	means drug /snk;
run;

*** C. using the repeated statement of proc anova *** ;
data repeat1;
	input subj pain1-pain4;
datalines;
1 5 9 6 11
2 7 12 8 9
3 11 12 10 14
4 3 8 5 8
;
proc anova data = repeat1;
	title 'one-way anova using the repeated statement';
	model pain1-pain4 = / nouni;
	repeated drug 4 (1 2 3 4);
run;

proc anova data = repeat1;
	title 'one way anova using the repeated statement';
	model pain1-pain4 = / nouni;
	repeated drug 4 contrast(1) / nom summary;
	repeated drug 4 contrast(2) / nom summary;
	repeated drug 4 contrast(3) / nom summary;
run;

*** D. using proc mixed to compute a mixed (random effects) model ***;
proc mixed data = pain;
	title 'one factor experiment - mixed model';
	class subj drug;
	model pain = drug;
	random subj;
run;

* use and abuse of mixed model ? * ;
* p-value for fixed effect from drug is the same as that of anova *;

*** E. two-factor experiments with a prepeated measure on one factor *** ;
data prepost;
	input subj group $ pretest posttest;
	diff = posttest - pretest;
datalines;
1 C 80 83
2 C 85 86
3 C 83 88
4 T 82 94
5 T 87 93
6 T 84 98
;
proc ttest data = prepost;
	title 't-test on difference scores';
	class group;
	var diff;
run;

* using repeated statement * ;
proc anova data = prepost;
	title1 'two-way anova with a repeated measure on on factor'; 
	class group;
	model pretest posttest = group / nouni;
	repeated time 2 (0 1);
	means group;
run;

* use a two-way anova design *;
data twoway;
	set prepost;
	length time $ 4;
	time = 'pre';
	score = pretest;
	output;
	time = 'post';
	score = posttest;
	output;
	keep subj group time score;
run;

proc print data = twoway;
run;

proc anova data = twoway;
	title 'two-way anova with tiem as a repeated measure';
	class subj group time;
	model score = group subj(group) time group*time time*subj(group);
	means group | time;
	test h = group e = subj(group);
	test h = time group * time e = time*subj(group);
run;

* plot the interactions * ;
proc means data = twoway noprint nway;
	class group time;
	var score;
	ouput out = inter
		  mean = ;
run;

options linesize = 68 pagesize = 24;
symbol1 value = circle color = black interpol = join;
symbol2 value = square color = black interpol = join;

proc gplot data = inter;
	title 'interaction plot';
	plot score*time = group;
run;

* use proc mixed *;
proc mixed data = twoway;
	title 'mixed model for two-way design';
	class group time subj;
	model score = group time group*time / solution;
	random subj(group);
	lsmeans group time;
run;
quit;

*** F. two-factor experiments with repeated measures on both factors *** ;
data sleep;
	input subj treat $ time $ react;
datalines;
1 CONT AM 65
1 DRUG AM 70
1 CONT PM 55
1 DRUG PM 60
2 CONT AM 72
2 DRUG AM 78
2 CONT PM 64
2 DRUG PM 68
3 CONT AM 90
3 DRUG AM 97
3 CONT PM 80
3 DRUG PM 85
;

proc anova data = sleep;
	title 'two-way anova with a repeated measure on both factors';
	class subj treat time;
	model react = subj|treat|time;
	means treat|time;
	test h = treat e = subj*treat;
	test h - time  e = subj*time;
	test h = treat*time e = subj*treat*time;
run;

data repeat2;
	input react1-react4;
datalines;
65 70 55 60
72 78 64 68
90 97 80 85
;
proc anova data = repeat2;
	model react1-react4 = / nouni;
	repeated time 2, treat 2 / nom;
run;

*** G. three factor experiments with a repeated measure on the last factor ***;
data coffee;
	input subj brand $ gender $ score_b score_d;
datalines;
1 A M 7 B
2 A M 6 7
3 A M 6 B
4 A F 5 7
5 A F 4 7
6 A F 4 6
7 B M 4 6
B B M 3 5
9 B M 3 5
10 B F 3 4
11 B F 4 4
12 B F 2 3
13 C M B 9
14 C M 6 9
15 C M 5 8
16 C F 6 9
17 C F 6 9
18 C F 7 8
;
proc anova data = coffee;
	title 'coffee study';
	class brand gender;
	model score_b score_d = brand|gender / nouni;
	repeated meal;
	means brand|gender;
run;

* there will be a longer format for the dataset, skip for now * ;
*** H. three factor experiments with repeated measures on two factors;
data read_1;
	input subj ses $ read1-read6;
	label read1 = 'spring yr 1'
		  read2 = 'fall yr 1'
		  read3 = 'spring yr 2'
		  read4 = 'fall yr 2'
		  read5 = 'spring yr 3'
		  read6 = 'fall yr 3';
datalines;
1 HIGH 61 50 60 55 59 62
2 HIGH 64 55 62 57 63 63
3 HIGH 59 49 58 52 60 58
4 HIGH 63 59 65 64 67 70
5 HIGH 62 51 61 56 60 63
6 LOW  57 42 56 46 54 50
7 LOW  61 47 58 48 59 55
8 LOW  55 40 55 46 57 52
9 LOW  59 44 61 50 63 60
10 LOW 58 44 56 49 55 49
;

proc anova data = read_1;
	title 'reading comprehension analysis';
	class ses;
	model read1-read6 = ses / nouni;
	repeated year 3, season 2;
	means ses;
run;

* not use repeated statement *;
data read_2;
	input subj ese 4 year season $ read;
datalines;
;
* need data input *;

data read_3;
	do ses = 'high', 'low';
		sub = 0;
		do n = 1 to 5;
			subj + 1;
			do year = 1 to 3;
				do season = 'spring', 'fall';
					input score @;
					output;
				end; 
			end;
		end;
	end;
drop n;
datalines;
61 50 60 55 59 62
64 55 62 57 63 63
59 49 58 52 60 58
63 59 65 64 67 70
62 51 61 56 60 63
57 42 56 46 54 50
61 47 58 48 59 55
55 40 55 46 57 52
59 44 61 50 63 60
58 44 56 49 55 49
;

PROC ANOVA DATA=READ_3;
   TITLE 'Reading Comprehension Analysis';
   CLASS SUBJ SES YEAR SEASON;
   MODEL SCORE = SES SUBJ(SES)
             YEAR SES*YEAR YEAR*SUBJ(SES)
             SEASON SES*SEASON SEASON*SUBJ(SES)
             YEAR*SEASON SES*YEAR*SEASON YEAR*SEASON*SUBJ(SES);
   MEANS YEAR / DUNCAN E=YEAR*SUBJ(SES);
   MEANS SES SEASON SES*YEAR SES*SEASON YEAR*SEASON
         SES*YEAR*SEASON;
   TEST H=SES                   E=SUBJ(SES);
   TEST H=YEAR SES*YEAR         E=YEAR*SUBJ(SES);
   TEST H=SEASON SES*SEASON     E=SEASON*SUBJ(SES);
   TEST H=YEAR*SEASON SES*YEAR*SEASON
                                E=YEAR*SEASON*SUBJ(SES);
RUN;
quit;
* an example of over - done, or abuse :-) * ;
