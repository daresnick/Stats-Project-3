

/* Models below should be ordered by Kaggle score first then Log Loss Score. */

/* You can copy and paste models in and out of this file into Kaggle submission or Cross Validation files. */

/* Kaggle score of 0.63499 and Log Loss Score 0f 0.58712 with 3 missing rows replaced with those of clean model */
proc logistic data=kobe1 plots=all;
class ssn_numb  combined_shot_type_num  shot_distance;    
class action_type  ssn_numb  combined_shot_type_num  shot_zone_area_num  shot_zone_basic_num 
shot_zone_range_num  game_event_id  shot_distance  clutch ;    
model shot_made_flag(event='1') = action_type  ttl_sec_remn_gam  ssn_numb combined_shot_type_num 
shot_zone_area_num  shot_zone_basic_num  shot_zone_range_num  game_event_id  shot_distance  clutch ;
output out = SS_PRED predicted = I;    
run;

/*Kaggle Score of 0.63544 and Log Loss Score 0f 0.58776 with 3 missing rows replaced with 0.5*/
ods exclude all;
proc logistic data=kobe1 plots=all;
class action_type ssn_numb combined_shot_type_num shot_zone_area_num shot_zone_basic_num shot_zone_range_num 
shot_distance game_event_id homefield(ref="0");    
model shot_made_flag(event='1') = action_type ttl_sec_remn_gam ssn_numb combined_shot_type_num 
shot_zone_area_num shot_zone_basic_num shot_zone_range_num dist shot_distance game_event_id homefield;
output out = SS_PRED predicted = I;    
run; quit;
ods exclude none; 

/* Kaggle score of 0.63562 and Log Loss Score 0f 0.58778 with 3 missing rows replaced with 0.5*/
ods exclude all;
proc logistic data=Kobe1 plots=all;
class action_type ssn_numb combined_shot_type_num shot_zone_area_num shot_zone_basic_num 
shot_zone_range_num game_event_id  shot_distance;    
model shot_made_flag(event='1') = action_type ttl_sec_remn_gam ssn_numb combined_shot_type_num 
shot_zone_area_num shot_zone_basic_num shot_zone_range_num dist game_event_id  shot_distance;
output out = SS_PRED predicted = I;    
run; quit;
ods exclude none; 

/* Kaggle score of 0.63627 and Log Loss Score 0f 0.59118 with 3 missing rows replaced with 0.5 */
proc logistic data=kobe2 plots=all;
class action_type combined_shot_type_num ssn_numb shot_zone_area_num shot_zone_basic_num shot_zone_range_num game_event_id;    
model shot_made_flag(event='1') =  dist action_type combined_shot_type_num shot_type_num ttl_sec_remn_gam ssn_numb shot_zone_area_num 
	shot_zone_basic_num shot_zone_range_num game_event_id;
output out = predictions predicted = I;
run; quit;

/* Kaggle score of 0.63640 and Log Loss Score of 0.58991 with 3 missing rows replaced with 0.5 */
proc logistic data=kobe2 plots=all;
class action_type combined_shot_type_num ssn_numb shot_zone_area_num shot_zone_basic_num shot_zone_range_num opponent period game_event_id;    
model shot_made_flag(event='1') =  action_type dist combined_shot_type_num shot_type_num ttl_sec_remn_gam ssn_numb shot_zone_area_num opponent period game_event_id
	shot_zone_basic_num shot_zone_range_num;
output out = predictions predicted = I;
run; quit;

/* Log Loss score of 0.59614 */
proc logistic data=kobe2 plots=all;
class combined_shot_type_num action_type game_event_id;    
model shot_made_flag(event='1') =  combined_shot_type_num dist angle action_type game_event_id;
output out = predictions predicted = I;
run; quit;

/* Log Loss score of 0.64966 */
proc logistic data=kobe1 plots=all;
class homefield(ref="0") playoffs(ref="0") ssn_numb shot_type_num combined_shot_type_num shot_zone_area_num 
shot_zone_basic_num shot_zone_range_num/ param=ref;    
model shot_made_flag(event='1') = shot_distance  ttl_sec_remn_gam homefield ssn_numb shot_type_num combined_shot_type_num 
shot_zone_area_num shot_zone_basic_num shot_zone_range_num lat lon loc_x loc_y playoffs;  
output out = SS_PRED predictedprob = I;    
run; 

/* Log Loss score of 0.65159 */
proc logistic data=kobe1 plots=all;
class ssn_numb shot_type_num combined_shot_type_num;    
model shot_made_flag(event='1') = ttl_sec_remn_gam ssn_numb shot_type_num combined_shot_type_num loc_x loc_y;  
output out = SS_PRED predicted = I;    
run;

/* Kaggle score of 0.65016 and Log Loss Score 0f 0.65278 */
proc logistic data=kobe1 plots=all;
class combined_shot_type_num;    
model shot_made_flag(event='1') =  combined_shot_type_num dist angle;
output out = SS_PRED predicted = I;    
run;



