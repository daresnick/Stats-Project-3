
/* This code attempts to answer question 1  */


/*   */
proc logistic data=kobe_train plots=all outtest=estimates1;
class homefield(ref="0");
model shot_made_flag(event='1') = homefield;
run; quit; 

data probmade1;
set estimates1;
prob1=(EXP(Intercept+HomeField1))/(1+(EXP(Intercept+HomeField1)));
keep prob1;
run;

proc print data=probmade1; run;

proc logistic data=kobe_train plots=all outtest=estimates0;
class homefield(ref="1");
model shot_made_flag(event='1') = homefield;
run; quit; 

*proc print data=estimates; run;

data probmade0;
set estimates0;
prob0=(EXP(Intercept+HomeField0))/(1+(EXP(Intercept+HomeField0)));
keep prob0;
run;

title 'Probability of Making a Shot at Home';
proc print data=probmade1; run;

title 'Probability of Making a Shot Away';
proc print data=probmade0; run;


/* This code tries to verify the interpretation of proc logistic code by simply calculating percentage of making a shot. This should be half way in between the above probabilities. */
data shotsmade;
set kobe_train;
if shot_made_flag = "0" then delete;
keep shot_id homefield;
run;

data shotsmissed;
set kobe_train;
if shot_made_flag = "1" then delete;
keep shot_id homefield;
run;

proc summary data = shotsmade;
var shot_id;
output out = totmade n=n1;
run;

proc summary data = shotsmissed;
var shot_id;
output out = totmiss n=n0;
run;

data shootper;
set totmade;
set totmiss;
per=(n1)/(n1+n0);
keep per;
run;

title 'Total shooting percentage for entire career. It is half way between the two probabilities!';
proc print data=shootper; run;


/* This code calculates the shooting percentage at home. */
data shotsmadehome;
set shotsmade;
if homefield = "0" then delete;
run;

data shotsmissedhome;
set shotsmissed;
if homefield = "0" then delete;
run;

proc summary data = shotsmadehome;
var shot_id;
output out = totmadeh n=n1h;
run;

proc summary data = shotsmissedhome;
var shot_id;
output out = totmissh n=n0h;
run;

data shootperhome;
set totmadeh;
set totmissh;
perhome=(n1h)/(n1h+n0h);
keep perhome;
run;

title 'Total shooting percentage at home for entire career.';
proc print data=shootperhome; run;


/* This code calculates the shooting percentage away. */
data shotsmadeaway;
set shotsmade;
if homefield = "1" then delete;
run;

data shotsmissedaway;
set shotsmissed;
if homefield = "1" then delete;
run;

proc summary data = shotsmadeaway;
var shot_id;
output out = totmadea n=n1a;
run;

proc summary data = shotsmissedaway;
var shot_id;
output out = totmissa n=n0a;
run;

data shootperaway;
set totmadea;
set totmissa;
perhome=(n1a)/(n1a+n0a);
keep perhome;
run;

title 'Total shooting percentage away for entire career.';
proc print data=shootperaway; run;
