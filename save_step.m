function [] = save_step(s, behavior_choosen, name_subject, cf, pictures_left5, pictures_left7)
condition = {char(behavior_choosen)}; %store the condition the subject was working on in a cell array
timing = {date}; %store the date of the experiment
pictures_step5 = string(num2str(pictures_left5)); %store the array of the pictures left to show as one array
pictures_step7 = string(num2str(pictures_left7)); %store the array of the pictures left to show as one array
step = s;
if isequal(char(cf.condition(end)),char(behavior_choosen)) %if the last condition of the text file is the same as the condition currently done by the subject
    step = max(s, cf.step(end)); %take the best attempt between the last one and the current one
    cf(end,:) = []; %delete the last row of the text file
end
tosave = table(condition, step, pictures_step5, pictures_step7, timing); %create a table with the condition, the step, which pictures to show in the 7th step and the timing to save it in a text file
tosave = vertcat(cf,tosave); %concatenate the current condition at the end of the text file
writetable(tosave, strcat(char(name_subject), '.txt')); %if the subject was working on a new condition, add a new row at the end of the text file
       
