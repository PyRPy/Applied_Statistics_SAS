/* BASIC MATRIX OPERATIONS IN PROC IML */
* from appendix B Applied Econometrics Using the SAS System, by Vivek B. Ajmani ;
*** B.1 scalars *** ;
proc iml;
x = {14.5};
print x;

*** B.2 creating matrices and vectors *** ;
A = {2 4, 3 1};
AA = {1,2,3,4};  /* it is a column */
print AA;

*** B.3 elementary matrix operations *** ;
A = {1 2, 3 4};
B = {5 6, 7 8};
C = A*B; /* mat x mat */
print C;

D = A#B; /* element x element */
print D;

Q = A@B; /* chromecker products */
print Q;

invA = inv(A); /* inverse of a mat */
print invA; 

eigA = eigval(A);
eigvA = eigvec(A); /*  Eigenvalues, and Eigenvectors */
print eigA, eigvA;

*** B.4 conparison operators *** ;
minA = min(A);
maxA = max(A);
print minA, maxA;

maxAB = A <> B;
minAB = A >< B;
print maxAB, minAB;

*** B.5 matrix generation functions *** ;
iden = i(3);
print iden;

j1 = j(3,3);
j2 = j(3,3,2);
print j1, j2;

blockAB = block(A, B);
print blockAB;

diagC = diag({1 2 4});
print diagC;

diagD = diag({1 2, 3 4}); /* extract diag */
print diagD;

*** B.6 subset of matrix *** ;
subA = A[, 1];
print subA;

*** B.7 subscript reduction operators *** ;
A = {0 1 2, 5 4 3, 7 6 8};
colSum = A[+, ];
rowSum = A[, +];
colMax = A[<>, ];
rowMin = A[, ><];
colMean = A[:,];
colProd = A[#,];
colSSQ = A[##,];
print colSSQ;

*** B.8 diag and vecdiag *** ;
A = {0 1 2, 5 4 3, 7 6 8};
diagA = diag(A);
diagvA = vecdiag(A);
print diagA, diagvA;

*** B.9 concatenation of matrices *** ;
A = {-1 2, 2 1};
B = {6 7, 8 9};
AandB = A || B;
AonB = A // B;
print AandB, AonB;

*** B.10 control statement *** ;
do index = 1 to 5;
	print index;
end;

if min(A) < 0 then print 'negative data';
else print 'zero or postive data';

*** B.11 calculating summary stats *** ;
/*
proc iml;
	use data;
	summary var {x1 x2 x3} class {i} stat {mean std}
	opt {save};
	print x1;
run; quit;
* just show the template ;
*/
