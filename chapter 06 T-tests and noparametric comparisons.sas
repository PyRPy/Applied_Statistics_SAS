*** chapter 06 T-tests and noparametric comparisons *** ;
*** A. introduction *** ;
*** B. t-test: testing differences between two means *** ;
data response;
	input group $ time ;
datalines;
C 80
C 93
C 83
C 89
C 98
T 100
T 103
T 104
T 99
T 102
;
proc ttest data = response;
	title "T-test example";
	class group;
	var time;
run;

*** C. random assignment of subjects *** ;
data assign;
	do subj = 1 to 50;
		if ranuni(123) le 0.5 then group = 'a';
		else group = 'b';
		output;
	end;
run;
options ps = 16 ls = 72;
proc report data = assign panels=99 nowd;
	title "simple random assignment";
	columns subj group;
	define subj / width=4;
	define group / width=5;
run;

* get same number of 'a' and 'b' * ;
proc format;
	value grpfmt 0='control' 1 = 'treatment';
run;

data random;
	do subj = 1 to 20;
		group = ranuni(0);
		output;
	end;
run;

proc rank data = random groups = 2 out=split;
	var group;
run;

proc print data = split noobs;
	title "subject group assignments";
	var subj group;
	format group grpfmt;
run;

*** D. two independent samples: distribution-free tests *** ;
data tumor;
	input group $ mass @@;
datalines;
A 3.1 A 2.2 A 1.7 A 2.7 A 2.5
B 0.0 B 0.0 B 1.0 B 2.3
;
proc npar1way data=tumor wilcoxon;
	title "nonparametric test to compare tumor masses";
		class group;
		var mass;
		exact wilcoxon;
run;

*** E. one-tailed versus two-tailed tests *** ;
*** F. paired t-test for related samples *** ;
data paired;
	input ctime ttime;
datalines;
90 95
87 92
100 104
80 89
95 101
90 105
;
proc ttest data=paired;
	title "show a paired t-test";
	paired ctime * ttime;
run;

* the mean difference is -7.3, the probability of the difference occuring
* by chance is 0.0074, so the difference is significant ;

*** Problem 6.9 what's wrong with this program ? *** ;
data drugstdy;
	input subject 1-3 drug 4 heartrate 5-7 sbp 8-10
		  dbp 11-13;
avebp = dbp + (sbp-dbp) / 3 ;

datalines;
0011064130080
0021068120076
0031070156090
0042080140080
0052088180092
0062098178094
;

proc print data = drugstdy;
run;

proc npar1way data=drugstdy wilcoxon median;
	title 'my drug study';
	class drug;
	var heartrate sbp dbp avebp;
run;

proc ttest data=drugstdy; * no t-test in SAS *;
	class drug;
	var heartrate sbp dbp avebp;
run;
