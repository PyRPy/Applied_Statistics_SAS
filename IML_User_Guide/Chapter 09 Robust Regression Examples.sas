*** Chapter 09 Robust Regression Examples *** ;
* Example 15.1 Robust Regression and Leverage Points ;
proc iml;
/* Hertzsprung-Russell Star Data */
/*  ObsNum LogTemp LogIntensity  */
hr = { 1  4.37  5.23,   2  4.56  5.74,   3  4.26  4.93,
       4  4.56  5.74,   5  4.30  5.19,   6  4.46  5.46,
       7  3.84  4.65,   8  4.57  5.27,   9  4.26  5.57,
      10  4.37  5.12,  11  3.49  5.73,  12  4.43  5.45,
      13  4.48  5.42,  14  4.01  4.05,  15  4.29  4.26,
      16  4.42  4.58,  17  4.23  3.94,  18  4.42  4.18,
      19  4.23  4.18,  20  3.49  5.89,  21  4.29  4.38,
      22  4.29  4.22,  23  4.42  4.42,  24  4.49  4.85,
      25  4.38  5.02,  26  4.42  4.66,  27  4.29  4.66,
      28  4.38  4.90,  29  4.22  4.39,  30  3.48  6.05,
      31  4.38  4.42,  32  4.56  5.10,  33  4.45  5.22,
      34  3.49  6.29,  35  4.23  4.34,  36  4.62  5.62,
      37  4.53  5.10,  38  4.45  5.22,  39  4.53  5.18,
      40  4.43  5.57,  41  4.38  4.62,  42  4.45  5.06,
      43  4.50  5.34,  44  4.45  5.34,  45  4.55  5.54,
      46  4.45  4.98,  47  4.42  4.50 } ;

x = hr[,2]; y = hr[,3];

optn = j(9,1,.);
optn[2]= 1;    /* do not print residuals, diagnostics, or history */
optn[3]= 3;    /* compute LS, LMS, and weighted LS regression */

ods select LSEst EstCoeff RLSEstLMS;
call lms(sc, coef, wgt, optn, y, x);
ods select all;

* LMS ;
r1 = {"Quantile", "Number of Subsets", "Number of Singular Subsets",
       "Number of Nonzero Weights", "Objective Function",
       "Preliminary Scale Estimate", "Final Scale Estimate",
       "Robust R Squared", "Asymptotic Consistency Factor"};
r2 = { "WLS Scale Estimate", "Weighted Sum of Squares",
       "Weighted R-squared", "F Statistic"};
sc1 = sc[1:9];
sc2 = sc[11:14];
print sc1[r=r1 L="LMS Information and Estimates"],
      sc2[r=r2 L="Weighted Least Squares"];

* LTS ;
optn = j(9,1,.);
optn[2]= 3;    /* print a maximum amount of information */
optn[3]= 3;    /* compute LS, LTS, and weighted LS regression */

ods select BestHalf EstCoeff;
call lts(sc, coef, wgt, optn, y, x);
ods select all;

*** Using the MVE and MCD Subroutines *** ;
* Example 15.4 Relationship between Brain Mass and Body Mass ; 
%include sampsrc(robustmc);   /* define graphing modules */
proc iml;
load module=_all_;            /* load graphing modules */

/* Log(Body Mass) Log(Brain Mass) */
mass={ 0.1303338  0.9084851,  2.6674530  2.6263400,
       1.5602650  2.0773680,  1.4418520  2.0606980,
       0.0170333  0.7403627,  4.0681860  1.6989700,
       3.4060290  3.6630410,  2.2720740  2.6222140,
       2.7168380  2.8162410,  1.0000000  2.0606980,
       0.5185139  1.4082400,  2.7234560  2.8325090,
       2.3159700  2.6085260,  1.7923920  3.1205740,
       3.8230830  3.7567880,  3.9731280  1.8450980,
       0.8325089  2.2528530,  1.5440680  1.7481880,
      -0.9208187  0.0000000, -1.6382720 -0.3979400,
       0.3979400  1.0827850,  1.7442930  2.2430380,
       2.0000000  2.1959000,  1.7173380  2.6434530,
       4.9395190  2.1889280, -0.5528420  0.2787536,
      -0.9136401  0.4771213,  2.2833010  2.2552720};

optn = j(5,1,.);
optn[1] = 1;             /* print basic output */
optn[2] = 1;             /* print covariance matrices */
optn[5]= -1;             /* nrep: use all subsets */

ods exclude EigenRobust Distances DistrRes;
call mve(sc, xmve, dist, optn, mass);
ods select all;

