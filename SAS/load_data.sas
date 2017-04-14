




proc import datafile='C:\Users\hp\Desktop\SMU\Exp Stats II\Homework and projects\Project 3\data.csv' dbms=csv out=train replace;
delimiter = ",";
getnames=yes;
guessingrows=3000;
run;

proc print data=train (obs=20); run;


proc contents data=train noprint out=names (keep = name); run;

proc print data=names; run;

/*
proc summary data=train;
var action_type combined_shot_type game_event_id game_id lat loc_x loc_y lon minutes_remaining period;
run;
*/

