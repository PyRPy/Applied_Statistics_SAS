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
