*** Chapter 04 working with matrices *** ;
* Scalars * ;
proc iml;
x=12; 
y=12.34; 
z=.; 
a='Hello'; 
b="Hi there"; 
print x y z a b;

* Matrices with Multiple Elements ;
coffee={4 2 2 3 2,        
		3 3 1 2 1,         
		2 1 0 2 1,        
		5 4 4 3 4};

names={Jenny, Linda, Jim, Samuel};
print coffee [rowname = names];

/* element-wise multiplication operator (#) */
reset noprint;
daycost = 0.3#coffee;
print 'daily totals', daycost[rownames=names format=8.2];

* total for each person, row sum ;
ones = {1,1,1,1,1};
weektot = daycost * ones;
print 'week total', weektot[rowname = names format=8.2];

* more ;
grandtot = sum(coffee);
average = grandtot / ncol(coffee);
print 'total number of cups', grandtot,,'daily average', average;

*** Matrix-generating Functions *** ;
* The BLOCK Function;
a={1 1,1 1};
b={2 2, 2 2};
c=block(a,b);
print c;

* The J Function ;
one = j(1, 5, 1);
print one;

* The I Function ;
I3 = I(3);
print I3;

* The DESIGNF Function ;
* treatment factor has three levels and there aren1=3,n2=2,and
n3=2observations at the factor levels:;

d = designf({1,1,1,2,2,3,3});
print d;


* the shape function ;
aa = shape({99 33,99 33}, 3, 3);
print aa;

aa = shape({99 33,99 33},3,3,0);
print aa;

* Index Vectors ;
r = 1:5;
s = 10:6;
t = 'abc1':'abc5';
print r, s, t;

r = do(-1, 1, 0.5);
print r;

*** Using Matrix Expressions *** ;

*** Elementwise Binary Operators *** ;
A = {2 2, 3 4};
B = {4 5, 1 0};

C = A + B;
print C;

AB = A#B;
print AB;

A2 = A##2;
print A2;

ABmax = A <> B;
print ABmax;

ABsmall = A <= B;
print ABsmall;

Amod = MOD(A,3);
print Amod;

x = A#(A > 2);
print x;


*** Subscripts *** ;
print  coffee[rowname=names];
* Selecting a Single Element ;
c21 = coffee[2,1];
print c21;

c6 = coffee[6];
print c6;

* Selecting a Row or Column ;
jim = coffee[3, ];
print jim;

friday = coffee[,5];
print friday;

* Submatrices ;
submat1 = coffee[{1 3}, {2 3 5}];
print submat1;

rows = {1 3};
cols = {2 3 5};
submat1 = coffee[rows, cols];
print submat1;

* Subscripted Assignment ;
coffee[1,2] = 4;
print coffee;

coffee[,5] = {0,0,0,0};
print coffee;

t={ 3  2 -1, 
	6 -4  3,
	2  2  2};
print t;

i = loc(t<0);
print i;

t[i] = 0;
print t;

t[loc(t<0)] = 0;
print t;

* Subscript Reduction Operators :;

A = {0 1 2,
	 5 4 3,
	 7 6 8};

sum23= A[{2 3},+];
print sum23;

Amax = A[<>, +];
print Amax;

Amean = A[:];
print Amean;

*** Displaying   Matrices   with   Row   and   ColumnHeadings *** ;
* dataframes in R ;

reset autoname;
print coffee;

* Using the ROWNAME= and COLNAME= Options ;
names={jenny linda jim samuel};
days={mon tue wed thu fri};
print coffee[rowname=names colname=days];

* Using the MATTRIB Statement ;
mattrib coffee rowname = ({jenny linda jim samuel})
	colname=({mon tue wed thu fri})         
	label='Weekly Coffee'
	format = 2.0;
print coffee;

*** More on Missing Values *** ;
X = {1 2 .,
	 . 5 6,
	 7 . 9};
Y = {4 . 2,
	 2 1 3,
	 6 . 5};

XandY = X + Y;
print XandY;

XY = X#Y;
print XY;

Xcolsum = X[+,];
print Xcolsum;

XmY = X * Y;
print XmY;
* wrong output for mat * mat operation ;
