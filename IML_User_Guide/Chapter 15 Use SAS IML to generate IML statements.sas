*** Chapter 15 Use SAS IML to generate IML statements *** ;
proc iml;
start testpush;
	print 'start the module testpush';
	print '*** should be 1, 2, 3:';
	code = ' do i = 1 to 3; print i; end; ';
	call push(code, 'resume;');
	pause;
	print '*** exiting ***';
finish; 

run testpush;

* Feeding an Interactive Program ;
      /* the function that prompts the user */
   start delall;
      file log;
      put 'Do you really want to delete all records? (yes/no)';
      infile cards;
      input answer $;
      if upcase(answer)='YES' then
         do;
            delete all;
            purge;
            print "*** FROM DELALL:
            should see End of File (no records to list)";
            list all;
         end;
   finish;

     /* Create a dummy data set for delall to delete records  */
   xnum = {1 2 3, 4 5 6, 7 8 0};
   create dsnum1 from xnum;
   append from xnum;
      do;
         call push ('yes');
         run delall;
      end;

* Macro Interface ;
       /* function: y = macxpand(x);                         */
       /* macro-processes the text in x                      */
       /* and returns the expanded text in the result.       */
       /* Do not use double quotes in the argument.          */
       /*                                                    */
   start macxpand(x);
      call execute('Y="',x,'";');
      return(y);
   finish;

   %macro verify(index);
       data _null_;
          infile junk&index;
          file print;
          input;
          put _infile_;
       run;
   %mend;
   y = macxpand('%verify(1)');
   print y;
