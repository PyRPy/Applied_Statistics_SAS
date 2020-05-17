*** Chapter 18 A review of SAS functions - character *** ;
*** A. Introduction *** ;
*** B. How lengths of char variables are set in a SAS data step *** ;
* the weakness of this software - wild cards *;
data example1;
	input group $ @10 string $3.;
	left = 'x    '; *x and 4 blanks;
	right = '    x'; *4 blanks and x;
	c1 = substr(group,1,2);
	c2 = substr(group,1);
	lgroup = length(group);
	lstring = length(string);
	lleft = length(left);
	lright = length(right);
	lc1 = length(c1);
	lc2 = length(c2);
datalines;
ABCDEFGH 123
XXX        4
Y        5
;
proc contents data = example1 position;
	title 'output from proc contents';
run;


proc print data = example1 noobs;
	title 'listing of example';
run;

*** C. working with blanks *** ;
* compress blanks in the input lines *;
data example2;
	input #1 @1 name		$20.
		  #2 @1 address		$30.
		  #3 @1 city		$15.
		  	 @20 state		 $2.
			 @25 zip		 $5.;
	name = compbl(name);
	address = compbl(address);
	city = compbl(city);
datalines;
RON CODY
89 LAZY BROOK ROAD
FLEMINGTON         NJ   08822
BILL     BROWN
28   CATHY   STREET
NORTH   CITY       NY   11518
;
proc print data = example2;
	title 'example 2';
	id name;
	var address city state zip;
run;

*** D. how to remove char from a string *** ;
data example3;
	input phone $ 1-15;
	phone1 = compress(phone);
	phone2 = compress(phone, '(-) ');
datalines;
(908)235-4490
(201) 555-77 99
;
proc print data = example3;
	title 'phone numbers format';
run;

*** E. char data verification *** ;
data example4;
	input id	$ 1-4
		  answer $ 5-9;
	p = verify(answer, 'abcde');
	ok = (p eq 0);
datalines;
001 ACBED
002 ABXDE
003 12CCE
004 ABC E
;
proc print data = example4 noobs;
	title 'verify';
run;

data example5;
	input string $3.;
datalines;
ABC
EBX
aBC
VBD
;

data _null_;
	set example5;
	file print;
	check = 'abcde';
	if verify(string, check) ne 0 then
		put 'error in record ' _n_ string =;
run;

*** F. substring example *** ;
data example6;
	input id $ 1-9;
	length state $2;
	state = substr(id, 1, 2);
	num = input(substr(id, 7, 3), 3.);
datalines;
NYXXXX123
NJ1234567
;

proc print data = example6 noobs;
	title 'substrings in input';
run;

*** G. using the substr func on the left-hand side of the equ sign *** ;
data example7;
	input sbp dbp @@;
	length sbp_chk dbp_chk $ 4;
	sbp_chk = put(sbp, 3.);
	dbp_chk = put(dbp, 3.);
	if sbp gt 160 then substr(sbp_chk, 4, 1) = '*';
	if dbp gt 90  then substr(dbp_chk, 4, 1) = '*';
datalines;
120 80 180 92 200 110
;
proc print data = example7 noobs;
	title 'put a marker on some data points';
run;

*** H. doing the previous example another way *** ;
data example8;
	input sbp dbp @@;
	length sbp_chk dbp_chk $ 4;
	sbp_chk = put(sbp, 3.);
	dbp_chk = put(dbp, 3.);
	if sbp gt 160 then sbp_chk = substr(sbp_chk, 1, 3) || '*';
	if dbp gt 90  then dbp_chk = trim(dbp_chk) || '*';
datalines;
120 80 180 92 200 110
;
proc print data = example8 noobs;
	title 'put a marker on some data points - another way';
run;

*** I. unpacking a string *** ;
* save storage ? *;
data example9;
	input string $ 1-5;
datalines;
12345
8 642
;

data unpack;
	set example9;
	array x[5];
	do j = 1 to 5;
		x[j] = input(substr(string, j, 1), 1.);
	end;
	drop j;
run;

proc print data = unpack noobs;
	title 'unpack';
run;

