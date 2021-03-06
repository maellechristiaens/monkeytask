hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false); save_step(TrialRecord.User.step, TrialRecord.User.behavior_choosen, TrialRecord.User.name, TrialRecord.User.conditionfile, TrialRecord.User.pictures_left5, TrialRecord.User.pictures_left7);');
%This hotkey allows the experimentator to escape the experiment when they
%want and to save the step, condition and timing the subject was in
hotkey('r', 'goodmonkey(100, ''juiceline'',1, ''numreward'',1, ''pausetime'',500);');
%This hotkey allows the experimentator to give a reward when they want
hotkey('1', 'TrialRecord.User.step=1');
hotkey('2', 'TrialRecord.User.step=2');
hotkey('3', 'TrialRecord.User.step=3');
hotkey('4', 'TrialRecord.User.step=4');
hotkey('5', 'TrialRecord.User.step=5');
hotkey('6', 'TrialRecord.User.step=6');
hotkey('7', 'TrialRecord.User.step=7');
%These hotkeys allow the experimentator to change the step as they want

bhv_code(10,'Step1',100,'Reward'); 
%Keep record of the events happening in the metadata

triangle = PolygonGraphic(touch_);
triangle.EdgeColor = [1 1 0];
triangle.FaceColor = [1 1 0];
triangle.Size = [6 6];
triangle.Position = [0 0];
triangle.Vertex = [0.5 1; 1 0.25; 0 0.25];
%create the fixation triangle presented at the beginning of each trial

snd = AudioSound(null_);
snd.List = 'sound.wav';  
scene_sound = create_scene(snd);
%create the sound played when the subject successes at the trial

max_reaction_time = 7000;

% scene: fixation
fix1 = SingleTarget(triangle);  
fix1.Target = triangle.Position;  
fix1.Threshold = triangle.Size*1.3; 
wth1 = WaitThenHold(fix1);     
wth1.WaitTime = max_reaction_time;
wth1.HoldTime = 0; %no need to hold the click for a certain time 
scene = create_scene(wth1);  

% TASK:
error_type = 0; %initialisation of the error type recorded in the metadata

run_scene(scene,10);        
rt = wth1.AcquiredTime;      
if wth1.Waiting %if the time waited is superior to the max reaction time          
    error_type = 1; %return error type 1 (waited time exceded in fixation)
end

% reward
if 0==error_type %if the trial is a success
    run_scene(scene_sound,100); %play the sound twice
    run_scene(scene_sound,100);
    idle(0);                 
    goodmonkey(100, 'juiceline',1, 'numreward',10, 'pausetime',0); 
    %and give the reward twice
else
    idle(700); %otherwise, wait 0.7s before the next trial  
end

trialerror(error_type); %record the error type in the metadata 
