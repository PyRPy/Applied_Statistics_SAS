*** A brief introduction to the IML procedure *** ;
*** the code comes from textbook 'Applied Multivariate Statistics with SAS 1999'; 
*** A.1 The first statement *** ;
proc iml;
	d = 7.856;
	print d;
run;


*** A.14 Symmetric square root of a symmetric nonnegative definite matrix ***;
proc iml;
	
	a = {
		10 3 9,
		3 40 8,
		9 8 15};
	call eigen(d, p, a);
	lam_half = root(diag(d));
	a_half = p*lam_half*t(p);
	print a, p, lam_half;
	print a_half;
run;

*** A.17 construction of a design matrix *** ;
proc iml;
	address = {1,1,1,2,2,3,3,3,3,3};
	x_w_out = design(address);
	print x_w_out;
run;

*** A.19 creating a matrix from a SAS data set *** ;
data mydata;
	input x1 x2 x3;
datalines;
2 4 8
3 9 1
9 4 8
1 1 1
2 7 8
;
proc print data = mydata;
run;

proc iml;
	use mydata;
	read all into mymatrix;
	print mymatrix;
run;
*** read only seleted columns ;
proc iml;
	use mydata;
	read all var {x3 x1} into mymatrix;
	print mymatrix;
run;

*** A.20 creating a SAS data set from a matrix *** ;
proc iml;
	mymatrix = {
				2 4 8,
				3 9 1,
				9 4 8,
				1 1 1,
				2 7 8};
	create newdata from mymatrix;
	append from mymatrix;
	close newdata;
proc print data = newdata;
run;
