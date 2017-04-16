
/* This code will be used to test models with training and test set made from the kobe_train set. */
/* It calculates the Log Loss Score for the test2 set. */
/* Run this code after you have run the load_clean_data.sas file. */


/* This code use a macro to create an average Log Loss score with 20 seeds 11-30 */

%macro mcv(seednum);

data trainrandom;
set kobe_train;
RandNumber = ranuni(&seednum);
run;

data train2;
set trainrandom;
if RandNumber <= 0.19927 then delete;
run;

data test2;
set trainrandom;
if RandNumber > 0.19927 then delete;
shot_made_flag_Real = shot_made_flag;
run;

data test2;
set test2;
drop shot_made_flag;
run;

data kobe2;
set train2 test2;
run;

*proc print data=kobe2 (firstobs=25690); run;


/* Place your model below. The best way is normaly just to copy and paste the clas and model statements together and nothing else.  */

ods exclude all;
proc logistic data=kobe2 plots=all;
class combined_shot_type_num;    
model shot_made_flag(event='1') =  combined_shot_type_num dist angle;
output out = predictions predicted = I;    
run; quit;


/* the predictions for test2 data */
data finalprediction2;
set predictions;
if RandNumber <= 1/2;
logloss = (-1)*(shot_made_flag*log(I) + (1 - shot_made_flag)*log(1 - I));
keep RandNumber shot_id I logloss;
run;

*proc print data=finalprediction2 (obs=5); run;

/*
data finalpredictionMissing2;
set finalprediction2;
if logloss =.;
run;

title 'Rows with missing predictions';
proc print data=finalpredictionMissing2 (obs=10); run;
*/

proc summary data = finalprediction2;
var logloss;
output out = loglosssummary mean=mean sum=sum n=n;
run;

*proc print data=loglosssummary; run;

data sqr&seednum;
set loglosssummary;
e = sum/(n);
e&seednum = (sum/(n));
keep e&seednum;
run;


ods exclude none; 

%mend mcv;


%mcv(11)
%mcv(12)
%mcv(13)
%mcv(14)
%mcv(15)
%mcv(16)
%mcv(17)
%mcv(18)
%mcv(19)
%mcv(20)
%mcv(21)
%mcv(22)
%mcv(23)
%mcv(24)
%mcv(25)
%mcv(26)
%mcv(27)
%mcv(28)
%mcv(29)
%mcv(30)


data eaverage;
set sqr11;
set sqr12;
set sqr13;
set sqr14;
set sqr15;
set sqr16;
set sqr17;
set sqr18;
set sqr19;
set sqr20;
set sqr21;
set sqr22;
set sqr23;
set sqr24;
set sqr25;
set sqr26;
set sqr27;
set sqr28;
set sqr29;
set sqr30;
eaverage = (e11 + e12 + e13 + e14 + e15 + e16 + e17 + e18 + e19 + e20 + e21 + e22 + e23 + e24 + e25 + e26 + e27 + e28 + e29 + e30)/20;
keep eaverage;
run;


title 'Average Log Loss score for 20 seeds';
proc print data=eaverage; run; quit;

/*
proc sort data=predictions;
by cookd;
run;


proc print data=predictions; run;
