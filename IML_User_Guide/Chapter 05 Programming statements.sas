*** Chapter 05 Programming statements *** ;
*** IF-THEN/ELSE Statements ;
proc iml;

a = {17 22, 13 10};
if max(a) < 20 then
	p = 1;
else p = 0;

print p;

* DO DATA Statements ;
filename MyFile 'MyData.txt';
infile MyFile;                 /* infile statement       */
do data;                       /* begin read loop        */
   input Name $6. x y;         /* read a data value      */
   /* do something with each value */
end;
closefile MyFile;

*** DO loops;
y = 0;
do i = 1 to 10 by 2;
	y = y + i;
	print y;
end;

* DO WHILE Statements ;
count = 1;
do while (count < 5);
	count = count + 1;
	print count;
end;

* DO UNTIL Statements;
count = 1;
do until (count > 5);
	count = count + 1;
	print count;
end;

* Jump Statements;
x = - 2;
do;
	if x < 0 then goto negative;
	y = sqrt(x);
	print y;
	stop;
negative:
	print "sorry, x is negative";
end;

* rewrite it into;
if x < 0 then print "sorry, x is negative";
else
	do;
		y = sqrt(x);
		print y;
	end;

*** Modules *** ;
* Modules with No Arguments ;
/* module without arguments, all symbols are global.  */
proc iml;
a = 10;
b = 20;
c = 30;
start mod1;
	p = a + b;
	c = 40;
finish;

run mod1;
print a b c p;

* Modules with Arguments;
proc iml;
a = 10;
b = 20;
c = 30;
start mod2(x, y);
	p = x + y;
	x = 100;
	c = 25;
finish mod2;

run mod2(a, b);
print a b c;

* Passing Arguments by Using Keyword-Value Pairs ;
start Sum5(x, a=1, b=2, c=3, d=4, e=5);
   x = a + b + c + d + e;
finish;

run Sum5(x,,,,,10);  /* skip some positional parameters    */
run Sum5(x) e=10;    /* equivalent, but simpler            */
print x;

* Defining Function Modules;
proc iml;
a = 10;
b = 20;
c = 30;
start mod3(x, y);
	c = 2#x + y;
	return (c);
finish mod3;

z = mod3(a, b);
print a b c z;

* another example ;
proc iml;
start add(x, y);
	sum = x + y;
	return (sum);
finish;

a = {9 2, 5 7};
b = {1 6, 8 10};
c = add(a, b);
print c;

* nested input ;
d = Add(Add({1 2},{3 4}), Add({5 6}, {7 8}));
print d;

* Using the GLOBAL Clause;
proc iml;
a = 10;
b = 20;
c = 30;
start mod4(x, y) global (c);
	x = 100;
	c = 40;
	b = 500;
finish mod4;

run mod4(a, b);
print a b c;

* Modules with Optional and Default Arguments ;
proc iml;
start myAdd(x, y=);
	if ncol(y) = 0 then return (x);
	return (x + y);
finish;

z = myadd(5);
w = myadd(5, 3);
print z, w;

* isskepped () ;
start mydot(x, y=);
	if isskipped(y) then return (x`*x);
	return (x`*y);
finish;
z = mydot({1,2,3});
w = mydot({1,2,3}, {-1,0,1});
print z w;

*isskipped () and # 
start axpy(a=1, x, y=); /* compute ax + y */
   if isskipped(y) then return(a#x);
   else                 return(a#x + y);
finish;

p = {1 2 3};
q = {1 1 1};
z1 = axpy( , p);    /* a and y skipped; a has default value */
z2 = axpy(2, p);    /* y skipped */
z3 = axpy(2, p, q); /* no arguments are skipped */
print z1, z2, z3;
 
* Optional Arguments with Data-Dependent Default Values ;
start stdize(x, loc=mean(x), scale=std(x));
   return ( (x-loc)/scale );
finish;

x = {1, 1, 0, -1, -1};
z = stdize(x);             /* use default values */

center = 1;  s  = 2;
z1 = stdize(x,  center);    /* skip 3rd argument */
z2 = stdize(x,        , s); /* skip 2nd argument */
z3 = stdize(x,  center, s); /* no arguments are skipped */
print z z1 z2 z3;

* Nesting Module Definitions ;
start ModB;
   x = 1;
finish ModB;

start ModA;
   run ModB;
finish ModA;

run ModA;
print x;

*Calling a Module from Another Module ;
* Understanding Argument Passing ;
proc iml;
start square(a, b);
	a = b##2;
finish;

x = {. .};
y = {3 4};
reset printall;
do i = 1  to 2;
	run square(x[i], y[i]);
end;
print x;

* just run the module;
run square(x, y);
print x;

*** Termination Statements *** ;
msg = "Please enter an assignment for X, then enter RESUME;"; 
pause msg; 

QUIT;
