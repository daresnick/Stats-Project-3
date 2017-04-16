

/* This code will be used to test models with training and test set made from the kobe_train set. */
/* It calculates the Log Loss Score for the test2 set. */
/* Run this code after you have run the load_clean_data.sas file. */

data trainrandom;
set kobe_train;
RandNumber = ranuni(11);
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
ods exclude none; 


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

data sqr;
set loglosssummary;
logloss_score = sum/(n);
keep logloss_score;
run;

title 'Log Loss Score';
proc print data=sqr; run;
