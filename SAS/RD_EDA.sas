/*Proc Univariate*/
proc univariate data=Kobe_train;
var shot_distance dist ssn_numb ttl_sec_remn_gam;
histogram;
run;

/*Histograms on Diagonal*/
ods graphics on;
proc sgscatter data=Kobe_train ;
matrix angle dist ssn_numb ttl_sec_remn_gam homefield/ diagonal=(histogram);
run;
ods graphics off;


ods graphics on;
proc sgscatter data=Kobe_train ;
matrix game_event_id game_id/ diagonal=(histogram);
run;
ods graphics off;

/*Interaction Plots*/

proc plot data=Kobe_train;
plot dist * angle = shot_made_flag;
run;


proc plot data=Kobe_train;
plot dist * HomeField = shot_made_flag;
run;
