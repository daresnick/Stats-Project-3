

/* Question 2:
	The odds of Kobe making a shot decrease with respect to the distance he is from the hoop.  
	If there is evidence of this, quantify this relationship.  (CIs, plots, etc.)*/


proc logistic data=kobe_train plots=all outest=estimates1;
model shot_made_flag(event='1') = dist/ clparm=both;
run; quit; 

proc logistic data=kobe_train plots=all outest=estimates1;
model shot_made_flag(event='1') = shot_distance/ clparm=both;
run; quit; 


data q2;
set kobe_train;
if shot_distance > 40 then shot_distance = 50;
run;

proc logistic data=q2 plots=all outest=estimates1;
class shot_distance(ref="0");
model shot_made_flag(event='1') = shot_distance;
run; quit; 

proc logistic data=kobe_train plots=all outest=estimates1;
class shot_distance(ref="0");
model shot_made_flag(event='1') = shot_distance;
run; quit; 


data q2b;
set kobe_train;
if shot_distance <= 40 then shot_distance = 0;
if shot_distance > 40 then shot_distance = 1;
run;

proc logistic data=q2b plots=all outest=estimates1;
class shot_distance(ref="0");
model shot_made_flag(event='1') = shot_distance;
run; quit; 


proc logistic data=kobe_train plots(MAXPOINTS=NONE)=all outest=estimates1;
model shot_made_flag(event='1') = shot_distance/ clparm=both;
run; quit; 



proc logistic data=q2 plots=all outest=estimates1;
class shot_distance;
model shot_made_flag(event='1') = shot_distance/ clparm=both;
run; quit; 




proc logistic data=kobe_train plots=all outest=estimates1;
class shot_distance;
model shot_made_flag(event='1') = shot_distance;
run; quit; 
