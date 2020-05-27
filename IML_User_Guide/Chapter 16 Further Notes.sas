*** Chapter 16 Further Notes *** ;
* Efficiency ;
proc iml;

x = {1 2 3,
	 4 5 6,
	 7 8 9};

m = nrow(x);
n = ncol(x);
s = 0;
do i =1 to m;
	do j = 1 to n;
		s = s + x[i,j];
	end;
end;

s1 = j(1,m)*x*j(n,1);
s2 = x[+,+];
s3 = sum(x);

print s, s1, s2, s3;
