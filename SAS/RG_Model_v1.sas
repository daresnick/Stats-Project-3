proc logistic data=kobe1 plots=all;
class shot_made_flag(ref="0") homefield(ref="0") playoffs(ref="0") ssn_numb shot_type_num combined_shot_type_num shot_zone_area_num 
shot_zone_basic_num shot_zone_range_num/ param=ref;    
model shot_made_flag= shot_distance  ttl_sec_remn_gam homefield ssn_numb shot_type_num combined_shot_type_num 
shot_zone_area_num shot_zone_basic_num shot_zone_range_num lat lon loc_x loc_y playoffs/selection=stepwise;  
output out = SS_PRED predictedprob = I;    
run; 


data PredOut;
set SS_PRED;
where shot_made_flag=.;
keep Shot_id I;
rename shot_made_flag=shot_made_flag
I=shot_made_flag;
run;

