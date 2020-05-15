*** Chapter 15 Working with arrays *** ;
*** A. introduction *** ;
*** B. substituting one value for another for a series of variables *** ;
data missing;
	set old;
	if a = 999 then a = .;
	if b = 999 then b = .;
	if c = 999 then c = .;
	if d = 999 then d = .;
	if e = 999 then e = .;
run;

* use array *;
data missing;
	set old;
	array x[5] a b c d e;
	do i=1 to 5;
		if x[i] = 999 then x[i] = .;
	end;
	drop i;
run;

/*
do counter = start to end by increment;
	(lines of sas code)
end;
*/

*** C. extending example 1 to convert all numeric values of 999 to missing ***;
data allnums;
	set all;
	array preston[*] _numeric_ ;
	do i = 1 to dim(preston);
		if preston[i] = 999 then preston[i] = .;
	end;
	drop i;
run; 

*** D. onverting N/A to a character missing value ***;
data notapply;
	set old;
	if s1 = 'N/A' then s1 = ' ';

	if z = 'N/A' then z = ' ';
run;

* in array version *;
data notapply;
	set old;
	array russell[*] $ s-s3 x y z;
	do j = 1 to dim(russell);
		if russell[j] = 'N/A' then russell[j] = ' ';
	end;
	drop j;
run;

*** E. convert units *** ;
data convert;
	input ht1-ht3 wt1-wt5;
	array ht[3];
	array htcm[3];
	array wt[5];
	array wtkg[5];
	do i = 1 to 5;
		if i le 3 then htcm[i] = 2.54 * ht[i];
		wtkg[i] = wt[i] / 2.2;
	end;
datalines;
;
run;

* or use two loops *;
do i = 1 to 3;
	htcm[i] = 2.54 * ht[i];
	wtkg[i] = wt[i] / 2.2;
end;
* this is not professional * ;

*** F. temporary array *** ;
data passing;
	array pass[5] _temporary__ (65 70 65 80 75);
	array score[5];
	input id $ score[5];
	pass_num = 0;
	do i = 1 to 5;
		if score[i] ge pass[i] then pass_num + 1;
	end;
	drop i;
datalines;
001 64 69 68 82 74
002 80 80 80 60 80
003 80 80 80 80 80
;

proc print data = passing;
	title 'passing data set';
	id id;
	var pass_num score1-score5;
run;

* not working above - kind of outdated *;

*** use array to score a test *** ;
DATA SCORE;

   ARRAY KEY[10] $ 1 _TEMPORARY_;
   ARRAY ANS[10] $ 1;
   ARRAY SCORE[10] _TEMPORARY_;

   IF _N_ = 1 THEN 
      DO I = 1 TO 10;
         INPUT KEY[I] @;
      END;

   INPUT ID $ @5(ANS1-ANS10)($1.);
   RAWSCORE = 0;

   DO I = 1 TO 10;
      SCORE[I]=ANS[I] EQ KEY[I];
      RAWSCORE + SCORE[I];
   END;

   PERCENT = 100*RAWSCORE/10;
   DROP I;
DATALINES;
A B C D E E D C B A
001 ABCDEABCDE
002 AAAAABBBBB
;
PROC PRINT;
   TITLE 'SCORE Data Set';
   ID ID;
   VAR RAWSCORE PERCENT;
RUN;

*** H. specifying array bounds *** ;
*** I. temporary arrays and array bounds *** ;
*** J. implicitly subscripted arrays *** ;
