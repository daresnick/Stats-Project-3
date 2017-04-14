data WORK.KOBEDATA    ;
infile '/home/rajnig0/data.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
 informat action_type $18. ;
 informat combined_shot_type $9. ;
informat game_event_id best32. ;
 informat game_id best32. ;
 informat lat best32. ;
informat loc_x best32. ;
informat loc_y best32. ;
 informat lon best32. ;
 informat minutes_remaining best32. ;
 informat period best32. ;
 informat playoffs best32. ;
informat season $7. ;
informat seconds_remaining best32. ;
 informat shot_distance best32. ;
 informat shot_made_flag best32. ;
 informat shot_type $14. ;
informat shot_zone_area $21. ;
 informat shot_zone_basic $21. ;
  informat shot_zone_range $15. ;
 informat team_id best32. ;
informat team_name $18. ;
 informat game_date yymmdd10. ;
informat matchup $11. ;
 informat opponent $3. ;
informat shot_id best32. ;
 format action_type $18. ;
format combined_shot_type $9. ;
 format game_event_id best12. ;
 format game_id best12. ;
format lat best12. ;
format loc_x best12. ;
format loc_y best12. ;
format lon best12. ;
format minutes_remaining best12. ;
format period best12. ;
format playoffs best12. ;
 format season $7. ;
 format seconds_remaining best12. ;
format shot_distance best12. ;
 format shot_made_flag best12. ;
 format shot_type $14. ;
format shot_zone_area $21. ;
format shot_zone_basic $21. ;
 format shot_zone_range $15. ;
 format team_id best12. ;
format team_name $18. ;
format game_date yymmdd10. ;
format matchup $11. ;
format opponent $3. ;
format shot_id best12. ;
input
  action_type $
 combined_shot_type $
 game_event_id
game_id
 lat
loc_x
 loc_y
 lon
 minutes_remaining
 period
playoffs
 season $
seconds_remaining
shot_distance
 shot_made_flag
 shot_type $
shot_zone_area $
shot_zone_basic $
shot_zone_range $
team_id
team_name $
game_date
matchup $
 opponent $
shot_id
 ;
 run;



data Kobe;
 set KobeData;
 if shot_made_flag=. then delete;
  match = substr(Matchup,5,2);
 /*shot=(combined_shot_type='Dunk');*/
run;

data Kobe1;                                                                                                                              
set Kobe;                                                                                          
if (match= 'vs') then HomeField = 1;                                                                                               
if (match= '@') then HomeField = 0;                                                                                                      
run;  

proc sort data = Kobe;                                                                                                                  
by shot_made_flag;                                                                                                                               
run;
 
/*EDA*/

   title 'Box Plot for latitude';
   proc boxplot data=Kobe1;
      plot lat*shot_made_flag/boxstyle=scematic horizontal;  
      run;


   title 'Box Plot for longitude';
   proc boxplot data=Kobe1;
      plot lon*shot_made_flag/boxstyle=scematic horizontal;
   run;
   
      title 'Box Plot for loc_x';
   proc boxplot data=Kobe1;
      plot loc_x*shot_made_flag/boxstyle=scematic horizontal;
   run;
   
      title 'Box Plot for loc_y';
   proc boxplot data=Kobe1;
      plot loc_y*shot_made_flag/boxstyle=scematic horizontal;
   run;
   
      title 'Box Plot for minutes remaining';
   proc boxplot data=Kobe1;
      plot minutes_remaining*shot_made_flag/boxstyle=scematic horizontal;
   run;
   
       title 'Box Plot for seconds remaining';
   proc boxplot data=Kobe1;
      plot seconds_remaining*shot_made_flag/boxstyle=scematic horizontal;
   run;  
   
      title 'Box Plot for shot distance';
   proc boxplot data=Kobe1;
      plot shot_distance*shot_made_flag/boxstyle=scematic horizontal;
   run;
   
   
 proc sgplot data = Kobe1;                                                                                                                
scatter y = shot_made_flag x = action_type;                                                                                                   
run;  

proc freq data = Kobe1;                                                                                                                  
tables shot_made_flag action_type shot_made_flag*action_type / out = t outpct; ;                                                                    
run;  

proc sgplot data = t;                                                                                                                   
by shot_made_flag;                                                                                                                           
scatter y = pct_col x = action_type;                                                                                                    
yaxis  min = 0 max = 100;                                                                                                               
run; 

/* making the logits */   
data logit;                                                                                                                             
set t;                                                                                                                                  
logit = log(pct_col/100 / (1 - pct_col/100));                                                                                           
;  

proc sgplot data = logit;                                                                                                               
by shot_made_flag;                                                                                                                           
scatter y = logit x = action_type;                                                                                                      
yaxis  min = -5 max = 5;                                                                                                                
run;

/* Showing linearity of logits */ 
proc logistic data=Kobe1 plots=all;
class shot_made_flag(ref="0") homefield(ref="0") action_type/ param=ref;                                                                                              
model shot_made_flag= shot_distance  action_type minutes_remaining seconds_remaining period homefield;                                                                                                           
run; 

proc logistic data=Kobe1 plots=all;
class shot_made_flag(ref="0") homefield(ref="0") / param=ref;                                                                                              
model shot_made_flag= homefield ;                                                                                                           
run; 

proc logistic data=Kobe1 plots=all;
class shot_made_flag(ref="0")/ param=ref;                                                                                              
model shot_made_flag= shot_distance ;                                                                                                           
run; 

proc logistic data=Kobe1 plots=all;
class shot_made_flag(ref="0") playoffs(ref="0")/ param=ref;                                                                                              
model shot_made_flag= shot_distance  playoffs;                                                                                                           
run; 

proc logistic data=Kobe1 plots=all;
class shot_made_flag(ref="0") playoffs(ref="0") homefield(ref="0")/ param=ref;                                                                                              
model shot_made_flag= shot_distance playoffs homefield;                                                                                                           
run; 

proc glm data = logit;                                                                                                                  
by shot_made_flag;                                                                                                                           
model logit = action_type action_type*action_type;                                                                                      
run; 

proc logistic data=Kobe1 plots=all;
class shot_made_flag(ref="0") action_type/ param=ref;                                                                                              
model shot_made_flag= shot_distance | action_type/lackfit ctable;                                                                                                           
run;  



