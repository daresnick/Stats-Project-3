

/* This file creates 4 data sets, kobedata: raw data, kobe1: cleaned and transformed data, kobe_train: no shot_made_flag NAs in kobe1, kobe_test: only shot_made_flag NAs. */
/* This file is meant to be run first then other analysis files can be run after it, such as EDA.sas, CV.sas, prediction.sas, or Kaggle_Submission.sas. */
/* Make sure to change the directory for to data.csv file. */

data WORK.KOBEDATA    ;
infile 'C:\Users\hp\Desktop\SMU\Exp Stats II\Homework and projects\Project 3\data.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
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

*proc print data=kobedata (obs=20); run;

data Kobe1;                                                                                                                              
set KobeData;

latneg=(-1)*lat;

match = substr(Matchup,5,2); 
if (match = 'vs') then HomeField = 1;                                                                                               
if (match = '@') then HomeField = 0;

if season = '1996-97' then ssn_numb = 1;
if season = '1997-98' then ssn_numb = 2;
if season = '1998-99' then ssn_numb = 3;
if season = '1999-00' then ssn_numb = 4;
if season = '2000-01' then ssn_numb = 5;
if season = '2001-02' then ssn_numb = 6;
if season = '2002-03' then ssn_numb = 7;
if season = '2003-04' then ssn_numb = 8;
if season = '2004-05' then ssn_numb = 9;
if season = '2006-07' then ssn_numb = 10;
if season = '2007-08' then ssn_numb = 11;
if season = '2009-10' then ssn_numb = 12;
if season = '2010-11' then ssn_numb = 13;
if season = '2011-12' then ssn_numb = 14;
if season = '2012-13' then ssn_numb = 15;
if season = '2013-14' then ssn_numb = 16;
if season = '2014-15' then ssn_numb = 17;
if season = '2015-16' then ssn_numb = 18;

if period = 1 then ttl_sec_remn_gam = (36*60 + minutes_remaining*60+seconds_remaining);
if period = 2 then ttl_sec_remn_gam = (24*60 + minutes_remaining*60+seconds_remaining);
if period = 3 then ttl_sec_remn_gam = (12*60 + minutes_remaining*60+seconds_remaining);
if period = 4 then ttl_sec_remn_gam = (minutes_remaining*60 + seconds_remaining);
if period = 5 then ttl_sec_remn_gam = (minutes_remaining*60 + seconds_remaining);
if period = 6 then ttl_sec_remn_gam = (minutes_remaining*60 + seconds_remaining);
if period = 7 then ttl_sec_remn_gam = (minutes_remaining*60 + seconds_remaining);

if shot_type = '2PT Field Goal' then shot_type_num = 2;
if shot_type = '3PT Field Goal' then shot_type_num = 3;

if combined_shot_type = 'Bank Shot' then combined_shot_type_num = 1;
if combined_shot_type = 'Dunk' then combined_shot_type_num = 2;
if combined_shot_type = 'Hook Shot' then combined_shot_type_num = 3;
if combined_shot_type = 'Jump Shot' then combined_shot_type_num = 4;
if combined_shot_type = 'Layup' then combined_shot_type_num = 5;
if combined_shot_type = 'Tip Shot' then combined_shot_type_num = 6;

if shot_zone_area = 'Back Court(BC)' then shot_zone_area_num = 1;
if shot_zone_area = 'Center(C)' then shot_zone_area_num = 2;
if shot_zone_area = 'Left Side Center(LC)' then shot_zone_area_num = 3;
if shot_zone_area = 'Left Side(L)' then shot_zone_area_num = 4;
if shot_zone_area = 'Right Side Center(RC)' then shot_zone_area_num = 5;
if shot_zone_area = 'Right Side(R)' then shot_zone_area_num = 6;

if shot_zone_basic = 'Above the Break 3' then shot_zone_basic_num = 1;
if shot_zone_basic = 'Backcourt' then shot_zone_basic_num = 2;
if shot_zone_basic = 'In The Paint (Non-RA)' then shot_zone_basic_num = 3;
if shot_zone_basic = 'Left Corner 3' then shot_zone_basic_num = 4;
if shot_zone_basic = 'Mid-Range' then shot_zone_basic_num = 5;
if shot_zone_basic = 'Restricted Area' then shot_zone_basic_num = 6;
if shot_zone_basic = 'Right Corner 3' then shot_zone_basic_num = 7;

if shot_zone_range = '16-24 ft.' then shot_zone_range_num = 1;
if shot_zone_range = '24+ ft.' then shot_zone_range_num = 2;
if shot_zone_range = '8-16 ft.' then shot_zone_range_num = 3;
if shot_zone_range = 'Back Court Shot' then shot_zone_range_num = 4;
if shot_zone_range = 'Less Than 8 ft.' then shot_zone_range_num = 5;
run;

*proc print data=kobe1 (obs=20); run;

data Kobe_train;
 set Kobe1;
 if shot_made_flag=. then delete;
run;

data Kobe_test;
 set Kobe1;
 if shot_made_flag^=. then delete;
run;


