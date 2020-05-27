*** Chapter 12 Graphics examples *** ;

proc iml;
x = {[7]A [8]B [3]C};  /* repetition factors: 7 As, 8 Bs, and 3 Cs */
create Bar var {x}; append; close Bar;       /* write SAS data set */
print x;
submit;
   proc sgplot data=Bar;
      vbar x;
   run;
endsubmit;

/* module to create a bar chart from data in X */
proc iml;
title '';
start BarChart(x);
   create Bar var {x}; append; close Bar;  /* write to SAS data set  */
   submit;
      proc sgplot data=Bar;                /* create the plot     */
         vbar x;
      run;
   endsubmit;
   call delete("Bar");                     /* delete the data set */
finish;

x = {[7]A [8]B [3]C};
run BarChart(x);                           /* call the module     */

* Examples of Creating Graphs ;
* Bar Charts ;
/*
* the following codes are not working due to upper/lower case;
proc iml;
use sashelp.cars where(type ? {"suv" "truck" "sedan"});
read all var {origin type};
close sashelp.cars;

title 'bar chart with default props';
call Bar(origin);
*/
proc iml;
use Sashelp.Cars where(type ? {"SUV" "Truck" "Sedan"});
read all var {origin type};
close Sashelp.Cars;

title "Bar Chart with Default Properties";
call Bar(origin);

* boxplot ;
proc iml;
use Sashelp.Cars where(type ? {"SUV" "Truck" "Sedan"});
read all var {MPG_City Origin Type Make Model};
close Sashelp.Cars;

title "Box Plot with Default Properties";
call Box(MPG_City);

title "Category and Data Labels";
call Box(MPG_City) Category=Origin grid="y"
                   label={"Country of Origin" "MPG City"}
                   datalabel=putc(Model,"$10.") option="spread";

* Histograms ;

proc iml;
use Sashelp.Cars;
read all var {MPG_City};
close Sashelp.Cars;

title "Histogram with Default Properties";
call Histogram(MPG_City);

title "Histogram with Density Curves";
call Histogram(MPG_City)
          scale="Percent"
          density={"Normal" "Kernel"}
          rebin={0 5}
          grid="y"
          label="Miles per Gallon (City)"
          xvalues=do(0, 60, 10);

* Scatter Plots ;
proc iml;
use Sashelp.Cars;
read all var {MPG_City MPG_Highway Origin};
close Sashelp.Cars;

title "Scatter Plot with Default Properties";
run Scatter(MPG_City, MPG_Highway);

title "Scatter Plot with a Diagonal Line";
run Scatter(MPG_City, MPG_Highway)
    group=Origin                  /* assign color/marker shape */
    other="refline 25 50 /axis=y" /* add reference line */
    label={"MPG_City" "MPG_Highway"}
    lineparm={0 6.15 1.03}        /* diagonal line */
    yvalues=do(15,60,15);

* Series Plots ;
proc iml;
x = do(-5, 5, 0.1);
y1= pdf("Normal", x, 0, 1);
title 'series plot';
run Series(x, y1);

title "Series Plot with Groups and Reference Lines";
y2 = pdf("Normal", x, 0, 1.5);
g = repeat({1,2}, 1, ncol(x));   /* 1,1,1,...,2,2,2 */
x = x  || x ;
y = y1 || y2;

call Series(x, y) group=g                 /* assign color/marker shape */
                 other="refline -2 2 / axis=x"   /* add reference line */
                 grid={X Y}
                 label={"X" "Normal Density"}
                 xvalues=-4:4
                 yvalues=do(0,0.4,0.05);

* Matrix Heat Maps ;
proc iml;
use sashelp.class;
read all var _num_ into students[c=varNames r=Name];
close sashelp.class;

call sortndx(idx, students, 1:2, 1:2);
students = students[idx,];
Names = Name[idx];

/* standardize each column */
call HeatmapCont(Students) scale="Col"
        xvalues=varNames yvalues=Name title="Student Data";

proc iml;
use Sashelp.Cars;
read all var _NUM_ into Y[c=varNames];
close Sashelp.Cars;
corr = corr(Y);

/* You can visualize the correlations as a continous heat map:
      call HeatmapCont(corr) xvalues=varNames yvalues=varNames;
   Alternatively, bin the values into five categories, as follows: */
Bins = {"1: V. Neg", "2: Neg", "3: Neutral", "4: Pos", "5: V. Pos"};
idx = bin(corr, {-1, -0.6, -0.2, 0.2, 0.6, 1});
disCorr = shape(Bins[idx], nrow(corr));
call HeatmapDisc(disCorr) title="Correlations"
                 xvalues=varNames yvalues=varNames
                 LegendTitle="Magnitude";
