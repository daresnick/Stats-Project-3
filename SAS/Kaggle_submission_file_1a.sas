
/* This file is meant to be run after the load_clean_data.sas file is run. */

/* This file creates a submission.csv file with the proper format to submit to Kaggle for a score. Make sure the outfile has the proper path. */

/* Place the proc logistic model to be used below. After submission please update this file with the Kaggle score.*/

/* Kaggle score of 0.63499 Log Loss Score 0f 0.58712  with 3 missing rows replaced with those of a clean model */
ods exclude all;
proc logistic data=kobe1 plots=all;
class ssn_numb  combined_shot_type_num  shot_distance;    
class action_type  ssn_numb  combined_shot_type_num  shot_zone_area_num  shot_zone_basic_num 
shot_zone_range_num  game_event_id  shot_distance  clutch ;    
model shot_made_flag(event='1') = action_type  ttl_sec_remn_gam  ssn_numb combined_shot_type_num 
shot_zone_area_num  shot_zone_basic_num  shot_zone_range_num  game_event_id  shot_distance  clutch ;
output out = SS_PRED predicted = I;    
run;
ods exclude none; 

/* Kaggle score of 0.65016 */
ods exclude all;
proc logistic data=kobe1 plots=all;
class combined_shot_type_num;    
model shot_made_flag(event='1') =  combined_shot_type_num dist angle;
output out = SS_PRED predicted = I;    
run;
ods exclude none; 

data PredOut;
set SS_PRED;
where shot_made_flag=.;
keep shot_id shot_made_flag I;
run;

data Pred;
set PredOut;
shot_made_flag=I;
run;

/* the predictions for test data */
data pred_id;
set Pred;
keep shot_id;
run;

data pred_flag;
set Pred;
keep shot_made_flag;
run;

data finalprediction;
set pred_id;
set pred_flag;
run;

/* Be sure to change the outfile to your own file location */
/* The outfile "submission.csv" will be used in submission to kaggle */
proc export data=finalprediction outfile='C:\Users\hp\Desktop\SMU\Exp Stats II\Homework and projects\Project 3\Submissions\submission6f.csv' replace dbms=csv; run;

/* If this comes out with nothing then you should be able to submit cleanly. */
title 'Observations with Missing Values';
data finalpredictionMissing;
set finalprediction;
if shot_made_flag = .;
run;
proc print data=finalpredictionMissing;
run;
