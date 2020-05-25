*** Chapter 07 File access *** ;
* writing a matrix to an external file ;
proc iml;
x = {1 1 0 1, 1 0 0 1, 1 1 1 0, 0 1 0 1};

filename out 'user.matrix';
file out;
	do i=1 to nrow(x);
		do j = 1 to ncol(x);
			put (x[i,j]) 1.0 +2 @;
		end;
		put;
	end;
closefile out;

* quick printing to the print file;
file print;
do a=0 to 6.28 by 0.2;
	x = sin(a);
	p = (x + 1) # 30;
	put @1 a 6.4 +p x 8.4;
end;
* not shown properly ;