* more output ;
r1 = {"Quantile", "Number of Subsets", "Number of Singular Subsets",
      "Number of Nonzero Weights", "Min Objective Function",
      "Min Distance", "Chi-Square Cutoff Value"};
RobustCenter = xmve[1,];
RobustCov =    xmve[3:4,];
print sc[r=r1],
      RobustCenter[c={"X1","X2"}],
      RobustCov[r={"X1","X2"} c={"X1","X2"}];
MVEOutliers = loc(dist[3,]=0);
print MVEOutliers;

* scatter plot ;
optn = j(5,1,.); optn[5]= -1;
vnam = {"Log(Body Mass)","Log(Brain Mass)"};
titl = "Estimates of Location and Scale (MVE)";
call MVEScatter(mass, optn, 0.9, vnam, titl);

/* MCD: Use Random Subsets */
optn = j(5,1,.);
call mcd(sc, xmve, dist, optn, mass);

r1 = {"Quantile", "Number of Subsets", "Number of Singular Subsets",
      "Number of Nonzero Weights", "Min Objective Function",
      "Min Distance", "Chi-Square Cutoff Value"};
RobustCenter = xmve[1,];
RobustCov =    xmve[3:4,];
print sc[r=r1],
      RobustCenter[c={"X1","X2"}],
      RobustCov[r={"X1","X2"} c={"X1","X2"}];

/* plot the classical and robust confidence ellipsoids, as follows */
optn = j(5,1,.); optn[5]= -1;
vnam = { "Log(Body Mass)","Log(Brain Mass)" };
titl = "Estimates of Location and Scale (MCD)";
call MCDScatter(mass, optn, 0.9, vnam, titl);

/* Example 15.5 Multivariate Location, Scale, and Outliers */

%include sampsrc(robustmc);   /* define graphing modules */
proc iml;
load module=_all_;            /* load graphing modules */
 /* Obs X1  X2  X3   Y  Stack Loss data */
SL = { 1  80  27  89  42,
       2  80  27  88  37,
       3  75  25  90  37,
       4  62  24  87  28,
       5  62  22  87  18,
       6  62  23  87  18,
       7  62  24  93  19,
       8  62  24  93  20,
       9  58  23  87  15,
      10  58  18  80  14,
      11  58  18  89  14,
      12  58  17  88  13,
      13  58  18  82  11,
      14  58  19  93  12,
      15  50  18  89   8,
      16  50  18  86   7,
      17  50  19  72   8,
      18  50  19  79   8,
      19  50  20  80   9,
      20  56  20  82  15,
      21  70  20  91  15 };
x = SL[, 2:4]; y = SL[, 5];

optn = j(5,1,.);
optn[1] = 1;             /* print basic output */
optn[2] = 1;             /* print covariance matrices */
optn[5]= -1;             /* nrep: use all subsets */

ods select ClassicalMean ClassicalCov RobustMVELoc RobustMVEScatter;
call mve(sc, xmve, dist, optn, x);
ods select all;


optn = j(5,1,.); optn[5]= -1;
vnam = {"Rate", "Temperature", "AcidConcent"};
titl = "Stack Loss Data: Use All Subsets";
call MVEScatter(x, optn, 0.9, vnam, titl);

* scatter plots ;
optn = j(5,1,.); optn[5]= -1;
vnam = {"Rate", "Temperature", "AcidConcent"};
titl = "Stack Loss Data: Use All Subsets";
call MVEScatter(x, optn, 0.9, vnam, titl);

* Diagnostic Plots for Robust Regression ;
%include sampsrc(robustmc);   /* define graphing modules */
proc iml;
load module=_all_;            /* load graphing modules */

   /* Obs X1  X2  X3   Y  Stack Loss data */
SL = { 1  80  27  89  42,
       2  80  27  88  37,
       3  75  25  90  37,
       4  62  24  87  28,
       5  62  22  87  18,
       6  62  23  87  18,
       7  62  24  93  19,
       8  62  24  93  20,
       9  58  23  87  15,
      10  58  18  80  14,
      11  58  18  89  14,
      12  58  17  88  13,
      13  58  18  82  11,
      14  58  19  93  12,
      15  50  18  89   8,
      16  50  18  86   7,
      17  50  19  72   8,
      18  50  19  79   8,
      19  50  20  80   9,
      20  56  20  82  15,
      21  70  20  91  15 };
x = SL[, 2:4]; y = SL[, 5];

LMSOpt = j(9,1,.);
MCDOpt = j(5,1,.);
MCDOpt[5]= -1;             /* nrep: all subsets */

run RDPlot("LMS", LMSOpt, MCDOpt, y, x);