*** J. parsing a string *** ;
data ex10;
	input long_str $ 1-80;
	array pieces[5] $ 10 piece1-piece5;
	do i = 1 to 5;
		pieces[i] = scan(long_str, i, ',:.! ');
	end;
	drop long_str i;
datalines;
THIS LINE, CONTAINS!FIVE.WORDS
ABCDEFGHIJKL XXX:YYY 
;;;;
proc print data = ex10 noobs;
	title 'parsing a string';
run;

*** K. locating a string within another string *** ;
* upper and lower cases sensitive now ? *;
data ex11;
	input string $ 1-10;
	first = index(string, 'xyz');
	first_c = indexc(string, 'X', 'y', 'z');
datalines;
ABCXYZ1234
1234567890
ABCX1Y2Z39
ABCZZZXYZ3
;
proc print data = ex11 noobs;
	title 'position of a substring';
run;

*** L. changing lower case to uppercase *** ;
DATA EX12;
   LENGTH A B C D E $ 1;
   INPUT A B C D E X Y;
DATALINES;
M f P p D 1 2
m f m F M 3 4
;
proc print data = ex12;
run;

DATA UPPER;
   SET EX12;
   ARRAY ALL_C[*] _CHARACTER_;
   DO I = 1 TO DIM(ALL_C);
      ALL_C[I] = UPCASE(ALL_C[I]);
   END;
   DROP I;
RUN;
proc print data = upper;
run;

*** M. substituting one char for another *** ;
data ex13;
	input ques : $1. @@;
	ques = translate(ques, 'abcde', '12345');
datalines;
1 4 3 2 5
5 3 4 2 1
;
proc print data = ex13 noobs;
	title 'replace char';
run;

* not working *;
DATA EX14;
   LENGTH CHAR $ 1;
   INPUT CHAR @@;
   X = INPUT(TRANSLATE(UPCASE(CHAR),'01','NY'),1.);
DATALINES;
N Y n y A B 0 1
;
PROC PRINT DATA=EX14 NOOBS;
   TITLE 'Listing of Example 14';
RUN;

*** N. substituting one word for another *** ;
DATA CONVERT;
   INPUT @1 ADDRESS $20. ;
   *** Convert Street, Avenue, and Boulevard to
       their abbreviations;
   ADDRESS = TRANWRD (ADDRESS,'Street','St.');
   ADDRESS = TRANWRD (ADDRESS,'Avenue','Ave.');
   ADDRESS = TRANWRD (ADDRESS,'Road','Rd.');
DATALINES;
89 Lazy Brook Road 
123 River Rd.
12 Main Street
;
PROC PRINT DATA=CONVERT;
   TITLE 'abbreviations';
RUN;

*** O. join strings *** ;
data one;
	length first last $ 15;
	input first last;
datalines;
Ron Cody
Elizabeth Cantor
Ralph Fitzpatrick
;

data convert2;
	set one;
	length name $ 32;
	name = trim(last) || ', ' || first;
run;
proc print data = convert2 noobs;
	title 'joining strings';
run;

*** P. doundex conversion *** ;
* wild cards - a case study, not a generic programming lang. *;
DATA EX16;
   LENGTH NAME1-NAME3 $ 10;
   INPUT NAME1-NAME3;
   S1 = SOUNDEX(NAME1);
   S2 = SOUNDEX(NAME2);
   S3 = SOUNDEX(NAME3);
DATALINES;
cody Kody cadi
cline klein clana
smith smythE adams
;
PROC PRINT DATA=EX16 NOOBS;
   TITLE 'Listing of Example 16';
RUN;

*** Q. spelling distance *** ;
DATA SPELLING_DISTANCE;
	INFORMAT WORD_ONE WORD_TWO $15.;
	INPUT WORD_ONE WORD_TWO;
	DISTANCE = SPEDIS (WORD_ONE, WORD_TWO) ;
datalines;
Exact Exact
Mistake Mistaken
abcde acbde
abcde uvwxyz
123-45-6789 123-54-6789
;

PROC PRINT DATA=SPELLING_DISTANCE NOOBS;
	TITLE "Listing of Data Set SPELLING_DISTANCE";
run;
