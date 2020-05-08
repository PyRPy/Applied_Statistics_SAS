*** Chapter 04 Working with date and longitudinal data *** ;
*** A. introduction *** ;
*** B. processing date variables *** ;
data hospital;
	input	@1	id			$3.
			@4	dob			mmddyy10.
			@14	admit		mmddyy10.
			@24	discharg	mmddyy10.
			@34	dx			1. 
			@35	fee			5.;
	length_stay = discharg - admit + 1;
	*age = admit - dob;
	age = round(yrdif(dob, admit, 'actual'), .1);

	format dob mmddyy10. admit discharg date9.;

datalines;
00110/21/194612/12/200412/14/20048 8000
00205/01/198007/08/200408/08/2004412000
00301/01/196001/01/200401/04/20043 9000
00406/23/199811/11/200412/25/2004715123
;

proc print data = hospital;
run;

*** C. working with two-digit year values - the y2k problem) *** ;
options yearcutoff = 1900;

*** D. longitudinal data *** ;
DATA HOSP;
   INPUT #1 ID1 1-3 DATE1 MMDDYY6.  HR1 10-12 SBP1  13-15 DBP1 16-18
            DX1 19-21 DOCFEE1 22-25 LABFEE1 26-29
         #2 ID2 1-3 DATE2 MMDDYY6. HR2 10-12 SBP2 13-15 DBP2 16-18
            DX2 19-21 DOCFEE2 22-25 LABFEE2 26-29
         #3 ID3 1-3 DATE3 MMDDYY6. HR3 10-12 SBP3 13-15 DBP3 16-18
            DX3 19-21 DOCFEE3 22-25 LABFEE3 26-29
         #4 ID4 1-3 DATE4 MMDDYY6. HR4 10-12 SBP4 13-15 DBP4 16-18
            DX4 19-21 DOCFEE4 22-25 LABFEE4 26-29;
   FORMAT DATE1-DATE4 MMDDYY8.;
DATALINES;
00710218307012008001400400150
00712018307213009002000500200
007
007
00909038306611007013700300000
009
009
009
00507058307414008201300900000
00501158208018009601402001500
00506188207017008401400800400
00507038306414008401400800200
;

proc print data = hosp;
run;

* in 5th ed * ;
DATA HOSP_PATIENTS;
	INPUT #1
		@1 id $3.
		@4 DATE1 MMDDYY8.
		@12 HR1 3.
		@15 SBP1 3.
		@18 DBP1 3.
		@21 DX1 3.
		@24 DOCFEE1 4.
		@28 LABFEE1 4.
			#2
		@4 DATE2 MMDDYY8.
		@12 HR2 3.
		@15 SBP2 3.
		@18 DBP2 3.
		@21 DX2 3.
		@24 DOCFEE2 4.
		@28 LABFEE2 4.
			#3
		@4 DATE3 MMDDYY8.
		@12 HR3 3.
		@15 SBP3 3.
		@18 DBP3 3.
		@21 DlG 3.
		@24 DOCFEE3 4.
		@28 LABFEE3 4.
			#4
		@4 DATE4 MMDDYY8.
		@12 HR4 3.
		@15 SBP4 3.
		@18 DBP4 3.
		@21 DX4 3.
		@24 DOCFEE4 4.
		@28 LABFEE4 4.;
	FORMAT DATE1-DATE4 MMDDYY10.;
DATALINES;
0071021198307012008001400400150
0071201198307213009002000500200
007
007
0090903198306611007013700300000
009
009
009
0050705198307414008201300900000
0050115198208018009601402001500
0050618198207017008401400800400
0050703198306414008401400800200
;

proc print data = hosp_patients;
run;

data patients;
	input	@1	id		$3.
			@4	date	mmddyy8.
			@12 hr		3.
			@15 sbp		3.
			@18	dbp		3.
			@21	dx		3.
			@24	docfee	4.
			@28	labfee	4.;
	format date mmddyy10.;
datalines;
0071021198307012008001400400150
0071201198307213009002000500200
0090903198306611007013700300000
0050705198307414008201300900000
0050115198208018009601402001500
0050618198207017008401400800400
0050703198306414008401400800200
; 

proc means data = patients noprint nway;
	class id;
	var hr -- dbp docfee labfee;
	output out = stats mean=M_hr M_dbp M_docfee M_labfee;
run;
* something not quite right *;

proc print data = stats;
run;

*** E. selecting the first or last visit per patient *** ;
proc sort data = patients;
	by id date;
run;

data recent;
	set patients;
	by id;
	if last.id;
run;

proc print data = recent;
run;

*** F. computing differences between observations in a longitudinal data set ***;
data looking_back;
	input data ozone;
	ozone_lag24 = lag(ozone);
	ozone_lag48 = lag2(ozone);
datalines;
1 8
2 10
3 12 
3 7
;
proc print data = looking_back;
	title 'the lag function';
run;

data laggard;
	input x;
	if x gt 5 then lag_x = lag(x);
datalines;
7
9
1
8
;
proc print data = laggard;
	title 'a feasture of the lag function'; 
run;

* patient data set *;
data difference;
	set patients;
	by id;
	diff_hr = hr - lag(hr);
	diff_sbp = sbp - lag(sbp);
	diff_dbp = dbp - lag(dbp);
	if not first.id then output;
