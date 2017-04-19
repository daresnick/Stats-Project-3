

/* This code helps to answer Questions 4, and 5.   */

proc logistic data=kobe_train plots=all outest=estimates1;
class playoffs(ref="1");
model shot_made_flag(event='1') = shot_distance|playoffs/ clparm=both;
run; quit; 


proc logistic data=kobe_train plots=all outest=estimates1;
class playoffs(ref="1") homefield(ref="1");
model shot_made_flag(event='1') = shot_distance|playoffs|homefield/ clparm=both;
run; quit; 

proc logistic data=kobe_train plots=all outest=estimates1;
class playoffs(ref="1") homefield(ref="1");
model shot_made_flag(event='1') = dist|playoffs|homefield/ clparm=both;
run; quit; 


proc logistic data=kobe_train plots=all outest=estimates1;
class playoffs(ref="1") homefield(ref="1");
model shot_made_flag(event='1') = shot_distance|ttl_sec_remn_gam/ clparm=both;
run; quit; 
