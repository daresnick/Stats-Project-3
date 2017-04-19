


/* This code helps to answer Question 6.   */

data kobeclutch;
set kobe_train;
if ttl_sec_remn_per > 30 then clutch = 0;
if ttl_sec_remn_per <= 30 then clutch = 1;
if ttl_sec_remn_per > 10 then realclutch = 0;
if ttl_sec_remn_per <= 10 then realclutch = 1;
if ttl_sec_remn_gam > 30 then clutchgame = 0;
if ttl_sec_remn_gam <= 30 then clutchgame = 1;
if ttl_sec_remn_gam > 10 then realclutchgame = 0;
if ttl_sec_remn_gam <= 10 then realclutchgame = 1;
run;


/* Compares probablities in last 30 seconds of periods.*/
proc logistic data=kobeclutch plots=all outest=estimates1;
class clutch(ref="1");
model shot_made_flag(event='1') = shot_distance|clutch/ clparm=both;
run; quit; 

/* Compares probablities in last 10 seconds of periods.*/
proc logistic data=kobeclutch plots=all outest=estimates1;
class realclutch(ref="1");
model shot_made_flag(event='1') = shot_distance|realclutch/ clparm=both;
run; quit; 

/* Compares probablities in last 30 seconds of games.*/
proc logistic data=kobeclutch plots=all outest=estimates1;
class clutchgame(ref="1");
model shot_made_flag(event='1') = shot_distance|clutchgame/ clparm=both;
run; quit; 

/* Compares probablities in last 10 seconds of games.*/
proc logistic data=kobeclutch plots=all outest=estimates1;
class realclutchgame(ref="1");
model shot_made_flag(event='1') = shot_distance|realclutchgame/ clparm=both;
run; quit; 


