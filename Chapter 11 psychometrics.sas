*** Chapter 11 psychometrics *** ;
*** A. introduction *** ;
*** B. using SAS to score a test *** ;
data score;
	array ans[5] $ 1 ans1-ans5; 
	array key[5] $ 1 key1-key5; 
	array s[5] 3 s1-s5;
	retain key1-key5;
	if _n_ = 1 the input (key1-key5) ($1.);
	input	@1 id 1-9
			@11 (ans1-ans5)($1.);
	do i = 1 to 5;
		s[i] = (key[i] eq ans[i]);
	end;

	raw = sum (of s1-s5);
	percent = 100 * raw / 5;
	keep id raw percent;
	label id		= 'social security number'
		  raw		= 'raw score'
		  percent	= 'percent score';
datalines;
ABCDE
123456789 ABCDE
035469871 BBBBB
111222333 ABCBE
212121212 CCCDE
867564733 ABCDA
876543211 DADDE
987876765 ABEEE
;

proc sort data = score;
	by id;
run;
proc print data = score label;
	title 'list of score data set';
	id id;
	var raw percent;
	format id ssn11.;
run;

*** C. generalizing the program for a variable number of questions *** ;
*** need a data set *** ;
*** D. creating a better looking table using proc tabulate *** ;
*** E. a complete test-scoring and item-analysis program *** ;
*** F. test reliability *** ;
*** G. interrater reliability *** ;
data kappa;
	input subject rater_1 $ rater_2 $ @@;
datalines;
1 N N  2 X X  3 X X  4 X N  5 N X  
6 N N  7 N N  8 X N  9 X X  10 N N
;
proc freq data = kappa;
	title 'coeff. kappa calculations';
	table rater_1 * rater_2 / nocum nopercent kappa;
run;
