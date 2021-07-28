function [C,timingfile,userdefined_trialholder] = task(MLConfig,TrialRecord)
C = [];
timingfile = {'step1.m','step2.m','step3.m', 'step4.m', 'step5.m', 'step6.m', 'step7.m'}; %the scripts for the different steps
userdefined_trialholder = '';

persistent timing_filenames_retrieved
if isempty(timing_filenames_retrieved) %Only if it is the first time the function is called
    TrialRecord.User.success_count = 0; %the total number of successful attempts
    TrialRecord.User.min_success = 2; %min of successfull trials to reach the next step
    TrialRecord.User.list_behaviors = {'ind_alone','ind_no_interaction','kinship_holding','kinship_grooming', 'kinship_observing','friendship_grooming', 'friendship_sitting_close', 'friendship_foraging','hierarchy_mounting','hierarchy_fighting','hierarchy_chasing'}; %all the behaviors shown
    TrialRecord.User.relationships = {'kinship', 'friendship', 'hierarchy'}; %the 3 kinds of relationships shown
    TrialRecord.User.behavior_choosen = {}; %initialisation of which behavior will be shown in this condition
    TrialRecord.User.relationship_choosen = {}; %initialisation of which relationship the behavior choosen is part of
    TrialRecord.User.behaviors_available = {}; %initialisation of the behaviors not already done by the subject
    alreadydone = {}; %initialisation of the behaviors already done by the subject
    TrialRecord.User.step = 1; %initialisation of the step the subject is at in the current condition
    TrialRecord.User.pictures_left5 = []; %initialisation of the pictures to show in step 5
    TrialRecord.User.pictures_left7 = []; %initialisation of the pictures to show in the last step
    
    name_subject = MLConfig.SubjectName; %name of the subject
    TrialRecord.User.name = name_subject; %store the name of the subject to be able to retrieve it in other scripts
    text = readtable(strcat(char(name_subject), '.txt')); %read what's in the text file of the subject
    TrialRecord.User.conditionfile = text; %store the text to be able to retrieve it in other scripts
    
    if ~exist('text', 'var') %If there's no .txt for this subject, throws an error
        error('Error. \nNo .text found for this subject. \nPlease create one with the first condition the subject should be doing')
    end
        
    l = find(text.step, 1, 'first'); %find the first row where the step is not 0 
    if ~isempty(l)
        TrialRecord.User.behavior_choosen = char(text.condition(l)); %if there is a row where step is not equal 0, it means the condition has not been done completely, and therefore must be continued
        TrialRecord.User.step = max(text.step(l)-1, 1); %If the participant was at the n step, take at the step n-1, or at the 2nd step if he didn't go through the first step
        TrialRecord.User.success_count = (TrialRecord.User.step-1)*TrialRecord.User.min_success; %update the number of successful attempts (if 
        if isnan(text.pictures_step5(l))
            TrialRecord.User.pictures_left5 = NaN;
        
        elseif ~isequal(text.pictures_step5(l),{'[]'})
            temp = text.pictures_step5(l);
            if isa(temp, 'cell')
                TrialRecord.User.pictures_left5 = str2num(temp{1});
            else
                TrialRecord.User.pictures_left5 = temp;
            end
        else
            cd Test1 %go to the Test1 folder to get the image of the behavior
            cd(char(TrialRecord.User.behavior_choosen)); %go the folder of the behavior choosen
            list_images = dir('*.bmp*');
            size_im = size(list_images,1);
            TrialRecord.User.pictures_left5 = linspace(1, size_im, size_im);
            cd ../..
        end
        
        if ~isequal(text.pictures_step7(l),{'[]'})  %if it's not empty, it means
            temp = text.pictures_step7(l);
            if isa(temp, 'cell')
                TrialRecord.User.pictures_left7 = str2num(temp{1});
            else
                TrialRecord.User.pictures_left7 = temp;
            end

        else
            cd Test2 %go to the Test2 folder to get the image of the behavior
            cd(char(TrialRecord.User.behavior_choosen)); %go the folder of the behavior choosen
            list_images = dir('*.bmp*');
            size_im = size(list_images,1);
            TrialRecord.User.pictures_left7 = linspace(1, size_im, size_im);
            cd ../..
        end
        
        
    else %If no condition were left unfinished
        s = size(text,1) - mod(size(text,1), 9) + 1; %takes out the blocks of 9 conditions 
        for line = s:size(text,1) %we only consider the last block of conditions that was not finished
            alreadydone{end + 1} = char(text.condition(line)); %store the conditions already done
        end
        TrialRecord.User.behaviors_available = setdiff(TrialRecord.User.list_behaviors,alreadydone, 'stable'); %store the conditions not already done
        n = randi([3,size(TrialRecord.User.behaviors_available,2)]); %choose randomly a behavior among those not already done
        TrialRecord.User.behavior_choosen = TrialRecord.User.behaviors_available(n);
        
        cd Test1
        cd(char(TrialRecord.User.behavior_choosen))
        list_images = dir('*.bmp*');
        size_im = size(list_images,1);
        TrialRecord.User.pictures_left5 = linspace(1, size_im, size_im);
        cd ../..
        
        cd Test2 %go to the Test2 folder to get the image of the behavior
        cd(char(TrialRecord.User.behavior_choosen)); %go the folder of the behavior choosen
        list_images = dir('*.bmp*');
        size_im = size(list_images,1);
        TrialRecord.User.pictures_left7 = linspace(1, size_im, size_im);
        cd ../..
    end
    
    
    TrialRecord.User.list_behaviors = setdiff(TrialRecord.User.list_behaviors, TrialRecord.User.behavior_choosen, 'stable'); %list of all the behaviors except the one choosen
    TrialRecord.User.other_unrelated_behaviors = {}; %initialisation of the behaviors belonging to the other relationships than the one choosen
    
    for i = 1:3
        if contains(char(TrialRecord.User.behavior_choosen), TrialRecord.User.relationships(i)) %look which kind of relationship the behavior choosen is part of
            TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i); %store the relationship choosen
            break %stops once the relationship has been found 
        end
    end
    
    for i = 1:10 %for all behaviors except the one choosen
        if ~contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen) %if the behavior is part of the relationship choosen
            TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i)); %add the others to the list of unrelated behaviors
        end
    end
    
    
    
    
    timing_filenames_retrieved = true;
    return
