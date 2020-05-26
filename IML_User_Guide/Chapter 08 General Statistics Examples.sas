*** Chapter 08 General Statistics Examples *** ;
* where the programming stype can be learned here in SAS ;
* Example 8.1. Correlation ;
proc iml;
start corr;
	n = nrow(x);
	sum = x[+,]; * column sums ;
	xpx = t(x)*x - t(sum)*sum / n; * sscp matrix;
	s = diag(1/sqrt(vecdiag(xpx))); 
	corr = s*xpx*s;
	print 'correlation matrix',, corr[rowname=nm colname=nm];
finish corr;

start std;
	n = nrow(x);
	mean = x[+,] / n;
	x = x - repeat(mean, n, 1);
	ss = x[##, ];
	std = sqrt(ss/(n-1));
	x = x*diag(1/std);
	print 'std data',, x[colname=nm];
finish std;

* run the sample;
x = {1 2 3,
	 3 2 1, 
	 4 2 1,
	 0 4 1,
	 24 1 0,
	 1 3 8};
nm = {age weight height};
run corr;
run std;
quit;

* new versions are very different and reasonable, similar to R now;
proc iml;
start stdMat(x);
	mean = mean(x);
	cx = x - mean;
	y = cx / std(x);
	return (y);
finish stdMat;

x = { 1 2 3,
      3 2 1,
      4 2 1,
      0 4 1,
     24 1 0,
      1 3 8};
nm = {age weight height};
std = stdMat(x);
print std[colname=nm label="Standardized Data"];

std = std(x);
mean = mean(x);
print std, mean;

cx = x - mean;
print cx;

/* Compute correlations: Assume no missing values  */
start corrMat(x);
   n = nrow(x);                      /* number of observations */
   sum = x[+,];                         /* compute column sums */
   xpx = x`*x - sum`*sum/n;           /* compute sscp matrix   */
   s = diag(1/sqrt(vecdiag(xpx)));           /* scaling matrix */
   corr = s*xpx*s;                       /* correlation matrix */
   return( corr );
finish corrMat;

corr = corrMat(x);
print corr[rowname=nm colname=nm label="Correlation Matrix"];
* Example 8.2. Newton’s Method for Solving Nonlinear Systems of Equations;
* Example 12.3 Regression ;
proc iml;
start regress( x, y, name, tval=, l1=, l2=, l3= );
   n = nrow(x);                          /* number of observations   */
   k = ncol(x);                          /* number of variables      */
   xpx = x` * x;                         /* cross-products           */
   xpy = x` * y;
   xpxi = inv(xpx);                      /* inverse crossproducts    */

   b = xpxi * xpy;                       /* parameter estimates      */
   yhat = x * b;                         /* predicted values         */
   resid = y - yhat;                     /* residuals                */
   sse = resid` * resid;                 /* sum of squared errors    */
   dfe = n - k;                          /* degrees of freedom error */
   mse = sse / dfe;                      /* mean squared error       */
   rmse = sqrt(mse);                     /* root mean squared error  */

   covb = xpxi # mse;                    /* covariance of estimates  */
   stdb = sqrt(vecdiag(covb));           /* standard errors          */
   t = b / stdb;                         /* ttest for estimates=0    */
   probt = 1 - cdf("F",t#t,1,dfe);       /* significance probability */
   paramest = b || stdb || t || probt;
   print paramest[c={"Estimate" "StdErr" "t" "Pr>|t|"} r=name
                  l="Parameter Estimates" f=Best6.];

   s = diag(1/stdb);
   corrb = s * covb * s;                 /* correlation of estimates */
   reset fw=6 spaces=3;                  /* for proper formatting    */
   print covb[r=name c=name l="Covariance of Estimates"],
         corrb[r=name c=name l="Correlation of Estimates"];

   if nrow(tval) = 0 then return;        /* is a t-value specified?  */
   projx = x * xpxi * x`;                /* hat matrix               */
   vresid = (i(n) - projx) * mse;        /* covariance of residuals  */
   vpred = projx # mse;                  /* covariance of pred vals  */
   h = vecdiag(projx);                   /* hat leverage values      */
   lowerm = yhat - tval # sqrt(h*mse);   /* lower conf limit for mean*/
   upperm = yhat + tval # sqrt(h*mse);   /* upper CL for mean        */
   lower = yhat - tval # sqrt(h*mse+mse);/* lower CL for individual  */
   upper = yhat + tval # sqrt(h*mse+mse);/* upper CL                 */

   R = y || yhat || resid || h || lowerm || upperm || lower || upper;
   labels = {"y" "yhat" "resid" "h" "lowerm" "upperm" "lower" "upper"};
   reset fw=6 spaces=1;
   print R[c=labels label="Predicted values, Residuals, and Limits"];

   /* test hypoth that L*b = 0, where L is linear comb of estimates  */
   do i = 1 to 3;
      L = value("L"+ strip(char(i)));   /* get L matrix for L1, L2, and L3 */
      if nrow(L) = 0 then return;
      dfn = nrow(L);
      Lb = L * b;
      vLb = L * xpxi * L`;
      q = Lb` * inv(vLb) * Lb / dfn;
      f = q / mse;
      prob = 1 - cdf("F", f,dfn,dfe);
      test = dfn || dfe || f || prob;
      print L, test[c={"dfn" "dfe" "F" "Pr>F"} f=Best6.
                    l="Test Hypothesis that L*b = 0"];
   end;
finish;

/* Quadratic regression on US population for decades beginning 1790 */
decade = T(1:8);
print decade;
dd = decade##0;
print dd;

name={"Intercept", "Decade", "Decade**2" };
x= decade##0 || decade || decade##2;
y= {3.929,5.308,7.239,9.638,12.866,17.069,23.191,31.443};

/* n-p=5 dof at 0.025 level to get 95% confidence interval */
tval = quantile("T", 1-0.025, nrow(x)-ncol(x));
L1 = { 0 1 0 };   /* test hypothesis Lb=0 for linear coef */
L2 = { 0 1 0,     /* test hypothesis Lb=0 for linear,quad */
       0 0 1 };
L3 = { 0 1 1 };   /* test hypothesis Lb=0 for linear+quad */
option linesize=100;
run regress( x, y, name, tval, L1, L2, L3 );

* Example 12.4 Alpha Factor Analysis;
proc iml;
/*                Alpha Factor Analysis                      */
/*  Ref: Kaiser et al., 1965 Psychometrika, pp. 12-13        */
/*  Input:  r = correlation matrix                           */
/*  Output: m = eigenvalues                                  */
/*          h = communalities                                */
/*          f = factor pattern                               */
start alpha(m, h, f, r);
   p = ncol(r);
   q = 0;
   h = 0;                                      /* initialize */
   h2 = I(p) - diag(1/vecdiag(inv(r)));/* smc=sqrd mult corr */
   do while(max(abs(h-h2))>.001); /* iterate until converges */
      h = h2;
      hi = diag(sqrt(1/vecdiag(h)));
      g = hi*(r-I(p))*hi + I(p);
      call eigen(m,e,g);         /* get eigenvalues and vecs */
      if q=0 then do;
         q = sum(m>1);                  /* number of factors */
         iq = 1:q;
      end;                                   /* index vector */
      mm = diag(sqrt(m[iq,]));           /* collapse eigvals */
      e = e[,iq] ;                       /* collapse eigvecs */
      h2 = h*diag((e*mm) [,##]);        /* new communalities */
   end;
   hi = sqrt(h);
   h = vecdiag(h2);               /* communalities as vector */
   f = hi*e*mm;                         /* resulting pattern */
finish;

/* Correlation Matrix from Harmon, Modern Factor Analysis, */
/* Second edition, page 124, "Eight Physical Variables"    */
nm = {Var1 Var2 Var3 Var4 Var5 Var6 Var7 Var8};
r ={ 1.00 .846 .805 .859 .473 .398 .301 .382 ,
     .846 1.00 .881 .826 .376 .326 .277 .415 ,
     .805 .881 1.00 .801 .380 .319 .237 .345 ,
     .859 .826 .801 1.00 .436 .329 .327 .365 ,
     .473 .376 .380 .436 1.00 .762 .730 .629 ,
     .398 .326 .319 .329 .762 1.00 .583 .577 ,
     .301 .277 .237 .327 .730 .583 1.00 .539 ,
     .382 .415 .345 .365 .629 .577 .539 1.00};
run alpha(Eigenvalues, Communalities, Factors, r);
print Eigenvalues,
      Communalities[rowname=nm],
      Factors[label="Factor Pattern" rowname=nm];
quit;
/*
	12.1 Correlation Computation
    12.2 Newton’s Method for Solving Nonlinear Systems of Equations
    12.3 Regression
    12.4 Alpha Factor Analysis
    12.5 Categorical Linear Models
    12.6 Regression of Subsets of Variables
    12.7 Response Surface Methodology
    12.8 Logistic and Probit Regression for Binary Response Models
    12.9 Linear Programming
    12.10 Quadratic Programming
    12.11 Regression Quantiles
    12.12 Simulations of a Univariate ARMA Process
    12.13 Parameter Estimation for a Regression Model with ARMA Errors
    12.14 Iterative Proportional Fitting
    12.15 Nonlinear Regression and Specifying a Model at Run Time

*/
* will revisit this section as needed;
