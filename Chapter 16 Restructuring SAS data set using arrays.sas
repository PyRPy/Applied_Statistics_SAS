*** Chapter 16 Restructuring SAS data set using arrays *** ;
*** A. introduction *** ;
*** B. creating new data set obs / subj from one obs / subj *** ;
data diagnose;
	input id dx1 dx2 dx3;
datalines;
01      3      4	  .
02      1      2      3
03      4      5      .
04      7      .      .
;

proc print data = diagnose;
run;
DATA NEW_DX;
   SET DIAGNOSE;
   DX = DX1;
   IF DX NE . THEN OUTPUT;
   DX = DX2;
   IF DX NE . THEN OUTPUT;
   DX = DX3;
   IF DX NE . THEN OUTPUT;
   KEEP ID DX;
RUN;

proc print data = new_dx;
run;

* using an array *;
data new_dx2;
	set diagnose;
	array dxarray[3] dx1-dx3;
	do i = 1 to 3;
		dx = dxarray[i];
		if dx ne . then output;
	end;
	keep id dx;
run;
proc print data = new_dx2;
run;

proc freq data = new_dx;
	tables dx / nocum;
run;


*** C. another example *** ;
* Creating multiple observations from a single observation using an array *;
data oneper;
	input id s1 s2 s3;
datalines;
01      3      4      5
02      7      8      9
03      6      5      4
;
data manyper;
	set oneper;
	array s[3];
	do time = 1 to 3;
		score = s[time];
		output;
	end;
	keep id time score;
run;
proc print data = manyper;
run;
* like 'reshape' in R * ;

*** D. one / subj to many / subj using multi-dim arrays *** ;
data wt_one;
	input id wt1-wt6;
datalines;
01   155  158  162  149  148  147
02   110  112  114  107  108  109
;
proc print data = wt_one;
run;

data wt_many;
	set wt_one;
	array wts[2, 3] wt1-wt6;
	do cond = 1 to 2;
		do time = 1 to 3;
			weight = wts[cond, time];
			output;
		end;
	end;
	drop wt1-wt5;
run;
proc print data = wt_many;
run;

*** E. creating one obs/subj from many obs / subj *** ;

proc sort data = manyper;
	by id time;
run;

data oneper2;
	array s[3] s1-s3;
	retain s1-s3;
	set manyper;
	by id;
	s[time] = score;
	if last.id then ouput;
	keep id s1-s3;
run;
proc print data = oneper2;
run;

data manyper2;
	input id time score;
datalines;
01       1       3
01       2       4
01       3       5
02       1       7
02       3       9
03       1       6
03       2       5
03       3       4
;
proc sort data = manyper2;
	by id time;
run;

data oneper3;
	array s[3] s1-s3;
	retain s1-s3;
	set manyper2;
	by id;
	if first.id then do i = 1 to 3;
		s[i] = .;
		end;
	s[time] = score;
	if last.id then output;
	keep id s1-s3;
run;

proc print data = oneper3;
run;

*** F. create one obs / subj from many obs / subj - using 2D array *** ;
proc sort data = wt_many;
	by id cond time;
run;

data wt_one;
	array wt[2,3] wt1-wt6;
	retain wt1-wt6;
	set wt_many;
	by id;
	if first.id then 
		do i = 1 to 2;
			do j = 1 to 3;
				wt[i,j] = .;
			end;
		end;
	wt[cond, time] = weight;
	if last.id then output;
	keep id wt1-wt6;
run;
proc print data = wt_one;
	title 'wt_one again';
run;
