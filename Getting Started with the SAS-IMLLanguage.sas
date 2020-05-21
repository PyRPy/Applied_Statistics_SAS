*** Getting Started with the SAS-IMLLanguage *** ;
*** https://support.sas.com/resources/papers/proceedings13/144-2013.pdf;
*** GETTING STARTED: A FIRST SAS/IML PROGRAM;
proc iml;
celsius = {-40, 0, 20, 37, 100};
fahrenheit = 9/5 * celsius + 32;
print celsius fahrenheit;

/* print marital status of 24 people */
proc iml;
ageGroup = {"<=45", ">45"};
status = {"single", "married", "divorced"};
counts = {5 5 0, 2 9 3};
p = counts / sum(counts);
print p[colname = status
		rowname = ageGroup
		label = "marital status by age group"
		format = percent7.1];

*** CREATING MATRICES AND VECTORS *** ;
proc iml;
s = 1;
x = {1 2 3, 4 5 6};
y = {"male", "female"};

z = j(2, 3, 0); *** J(r, c, v);
m = repeat({0 1}, 3, 2); *** repeat(x, r, c);
print m;

proc iml;
i = 1:5;
k = do(1, 10, 2);
print i, k;

*** MATRIX DIMENSIONS *** ;
proc iml;
x = {1 2 3, 4 5 6};
n = nrow(x);
p = ncol(x);
dim = dimension(x);
print dim, n, p;

* shape matrix into different dims;
proc iml;
x = {1 2 3, 4 5 6};
row = shape(x, 1);
m = shape(x, 2, 3);
*print row, m;

* add rows or columns to a matrix ;
z = x // {7 8 9};
y = x || {7 8, 9 10};
print z, y;


*** MATRIX AND VECTOR OPERATIONS *** ;
proc iml;
* elementwise operations ;
u = {1 2};
v = {3 4};
w = 2*u - v;

* matrix operations ;
A = {1 2, 3 4};
b = {-1, 1};
z = A*b;
print z;
* hybrid ;
x = {-4 9,
	  2 5,
	  8 7};
mean = {2 7};
std = {6 2};
center = x - mean;
stdX = center / std;
print stdX;
print center;

/*set up the normal equations (X`X)b = X`y */
proc iml;
x = {1,2,3,4,5,6,7,8};
print x;
y = {5 9 10 15 16 20 22 27};
y = t(y);

/*Step 1: Compute X`X and X`y */
x = j(nrow(x), 1, 1) || x;
print x;
xpx = t(x) * x;
xpy = t(x) * y;
b = solve(xpx, xpy);
print b;

*** ROWS, COLUMNS, and SUBMATRICES *** ;
proc iml;
A = {1 2 3,
	 4 5 6,
	 7 8 9,
	10 11 12};
r = A[2, ];
m = A[3:4, 1:2];
print r, m;

A[2, 1] = .;
A[3:4, 1:2] = 0;
/*assign elements in row-major order*/
A[{1 5 9}] = {-1 -2 -3};
print A;

*** READING AND WRITING DATA *** ;
* CREATING MATRICES FROM SAS DATA SETS ;
proc iml;
varNames = {"make" "model" "mpg_city" "mpg_highway"};
use sashelp.cars(obs = 3);
read all var varNames;
close sashelp.cars;
print make model mpg_city mpg_highway;

proc iml;
varNames = {"mpg_city" "mpg_highway" "cylinders"};
use sashelp.cars(obs = 3);
read all var varNames into m;
print m[c=varNames]; /*C= same as COLNAME=*/

* read all var _num_ into y[c=numericNames];
* read all var _char_ into z[c=charNames];

*** CREATING SAS DATA SETS FROM MATRICES *** ;
proc iml;
x = 1:5; y = 5:1; v = "v1":"v5";
create out var {"x" "y" "v"};
append;
close out;

proc print data = out;
run;

/*create SAS data set from a matrix*/
proc iml;
m = {1 2, 3 4, 5 6, 7 8};
create out2 from m[colname={"x" "y"}];
append from m;   /*write the data*/
close out2;

proc print data = out2;
run;

*** PROGRAMMING FUNDAMENTALS *** ;

* AVOIDING LOOPS ;
* first try - not efficient ;
proc iml;
s = {1 2 3, 4 5 6, 7 8 9, 10 11 12};
results = j(1, ncol(s));
print s, results;

do j = 1 to ncol(s);
	sum = 0;
	do i = 1 to nrow(s);
		sum = sum + s[i,j];
	end;
	results[j] = sum / nrow(s);
end;

print results;

* using sum function ;
do i = j to ncol(s);
	results[j] = sum(s[, j]) / nrow(s);
end;
print results;

* use mean function ;
results2 = mean(s);
print results2;

*** SUBSCRIPT REDUCTION OPERATORS *** ;

