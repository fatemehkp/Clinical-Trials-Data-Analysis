***********************************************************;
* Generating Demographics Table for...					  *;
* ...Clinical Study Reports (CRFs) 						  *;
***********************************************************;
* Importing the demographic data from Ecxel                *;
filename reffile 
	'/home/fkazem010/Clinical-Trials-Data-Analysis/data/demog-1.xls';

proc import datafile=reffile dbms=xls out=demog;
	getnames=yes;
run;

proc contents data=demog;
run;

***********************************************************;
* Section 1: Summary Statistics for Age		 		      *;

data demog1;
	set demog;
	format dob1 date9.;
	*creating a new variable for date of birth;
	dob=compress(cat(month, '/', day, '/', year));
	dob1=input(dob, mmddyy10.);
	*calculating the age of patients;
	age=(diagdt-dob1)/365;
	*adding third treatment group(aka All patients);
	output;
	trt=2;
	output;
run;

***********************************************************;
* Evaluating the statistical parameters for age  	      *;

proc sort data=demog1;
	by trt;
run;

proc means data=demog1 noprint;
	var age;
	output out=agestats;
	by trt;
run;