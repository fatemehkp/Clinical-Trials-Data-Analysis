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
	dob=compress(cat(month,'/',day,'/',year));
	dob1=input(dob,mmddyy10.);
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

* Making "agestats" table compatible with outputs from other sections;
data agestats;
	set agestats;
	value = put(age,8.);
	rename _stat_= stat;
	drop _type_ _freq_ age;
run;

***********************************************************;
* Section 2: Summary Statistics for Gender	 		      *;

proc format;
	value genfmt 1='Male' 2='Female';
run;

data demog2;
	set demog1;
	sex=put(gender,genfmt.);
run;

***********************************************************;
* Evaluating the statistical parameters for Gender 	      *;

proc freq data=demog2 noprint;
	table trt*sex / outpct out=genderstats;
run;

* Making "genderstats" table compatible with outputs from other sections;
data genderstats;
	set genderstats;
	value=cat(count,' (',strip(put(round(pct_row, .1), 8.1)),'%)');
	rename sex=stat;
	drop count percent pct_row pct_col;
run;

***********************************************************;
* Section 3: Summary Statistics for Race     		      *;

proc format;
	value racefmt 1='White' 2='Balck' 3='Hispanic' 4='Asian' 5='Other';
run;

data demog3;
	set demog2;
	race1=put(race,racefmt.);
run;

***********************************************************;
* Evaluating the statistical parameters for Gender 	      *;

proc freq data=demog3 noprint;
	table trt*race1 / outpct out=racestats;
run;

* Making "racestats" table compatible with outputs from other sections;
data racestats;
	set racestats;
	value=cat(count,' (',strip(put(round(pct_row,.1),8.1)),'%)');
	rename race1=stat;
	drop count percent pct_row pct_col;
run;


***********************************************************;
* Stacking all Summary Statistics Tables       			  *;



