run;
proc print data = difference;
	title 'patients data set using lag'; 
run;

data difference2;
	set patients;
	by id;
	diff_hr = dif(hr);
	diff_sbp = dif(sbp);
	diff_dbp = dif(dbp);
	if not first.id then output;
run;
proc print data = difference2;
	title 'patients data set using dif'; 
run;

*** G. computing difference between the first and 
    last observation for each subject ***;

data first_last;
	set patients;
	by id;
	retain first_hr first_sbp first_dbp;
	if first.id and last.id then delete;
	if first.id then do;
		first_hr = hr;
		first_sbp = sbp;
		first_dbp = dbp;
	end; 
	if last.id then do;
		d_hr = hr - first_hr;
		d_sbp = sbp - first_sbp;
		d_dbp = dbp - first_dbp;
		output;
	end;
run;

proc print data = first_last;
	title 'patients data set -  first - last'; 
run;

*** H. computing frequencies on longitudinal data set ***;
proc freq data = patients order = freq;
	title 'diagnoses in decreasing frequency order' ;
	tables dx;
run;

proc print data = patients;
	title '';
run;

data diag;
	set patients;
	by id dx;
	if first.dx;
run;
proc freq data = diag order = freq;
	tables dx;
run;

*** I. creating summary data sets with proc means or proc summary *** ;
data school;
	length gender $ 1 teacher $ 5; 
	input subject 
		  gender $
		  teacher $
		  T_age 
		  pretest 
		  posttest;
	gain = posttest - pretest;
datalines;
1 M JONES 35 67 81
2 F JONES 35 98 86
3 M JONES 35 52 92
4 M BLACK 42 41 74
5 F BLACK 42 46 76
6 M SMITH 68 38 80
7 M SMITH 68 49 71
8 F SMITH 68 38 63
9 M HAYES 23 71 72
10 F HAYES 23 46 92
11 M HAYES 23 70 90
12 F WONG 47 49 64
13 M WONG 47 50 63
;

proc means data=school n mean std maxdec=2;
	title 'means scores for each teacher';
	class teacher;
	var pretest posttest gain;
run; quit;

proc means data = school noprint nway;
	class teacher;
	var pretest posttest gain;
	output out = teachsum
		mean = M_pre M_past M_gain;
run;

proc print data = teachsum;
run;

* teacher' age *;

proc means data = school noprint nway;
	class teacher;
	id t_age;
	var pretest posttest gain;
	output out = teachsum
		mean = M_pre M_past M_gain;
run;

proc print data = teachsum;
run;

data demog;
	length gender $ 1 region $ 5;
	input subj gender $ region $ height weight;
datalines;
01 M North 70 200
02 M North 72 220
03 M South 68 155
04 M South 74 210
05 F North 68 130
06 F North 63 110
07 F South 65 140
08 F South 64 108
09 F South  . 220
10 F South 67 130
;
proc means data = demog n mean std maxdec=2;
	title 'output from proc means';
	class gender region;
	var height weight;
run;

* output a summary * ;

proc means data = demog n mean std maxdec=2 noprint;
	class gender region;
	var height weight;
	output out = summary
		mean = M_height M_weight;
run;

proc print data = summary;
	title 'summary 2';
run;

proc means data = demog noprint chartype;
	class gender region;
	var height weight;
	output out = summary
		mean = M_height M_weight;
run;

proc print data = summary;
	title 'summary 3';
run;
* something not right *;
data grand region gender gender_region;
	set summary;
	if __type__ = '00' then output grand;
	else if __type__ = '01' then output region;
	else if __type__ = '10' then output gender;
	else if __type__ = '11' then output gender_region;
run;

proc print data = summary;
	title 'summary 4';
run;

proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out = summary
		mean = M_ht M_wt;
run;

proc print data = summary;
	title 'summary 5 with nway option';
run;

proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out = summary
		n    = N_ht N_wt
		mean = M_ht M_wt;
run;

proc print data = summary;
	title1 'summary 5 with nway option';
	title2 'with requests for N = and mean = ';
run;

* drop = option to omit type * ;
proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out = summary(drop = _type_)
		n    = N_ht N_wt
		mean = M_ht M_wt;
run;

proc print data = summary;
	title1 'summary 6 with nway option';
	title2 'with requests for N = and mean = ';
	title3 'drop option';
run;

* another option for mean = ; *;

proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out = summary(drop = _type_)
		mean = ;
run;

proc print data = summary;
	title1 'summary 7 with nway option';
	title2 'with requests for N = and mean = ';
	title3 'drop option';
run;

*** J. output statistics other than means *** ;
proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out = summary
		mean = M_ht M_wt
		n = n_ht n_wt
		median = med_ht med_wt
		min = min_ht min_wt
		max = max_ht max_wt;
run;
proc print data = summary;
run;

* with auto name * ;

proc means data = demog noprint nway;
	class gender region;
	var height weight;
	output out = summary (drop = _type_ rename=(_freq_ = number))
		mean = 
		n = 
		median = 
		min = 
		max = /autoname;
run;
proc print data = summary;
	title '';
run;
