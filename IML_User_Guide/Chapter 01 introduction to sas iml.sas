*** Chapter 01 introduction to sas/iml *** ;
* find the square root of a number or vector ;
proc iml;
start approx(x);
	y = 1;
	do until (w < 1e-3);
		z = y;
		y = 0.5#(z + x / z);
		w = abs(y - z);
	end;
	return (y);
finish approx;

t = approx({3, 5, 7, 9});
print t;
quit;