proc iml;
x = {1 2 3,4 5 6,7 8 9,4 3 .};
colSums = x[+, ];
colMeans = x[:, ];
rowSums = x[ ,+];
rowMeans = x[ ,:];
print x;
print colSums, colMeans, rowSums, rowMeans;

*** LOCATE OBSERVATIONS *** ;
proc iml;
varNames = {"cylinders" "mpg_city"};
use sashelp.cars;
read all var varNames into X;
*print X;

idx = loc(X[,1] < 6 & X[,2] > 35);
print (idx`)[label="row"] (X[idx,])[c=varNames];
* somehow this time it works ;

if ncol(idx) > 0 then do;
	print "good";
end;

else do;
	print "no obs found";
end;

*** HANDLE MISSING VALUES *** ;
proc iml;
x = {1, ., 2, 2, 3, .};
nonMissing = loc(x ^= .);
y = x[nonMissing];
print x, y;

/*exclude rows with missing values*/
proc iml;
z = {1 .,2 2,. 3,4 4};
numMiss = countmiss(z, "row");         /*count missing in each row*/
y = z[ loc(numMiss=0), ];              /*z[{2 4}, ] = {2 2, 4 4}*/
print y; 
quit;

*** ANALYZE LEVELS OF CATEGORICAL VARIABLES *** ;
proc iml;
use sashelp.cars;
read all var {"type" "mpg_city"};
close sashelp.cars;

/*UNIQUE-LOC technique*/
uC = unique(type);
mean = j(1, ncol(uC));
do i = 1 to ncol(uC);
	idx = loc(type = uC[i]);
	mean[i] = mean(mpg_city[idx]);
end;
print mean[colname=uC label="average MPG-city" format = 4.1];

*** USER-DEFINED FUNCTIONS *** ;
proc iml;
start stdize(x);
	return ((x - mean(x)) / std(x));
finish;

* test ;
A = {0 2 9,1 4 3,-1 6 6};
z = stdize(A);
print z; 
quit;

*** LOCAL VERSUS GLOBAL MATRICES *** ;
proc iml;
x = 0;
start sqr(t);
	x = t##2;
	return (x);
finish;

s = sqr(2);
print x[label="outside x (unchanged)"];
print s;

* global varaible *;
proc iml;
x = 0;
start sqr2(t) global(x);
	x = t##2;
	return (x);
finish;

s = sqr2(2);

print x[label="outside x (unchanged)"];

*** PASSING ARGUMENTS BY REFERENCE *** ;
proc iml;
start double(x);
	x = 2 * x;
finish;

y = 1:5;
run double(y);  * for module, use run;
print y;

/*define subroutine with output arguments*/
proc iml;
start power(x2, x3, x4, x);
	x2 = x##2;
	x3 = x##3;
	x4 = x##4;
finish;

y = {-2, -1, 0, 1, 2};
run power(square, cube, quartic, y);
print y square cube quartic;
quit;

*** CALLING SAS PROCEDURES *** ;
proc iml;
x = {1 1 1 1 2 2 2 3 4 4 5 6 6 8 9 11 11 15 22}`;

* write data into sas data set;
create In var {"x"};
append;
close In;

* call sas procedure;
submit;
	proc means data = In noprint;
		var x;
		output out = output skewness = skew;
	run;
endsubmit;

* read results ;
use output;
read all var {"skew"};
close output;
print skew;
* it does show the correct result, but red key words...? ;

submit;
	proc sgplot data = In;
		title "created by proc sgplot";
		histogram x;
		density x / type = kernel;
	run;
endsubmit;
* x is still in the memory for computing ;

*** APPLICATIONS AND STATISTICAL TASKS *** ;
* SIMULATING DATA ;
proc iml;
n = 10;
numSamples = 10000;

call randseed(123);
x = j(n, numSamples);
call randgen(x, "uniform");  * simulate data ;
s = mean(x);

s = t(s);
mean = mean(s);
stdDev = std(s);
print mean stdDev;

* OPTIMIZATION ;
proc iml;
use sashelp.iris;
read all var {sepalwidth} into x;
close sashelp.iris;

* print the optimal parameter values ;
muMLE = mean(x);
n = countn(x);
sigmaMLE = sqrt((n-1)/n * var(x));
print muMLE sigmaMLE;

* log-likelihood function ;
start NormLogLik(parm) global (x);
	mu = parm[1];
	sigma2 = parm[2]##2;
	n = nrow(x);
	return (-n/2*log(sigma2) - 0.5/sigma2*sum((x-mu)##2));
finish;

parm = {35 5.5};
optn = {1, 4};
con = {. 0, . .};

/*5. Provide initial guess and call NLP function*/
call nlpnra(rc, result, "NormLogLik", parm, optn, con);
