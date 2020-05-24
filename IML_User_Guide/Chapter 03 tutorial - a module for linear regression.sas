*** Chapter 03 tutorial - a module for linear regression *** ;
*** Solving a System of Equations *** ;
*** to do list : module not working properly somehow *** ;

proc iml;
reset print;

a = {3 -1 2,
	 2 -2 3,
	 4 1 -4};
print a;

c = {8, 2, 9};

x = inv(a) * c;
print x;
quit;

*** A Module for Linear Regression *** ;
proc iml;
x={1 1 1,
   1 2 4,
   1 3 9,
   1 4 16,
   1 5 25};

y = {1,5,9,23,36};

b = inv(x` * x) * x` * y;
print b;

yhat = x*b;
r = y - yhat;

sse = ssq(r);
dfe = nrow(x) - ncol(x);
mse = sse/dfe;
print mse;

*** to write a module for the lines above to reuse the codes *** ;
start regress;
	xpxi = inv(t(x)*x);
	beta = xpxi*(t(x)*y);
	yhat = x*beta;
	resid = y - yhat;
	sse = ssq(resid);
	n = nrow(x);
	dfe = nrow(x) - ncol(x);
	mse = sse / dfe;
	cssy = ssq(y - sum(y)/n);
	resquare = (cssy - sse) / cssy;
	print, "regression results", 
			sse dfe mse rsquare;
	stdb = sqrt(vecdiag(xpxi)*mse);
	t = beta / stdb;
	prob = 1- probf(t#t, 1, dfe);
	print, "parameter estimates", ,,
			beta stdb t prob;
	print, y yhat resid;
finish regress;

reset noprint;
run regress;

quit;

covb = xpxi * mse;
s = 1 / sqrt(vecdiag(covb));
corrb = diag(s) * covb * diag(s);


proc iml;

x1={1,2,3,4,5};
x=orpol(x1,2);
y = {1,5,9,23,36};


start regress;
	xpxi = inv(t(x)*x);
	beta = xpxi*(t(x)*y);
	yhat = x*beta;
	resid = y - yhat;
	sse = ssq(resid);
	n = nrow(x);
	dfe = nrow(x) - ncol(x);
	mse = sse / dfe;
	cssy = ssq(y - sum(y)/n);
	resquare = (cssy - sse) / cssy;
	print, "regression results", 
			sse dfe mse rsquare;
	stdb = sqrt(vecdiag(xpxi)*mse);
	t = beta / stdb;
	prob = 1- probf(t#t, 1, dfe);
	print, "parameter estimates", ,,
			beta stdb t prob;
	print, y yhat resid;
finish regress;

reset noprint; 
run regress;

*** Plotting Regression Results *** ;
proc iml;
x={1 1 1,
   1 2 4,
   1 3 9,
   1 4 16,
   1 5 25};

y = {1,5,9,23,36};

b = inv(x` * x) * x` * y;
print b;

yhat = x*b;
r = y - yhat;

sse = ssq(r);
dfe = nrow(x) - ncol(x);
mse = sse/dfe;
print mse;

x2 = {1,2,3,4,5};
xy = x2 || r;

call pgraf(xy, 'r', 'x', 'residuals', 'plot of residuals');

yyhat = y || yhat;
call pgraf(yyhat, 'y', 'yhat', 'plot of y and yhat');

newxy = (x2//x2) ||(y//yhat);
n = nrow(x2);
label = repeat('y', n, 1) // repeat('p', n, 1);
call pgraf(newxy, label, 'x', 'y', 'scatter plot with regression line');

QUIT;
