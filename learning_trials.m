function [C,timingfile,userdefined_trialholder] = learning_trials(MLConfig,TrialRecord)
C = [];
timingfile = {'step0_1.m','step0_2.m', 'step0_3.m', 'step0_4.m'}; %the scripts for the different steps
userdefined_trialholder = '';

persistent timing_filenames_retrieved
if isempty(timing_filenames_retrieved) %Only if it is the first time the function is called
    TrialRecord.User.step = 1; %initialisation of the step the subject is at in the current condition
    TrialRecord.User.list_behaviors = {'ind_alone','ind_no_interaction','kinship_holding','kinship_grooming', 'kinship_observing','friendship_grooming', 'friendship_sitting_close', 'friendship_foraging','hierarchy_mounting','hierarchy_fighting','hierarchy_chasing'}; %all the behaviors shown
    TrialRecord.User.relationships = {'kinship', 'friendship', 'hierarchy'}; %the 3 kinds of relationships shown
    TrialRecord.User.behavior_choosen = TrialRecord.User.list_behaviors(randi([2,11])); %select a behavior at random in the behaviors possible without the 2 first ones
    TrialRecord.User.other_unrelated_behaviors = {}; %initialisation of the list of other behaviors to present during the learning phase
    for i = 1:3
        if contains(char(TrialRecord.User.behavior_choosen), TrialRecord.User.relationships(i)) %look which kind of relationship the behavior choosen is part of
            TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i); %store the relationship choosen
            break %stops once the relationship has been found 
        end
    end
    
    for i = 1:11 %for all behaviors except the one choosen
        if ~contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen) %if the behavior is part of the relationship choosen
            TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i)); %add the others to the list of unrelated behaviors
        end
    end 
    timing_filenames_retrieved = true;
    return
end

switch TrialRecord.User.step %switch to the different steps according to the number of successful trials 
    case 1
        timingfile = 'step0_1.m';
        
    case 2
        timingfile = 'step0_2.m';
        
    case 3
        timingfile = 'step0_3.m';
    
    case 4
        timingfile = 'step0_4.m';
        
    case 5
        TrialRecord.Quit = true; %quit the session
end

end
