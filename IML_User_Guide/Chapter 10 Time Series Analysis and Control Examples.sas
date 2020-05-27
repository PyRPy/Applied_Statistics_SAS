/* Chapter 10 Time Series Analysis and Control Examples */
*** Basic Time Series Subroutines ;
proc iml;
/* ARMA(2,1) model */
phi = {1 -0.5 0.04};
theta = {1 0.25};
mu = 10;
sigma = 2;
nobs = 100;
seed = 3456;
lag = 10;
yt = armasim(phi, theta, mu, sigma, nobs, seed);

* Autocovariance Functions of ARMA(2,1) Model (ARMACOV) ;
call armacov(autocov, cross, convol, phi, theta, lag);
autocov = autocov`;  cross = cross`;  convol = convol`;
print autocov cross convol;

* Log-Likelihood Function of ARMA(2,1) Model (ARMALIK);
call armalik(lnl, resid, std, yt, phi, theta);
resid=resid[1:9];
std=std[1:9];
print lnl resid std;

* Kalman Filter Subroutines ;
title 'Likelihood Evaluation of SSM';
title2 'DATA: Annual Real GNP 1909-1969';
data gnp;
  input y @@;
datalines;
116.8 120.1 123.2 130.2 131.4 125.6 124.5 134.3
135.2 151.8 146.4 139.0 127.8 147.0 165.9 165.5
179.4 190.0 189.8 190.9 203.6 183.5 169.3 144.2
141.5 154.3 169.5 193.0 203.2 192.9 209.4 227.2
263.7 297.8 337.1 361.3 355.2 312.6 309.9 323.7
324.1 355.3 383.4 395.1 412.8 406.0 438.0 446.1
452.5 447.3 475.9 487.7 497.2 529.8 551.0 581.1
617.8 658.1 675.2 706.6 724.7
;

proc print data = gnp;
run;

proc iml;
start lik(y,a,b,f,h,var,z0,vz0);
    nz = nrow(f);  n = nrow(y);   k = ncol(y);
    pi = constant('pi');
    const = k*log(2*pi);
    if ( sum(z0 = .) | sum(vz0 = .) ) then
       call kalcvf(pred,vpred,filt,vfilt,y,0,a,f,b,h,var);
    else
       call kalcvf(pred,vpred,filt,vfilt,y,0,a,f,b,h,var,z0,vz0);
    et = y - pred*h`;

    sum1 = 0;  sum2 = 0;
    do i = 1 to n;
       vpred_i = vpred[(i-1)*nz+1:i*nz,];

* prediciton step ;
z0 = j(1,nrow(f),0);
vz0 = 10#i(nrow(f));
call kalcvf(pred0,vpred,filt0,vfilt,y,1,a,f,b,h,var,z0,vz0);

/* print results for the first few observations */
y0 = y;
y    = y0[1:16];
pred = pred0[1:16,];
filt = filt0[1:16,];
print y pred filt;
       et_i = et[i,];
       ft = h*vpred_i*h` + var[nz+1:nz+k,nz+1:nz+k];
       sum1 = sum1 + log(det(ft));
       sum2 = sum2 + et_i*inv(ft)*et_i`;
    end;
    return(-.5*const-.5*(sum1+sum2)/n);
finish;

use gnp;
read all var {y};
close gnp;

f = {1 1, 0 1};
h = {1 0};
a = j(nrow(f),1,0);
b = j(nrow(h),1,0);
var = diag(j(1,nrow(f)+ncol(y),1e-3));

/*-- initial values are computed --*/
z0 = j(1,nrow(f),.);
vz0 = j(nrow(f),nrow(f),.);
logl = lik(y,a,b,f,h,var,z0,vz0);
print 'No initial values are provided', logl;

/*-- initial values are given --*/
z0 = j(1,nrow(f),0);
vz0 = 1e-3#i(nrow(f));
logl = lik(y,a,b,f,h,var,z0,vz0);
print 'Initial values are provided', logl;

* Stationary VAR Process ;
proc iml;
/* stationary VAR(1) model */
sig = {1.0  0.5, 0.5 1.25};
phi = {1.2 -0.5, 0.6 0.3};
call varmasim(yt,phi) sigma=sig n=100 seed=3243;

call vtsroot(root,phi);
print root[c={R I 'Mod' 'ATan' 'Deg'}];

* Fractionally Integrated Time Series Analysis ;
proc iml;
/* ARFIMA(0,0.4,0) */
lag = (0:12)`;
call farmacov(autocov_D_IS_04, 0.4);
call farmacov(D_IS_005, 0.05);
print lag autocov_D_IS_04 D_IS_005;

d = 0.4;
call farmasim(yt, d) n=300 sigma=2 seed=5345;
call fdif(zt, yt, d);

call farmalik(lnl, yt, d);
print lnl;

call farmafit(d, ar, ma, sigma, yt);
print d sigma;
