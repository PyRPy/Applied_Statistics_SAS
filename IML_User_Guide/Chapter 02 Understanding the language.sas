*** Chapter 02 Understanding the language ***;
* Scalar Literals ;
proc iml;

a = 12;
a = .;
a = 'hi there';
a = "hello";

* row vector;
x={1 2 3 4 5 6};

* column vector ;
y={1,2,3,4,5};

* matrix ;
z={1 2, 3 4, 5 6};
w = 3#z;
print w;

a = {abc defg};
b = {'abc' 'DEFG'};

* repetition factors ;
title '';
answer1 = {[2] 'yes', [2] 'no'};
answer2 = {'yes' 'yes', 'no' 'no'};
print answer1 answer2;
quit;

*** Control Statements *** ;
proc iml;
a = {1 2 3, 4 5 6, 7 8 9};
b = {2 2 2};

show names;




