

/*Models to try*/

proc logistic data=kobe1 plots=all;
class homefield(ref="0") playoffs(ref="0") ssn_numb shot_type_num combined_shot_type_num shot_zone_area_num 
shot_zone_basic_num shot_zone_range_num/ param=ref;    
model shot_made_flag(event='1') = shot_distance  ttl_sec_remn_gam homefield ssn_numb shot_type_num combined_shot_type_num 
shot_zone_area_num shot_zone_basic_num shot_zone_range_num lat lon loc_x loc_y playoffs/selection=stepwise;  
output out = SS_PRED predictedprob = I;    
run; 


proc logistic data=kobe1 plots=all;
class ssn_numb shot_type_num combined_shot_type_num;    
model shot_made_flag(event='1') = ttl_sec_remn_gam ssn_numb shot_type_num combined_shot_type_num loc_x loc_y;  
output out = SS_PRED predicted = I;    
run;


proc logistic data=kobe1 plots=all;
class combined_shot_type_num;    
model shot_made_flag(event='1') =  combined_shot_type_num dist angle;
output out = SS_PRED predicted = I;    
run;



