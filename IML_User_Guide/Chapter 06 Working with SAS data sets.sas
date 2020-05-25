*** Chapter 06 Working with SAS data sets *** ;
* Syntax for Specifying a SAS Data Set ;
/*
https://documentation.sas.com/?docsetId=imlug&docsetTarget=imlug_worksasdatasets_sect009.htm&docsetVersion=15.1&locale=en
*/
proc iml;
use sashelp.class;
read all var _num_ into X;
clase sashelp.class;

lib = 'sashelp';
dsnames = {"class" "enso" "iris"};
do i = 1 to ncol(dsnames);
	dsname = concat(lib, ".", dsnames[i]);
	use (dsname); 
	read all var _num_ into X[c=varNames];
	print dsname varNames;
	close (dsname);
end;

* Make a SAS Data Set Current ;
use sashelp.class;
setin sashelp.class point 10;

read current var _num_ into x[colname = numVars];
read current var _CHAR_ into c[colname=charVars];
print x[colname=numVars], c[colname = charVars];

* Display SAS Data Set Information ;
use sashelp.class;
show datasets;

show contents;

* List Observations ;
list all;
list;

p = {3 6 9};
list point p;

* Select a Set of Variables ;
varNames = {Name Sex Age};
p = {3 6 9};
use sashelp.class;
list point p var varNames;

* Select a Set of Observations ;
varNames = {Name Sex Age};
use sashelp.class;
list all var varNames where (sex = "M" & Age > 12);

list all var varNames where (name = *{"jon", "carol", "judi"});

* read observations from a SAS dataset ;
* Use the READ Statement with the VAR Clause ;
proc iml;
use sashelp.class;
read all var {age height weight}; *** use {} not () ;
close sashelp.class;

show names;

use sashelp.class;
read all;
close sashelp.class;

show names;

* Use the READ Statement with the INTO Clause ;
proc iml;
use sashelp.class;
read point(1:5) var _num_ into X; *** All Numeric Variables;
print X;

* Use the READ Statement with the WHERE Clause ;
use Sashelp.Class;
read all var _num_ into Female where (sex = 'F');
print female;

*  Names That Begin with the Letter J ;
read all var {name} into J where (name = :"J");
print J;

* Edit a SAS Data Set ;
data Class;
	set Sashelp.Class;
run;

* Update Observations ;
proc iml;
edit class;
find all where (name = {"Henry"}) into obs;
list point obs;

read point obs var {age};
age = age + 1;
replace point obs var {age};
list point obs;
close class;

* Delete Observations ;
edit class;
find all where(name = {'John'}) into obs;
delete point obs;
purge;
show contents;

*** Creating a SAS Data Set from a Matrix *** ;
proc iml;
use sashelp.class;
read all var {name height weight};

hwratio = height / weight;
create ratio from hwrato[colname='htwt'];
append from hwratio;
show contents;
close ratio;

* Use the CREATE Statement with the VAR Clause ;
create ratio2 var {"name" "hwratio"};
append;
show contents;
close ratio2;

* Understand the End-of-File Condition ;
proc iml;
use sashelp.class;
sum = 0;
do data;
	read next var {weight};
	sum = sum + weight;
end;
print sum;

* more efficient way ;
read all var {weight};  *** read it into 'memory';
sum = sum(weight);
print sum;


* Produce Summary Statistics ;
proc iml;
use Sashelp.class;
summary class {sex} var {height weight};

summary class {sex} var {height weight}
        stat {mean std var} opt {noprint save};

show names;
/* print matrices that show the stats */
print height[r=sex c={"Mean" "Std" "Var"}],
      weight[r=sex c={"Mean" "Std" "Var"}];

* Sort a SAS Data Set ;
proc iml;
sort sashelp.class out = sorted by name;


* Indexing a SAS Data Set ;
data Class;
set Sashelp.Class;
run;


proc iml;
use class;
index sex;
list all;

* Data Set Maintenance Functions ;
* Process a Range of Observations ;
proc iml;
use Sashelp.class;

list all;                               /* lists whole data set */
list;                              /* lists current observation */
list var{name age};        /* lists NAME and AGE in current obs */
list all where(age<=13); /* lists all obs where condition holds */
list next;                            /* lists next observation */
list point 18;                          /* lists observation 18 */
range = 10:15;
list point range;           /* lists observations 10 through 15 */

close Sashelp.class;

* Select Variables with the VAR Clause ;
proc iml;
use Sashelp.Class;
read all var {age sex};        /* a literal matrix of names        */
varNames = {"weight" "height"};
read all var varNames;         /* a matrix that contains the names */
read all var _NUM_ into X;     /* a keyword                        */
close Sashelp.Class;

x1 = X[,1];
x2 = X[,2];
x3 = X[,3];
create Test var ("x1":"x3"); 
append;
close Test;

proc print data = Test;
run;
