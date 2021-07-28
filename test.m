function [C,timingfile,userdefined_trialholder] = test_userloop(MLConfig,TrialRecord)
C = [];
timingfile = {'step1.m','step2.m','step3.m', 'step4.m', 'step5.m', 'step6.m', 'step7.m'};
userdefined_trialholder = '';



persistent timing_filenames_retrieved
if isempty(timing_filenames_retrieved)
    TrialRecord.User.success_count = 0;
    TrialRecord.User.min_success = 4;
    TrialRecord.User.list_behaviors = {'ind_alone','ind_no_interaction','kinship_holding','kinship_grooming', 'kinship_observing','friendship_grooming', 'friendship_sitting_close', 'friendship_foraging','hierarchy_mounting','hierarchy_fighting','hierarchy_chasing'};
    TrialRecord.User.relationships = {'kinship', 'friendship', 'hierarchy'};
    
    TrialRecord.User.nextstep = 1;
    TrialRecord.User.n = randi([3,11]);
    TrialRecord.User.behavior_choosen = TrialRecord.User.list_behaviors(TrialRecord.User.n)
    TrialRecord.User.list_behaviors(TrialRecord.User.n) = [];
    TrialRecord.User.other_unrelated_behaviors = {};
    TrialRecord.User.other_related_behaviors = {char(TrialRecord.User.behavior_choosen)};
    for i = 1:3
        if contains(TrialRecord.User.behavior_choosen, TrialRecord.User.relationships(i))
            TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i)
        end
    end
    for i = 1:10
        if contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen)
            TrialRecord.User.other_related_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i))
        else
            TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i))
        end
    end
    timing_filenames_retrieved = true;
    return
end

switch TrialRecord.User.nextstep
    case 1
        timingfile = 'step1.m';
        if isempty(TrialRecord.TrialErrors)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        elseif 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success-2 
            TrialRecord.User.nextstep = 2;
        end
        
    case 2
        timingfile = 'step2.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*2
            TrialRecord.User.nextstep = 3;
        end
        
    case 3
        timingfile = 'step3.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*3
            TrialRecord.User.nextstep = 4; 
        end
        
    case 4
        timingfile = 'step4.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*4
            TrialRecord.User.nextstep = 5; 
        end
    
    case 5 
        proba = rand
        if proba > 0.8
            timingfile = 'step5.m';
            if 0==TrialRecord.TrialErrors(end)
                TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
            end
        else
            timingfile = 'step4.m';
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*5
            TrialRecord.User.nextstep = 6;
        end
        
    case 6
        timingfile = 'step6.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*6
             TrialRecord.User.nextstep = 7;
        end
        
    case 7
        proba = rand
        if proba > 0.8
            timingfile = 'step7.m';
            if 0==TrialRecord.TrialErrors(end)
                TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
            end
        else
            timingfile = 'step6.m';
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*7
            TrialRecord.Quit = true;
        end
end

end
