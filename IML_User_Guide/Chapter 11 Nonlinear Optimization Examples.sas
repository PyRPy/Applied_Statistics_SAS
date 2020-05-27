*** Chapter 11 Nonlinear Optimization Examples *** ;
* Unconstrained Rosenbrock Function ;
proc iml;
start F_ROSEN(x);
   y1 = 10. * (x[2] - x[1] * x[1]);
   y2 = 1. - x[1];
   f  = .5 * (y1 * y1 + y2 * y2);
   return(f);
finish F_ROSEN;

start G_ROSEN(x);
   g = j(1,2,0.);
   g[1] = -200.*x[1]*(x[2]-x[1]*x[1]) - (1.-x[1]);
   g[2] =  100.*(x[2]-x[1]*x[1]);
   return(g);
finish G_ROSEN;

x = {-1.2 1.};
optn = {0 2};
call nlptr(rc,xres,"F_ROSEN",x,optn) grd="G_ROSEN";
quit;

* Nonlinear Optimization Examples ;
proc iml;
c = { -6.089 -17.164 -34.054  -5.914 -24.721
      -14.986 -24.100 -10.708 -26.662 -22.179 };
start F_BRACK(x) global(c);
   s = x[+];
   f = sum(x # (c + log(x / s)));
   return(f);
finish F_BRACK;

con = { .  .  .  .  .  .  .  .  .  .    .   .  ,
        .  .  .  .  .  .  .  .  .  .    .   .  ,
        1. 2. 2. .  .  1. .  .  .  1.   0.  2. ,
        .  .  .  1. 2. 1. 1. .  .  .    0.  1. ,
        .  .  1. .  .  .  1. 1. 2. 1.   0.  1. };
con[1,1:10] = 1.e-6;

x0 = j(1,10, .1);
optn = {0 3};

title 'NLPTR subroutine: No Derivatives';
call nlptr(xres,rc,"F_BRACK",x0,optn,con);
