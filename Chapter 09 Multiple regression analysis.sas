*** Chapter 09 Multiple regression analysis *** ;
*** A. introduction *** ;
* design regresson *;
* nonexperimental regression *;

*** B. design regression *** ;
* simple two-factor cross design ? *;
data weight_loss;
	input id dosage excercise loss;
datalines;
   1        100         0         -4
   2        100         0          0
   3        100         5         -7
   4        100         5         -6
   5        100        10         -2
   6        100        10        -14
   7        200         0         -5
   8        200         0         -2
   9        200         5         -5
  10        200         5         -8
  11        200        10         -9
  12        200        10         -9
  13        300         0          1
  14        300         0          0
  15        300         5         -3
  16        300         5         -3
  17        300        10         -8
  18        300        10        -12
  19        400         0         -5
  20        400         0         -4
  21        400         5         -4
  22        400         5         -6
  23        400        10         -9
  24        400        10         -7 
;

proc reg data = weight_loss;
	title 'weight loss experiment - regression example';
	model loss = dosage excercise / p r;
run;
quit;

* p - predicted value r - residuals * ;

*** C. nonexperimental regression *** ;
data nonexp;
	input id ach6 ach5 apt att income;
datalines;
 1      7.5      6.6      104      60      67    
 2      6.9      6.0      116      58      29     
 3      7.2      6.0      130      63      36     
 4      6.8      5.9      110      74      84     
 5      6.7      6.1      114      55      33     
 6      6.6      6.3      108      52      21     
 7      7.1      5.2      103      48      19     
 8      6.5      4.4       92      42      30     
 9      7.2      4.9      136      57      32     
10      6.2      5.1      105      49      23     
11      6.5      4.6       98      54      57     
12      5.8      4.3       91      56      29
13      6.7      4.8      100      49      30     
14      5.5      4.2       98      43      36
15      5.3      4.3      101      52      31     
16      4.7      4.4       84      41      33
17      4.9      3.9       96      50      20
18      4.8      4.1       99      52      34
19      4.7      3.8      106      47      30
20      4.6      3.6       89      58      27 
;
proc reg data = nonexp;
	title 'nonexperimental design example';
	model ach6 = ach5 apt att income / selection = forward;
	model ach6 = ach5 apt att income / selection = maxr;
run; quit;

*** D. stepwise and othervariable selection methods *** ;

proc reg data = nonexp;
	title 'r-square and cp';
	model ach6 = income att apt ach5 / selection = rsquare cp;
	modle ach5 = income att apt / selection = rsquare cp;
run; quit;

proc corr data = nonexp nosimple;
	title 'correlation from nonexp data set';
	var apt att ach5 ach6 income;
run;

*** E. creating and using dummy variables *** ;
/*
if gender = 'f' then female = 1;
else female = 0;

if gender in ('m' 'f') then famale = (gender eq 'f');
*/

*** F. using the variable inflation factor to look for multicollinearity *** ;
proc reg data = nonexp;
	title 'add VIF to regression';
	model ach6 = ach5 apt att income / vif;
run;
quit;

*** G. logistic regression *** ;
proc format;
	value	agegroup 0 = '20 to 65'
					 1 = '< 20 or > 65';
	value vision 	 0 = 'no problem'
					 1 = 'some problem';
	value yes_no 	 0 = 'no'
					 1 = 'yes';
run;

DATA LOGISTIC;
*Note: INFILE removed and DATALINES substituted;
   INPUT ACCIDENT AGE VISION DRIVE_ED;
   ***Note: No missing ages;
   IF AGE < 20 OR AGE > 65 THEN AGEGROUP = 1;
   ELSE AGEGROUP=0;
   IF AGE < 20 THEN YOUNG = 1;
   ELSE YOUNG = 0;
   IF AGE > 65 THEN OLD = 1;
   ELSE OLD = 0;

   LABEL ACCIDENT = 'Accident in Last Year?'
         AGE      = 'Age of Driver'
         VISION   = 'Vision Problem?'
         DRIVE_ED = 'Driver Education?';

   FORMAT ACCIDENT
          DRIVE_ED
          YOUNG
          OLD        YES_NO.
          AGEGROUP   AGEGROUP.
          VISION     VISION.;
DATALINES;
 	1           17         1           1
    1           44         0           0
    1           48         1           0
    1           55         0           0
    1           75         1           1
    0           35         0           1
    0           42         1           1
    0           57         0           0 
    0           28         0           1
    0           20         0           1
    0           38         1           0
    0           45         0           1
    0           47         1           1
    0           52         0           0
    0           55         0           1
    1           68         1           0
    1           18         1           0
    1           68         0           0
    1           48         1           1
    1           17         0           0
    1           70         1           1
    1           72         1           0
    1           35         0           1
    1           19         1           0
    1           62         1           0
    0           39         1           1
    0           40         1           1
    0           55         0           0 
    0           68         0           1
    0           25         1           0
    0           17         0           0
    0           45         0           1
    0           44         0           1
    0           67         0           0
    0           55         0           1
    1           61         1           0
    1           19         1           0
    1           69         0           0
    1           23         1           1
    1           19         0           0
    1           72         1           1
    1           74         1           0
    1           31         0           1
    1           16         1           0
    1           61         1           0
;
proc logistic data = logistic descending;
	title 'predicting accident';
	model accident = age vision drive_ed / selection=forward
										   ctable pprob = (0 to 1 by 0.1)
										   lackfit 
										   risklimits;
run; quit;
 
* creating a categorical variable from age * ;
options ps = 24;
pattern color = black value = empty;
proc gchart data = logistic;
	title 'age distribution';
	vbar age / midpoints = 10 to 90 by 10 
	group = accident;
run;

proc logistic data = logistic descending;
	title 'predicting accident';
	model accident = age vision drive_ed / selection=forward
										   ctable pprob = (0 to 1 by 0.1)
										   lackfit 
										   risklimits
										   outroc = roc;
run; quit;

options ls = 64 ps = 32;
symbol value = dot color = black interpol = sms60 width=2;
proc gplot data = roc;
	title 'roc curve';
	plot _sensit_*_1mspec_= 'o';
	label _sensit_ = 'sensitivity'
	_1mspec_ = '1-specificity';
run;
quit;
