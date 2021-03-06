
/* This code makes the several scatter plots of the shots made and missed.  It also shows the different zone areas on the court.*/
/* This file is meant to be run after load_clean_data.sas file */

title 'All Shots Attempted';
proc sgplot data = kobe1;
	scatter x = loc_x y = loc_y / markerattrs = (size = 2 symbol = circlefilled);
run;

title 'Made Shots are Red, Missed Shots are Blue, Shots Taken Out by Kaggle are Grey';
proc sgplot data = kobe1;
	scatter x = loc_x y = loc_y / colorresponse=shot_made_flag markerattrs = (size = 3 symbol = circlefilled);
run;
 
title 'shot_zone_area';
proc sgplot data = kobe_train;
	scatter x = loc_x y = loc_y / colorresponse=shot_zone_area_num  markerattrs=(size = 3 symbol = circlefilled);
run;

title 'shot_zone_basic';
proc sgplot data = kobe_train;
	scatter x = loc_x y = loc_y / colorresponse=shot_zone_basic_num  markerattrs=(size = 3 symbol = circlefilled);
run;

title 'shot_zone_range';
proc sgplot data = kobe_train;
	scatter x = loc_x y = loc_y / colorresponse=shot_zone_range_num  markerattrs=(size = 3 symbol = circlefilled);
run;

title 'shot_zone_range';
proc sgplot data = kobe_train;
	scatter x = polar_x y = polar_y / colorresponse=shot_zone_range_num  markerattrs=(size = 3 symbol = circlefilled);
run;

title 'Shows that dist and shot_distance are nominaly the same.';
proc sgplot data = kobe_train;
	scatter x = dist y = shot_distance / colorresponse=shot_zone_range_num  markerattrs=(size = 3 symbol = circlefilled);
run;

title '2 Point and 3 Point Shots';
proc sgplot data = kobe_train;
	scatter x = loc_x y = loc_y / colorresponse=shot_type_num  markerattrs=(size = 3 symbol = circlefilled);
run;