end

switch TrialRecord.User.step %switch to the different steps according to the number of successful trials 
    case 1
        timingfile = 'step1.m';
        if isempty(TrialRecord.TrialErrors) %if it is the first attempt
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        elseif 0==TrialRecord.TrialErrors(end) %if the last attempt is successful
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1; %add one to the count of successful attempts
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success %if the number of successful events is superior to the min number of successful events needed
            TrialRecord.User.step = 2; %go to the next step
        end
        
    case 2
        timingfile = 'step2.m';
        if isempty(TrialRecord.TrialErrors)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        elseif 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*2
            TrialRecord.User.step = 3;
        end
        
    case 3
        timingfile = 'step3.m';
        if isempty(TrialRecord.TrialErrors)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        elseif 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*3
            TrialRecord.User.step = 4; 
        end
        
    case 4
        timingfile = 'step4.m';
        if isempty(TrialRecord.TrialErrors)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        elseif 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*4
            TrialRecord.User.step = 5; 
        end
    
    case 5 
        if isempty(TrialRecord.User.pictures_left5) %if all test pictures have been presented
            TrialRecord.User.step = 6; %go to next step
        else
            proba = rand; %test step: on 20 pourcents of the trials, it is a test, the other 80 pourcents are learning trials
            if proba > 0.5 %pick a random number and see if it is above 0.8 or not (simulation of probabilities) 
                timingfile = 'step5.m'; %if it is above 0.8, test trial
            else
                timingfile = 'step4.m';
            end
        end
        
    case 6
        timingfile = 'step6.m';
        if isempty(TrialRecord.TrialErrors)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        elseif 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*5
             TrialRecord.User.step = 7;
        end
        
    case 7
        if isempty(TrialRecord.User.pictures_left7) %if all test pictures have been presented
            text = TrialRecord.User.conditionfile;
            condition = {char(TrialRecord.User.behavior_choosen)}; %store the condition
            step = [0]; %set the step to 0 (meaning this condition is finished)
            timing = {date}; %store the date of the day the subject finished this condition
            pictures_step5 = {'[]'}; %set the pictures left to an empty array
            pictures_step7 = {'[]'}; %set the pictures left to an empty array
            tosave = table(condition, step, pictures_step5, pictures_step7, timing); %create a table with the condition, the step and the timing
            if isequal(char(text.condition(end)),char(TrialRecord.User.behavior_choosen)) %if the last row of the text file is the same condition as the current condition
                text(end,:)=[]; %delete this last row
            end
            tosave=vertcat(text, tosave); %concatenate the table created for the current condition at the end of the text file
            writetable(tosave, strcat(char(TrialRecord.User.name),'.txt')); %re-write the text file with the condition finished at the end
            TrialRecord.Quit = true; %quit the session
        else
            proba = rand;
            if proba > 0.5
                timingfile = 'step7.m';
            else
                timingfile = 'step6.m';
            end
        end
        
end

end
