

/* Models below should be ordered by Kaggle score first then Log Loss Score. */

/* You can copy and paste models in and out of this file into Kaggle submission or Cross Validation files. */


/* Log Loss score of 0.59118 */
proc logistic data=kobe2 plots=all;
class action_type combined_shot_type_num ssn_numb shot_zone_area_num shot_zone_basic_num shot_zone_range_num game_event_id;    
model shot_made_flag(event='1') =  dist action_type combined_shot_type_num shot_type_num ttl_sec_remn_gam ssn_numb shot_zone_area_num 
	shot_zone_basic_num shot_zone_range_num game_event_id;
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



