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

bhv_code(10,'Fix',20, 'Step2',100,'Reward'); 
%Keep record of the events happening in the metadata

behavior_choosen = TrialRecord.User.behavior_choosen;
%store the behavior choosen for this condition 

triangle = PolygonGraphic(touch_);
triangle.EdgeColor = [1 1 0];
triangle.FaceColor = [1 1 0];
triangle.Size = [6 6];
triangle.Position = [0 0];
triangle.Vertex = [0.5 1; 1 0.25; 0 0.25];
%create the fixation triangle presented at the beginning of each trial

between = CircleGraphic(null_);
between.EdgeColor = [0 0 0];
between.FaceColor = [0 0 0];
between.Size = [3 3];
between.Position = [0 0];
%create a waiting time between the fixation and the rest of the trial


cd Learning1 %go to the Learning folder to get the image of the behavior
cd(char(behavior_choosen));
list_images = dir('*.bmp*');
im = ImageGraphic(touch_);
im.List = {char(list_images(1).name), [0 0], 1.1}; 
%take the last image of the subfolder of the behavior choosen and present
%it in the middle of the screen ([0 0])

cd ..\.. %go back to the main folder of the task
snd = AudioSound(null_);
snd.List = 'sound.wav';
scene_sound = create_scene(snd);
%create the sound played when the subject successes at the trial

max_reaction_time = 7000;

% create scenes: fixation and presentation of the choosen behavior in the
% middle of the screen
fix1 = SingleTarget(triangle);  
fix1.Target = triangle.Position;  
fix1.Threshold = triangle.Size*1.3; 
wth1 = WaitThenHold(fix1);     
wth1.WaitTime = max_reaction_time;
wth1.HoldTime = 0; %no need to hold the click for a certain time 
scene_fix = create_scene(wth1);  

btw = SingleTarget(between);
btw.Threshold = 0;
wthb = TimeCounter(btw);
wthb.Duration = 1500; %waiting time of 1.5s between fixation and trial
scene_between = create_scene(wthb);

fix2 = SingleTarget(im);
fix2.Target = im.Position;
fix2.Threshold = im.Size*1.3;
wth2 = WaitThenHold(fix2);
wth2.WaitTime = max_reaction_time;
wth2.HoldTime = 0; %no need to hold the click for a certain time
scene_step2 = create_scene(wth2);

% TASK:
error_type = 0; %initialisation of the error type recorded in the metadata

run_scene(scene_fix,10);        
rt = wth1.AcquiredTime;      
if wth1.Waiting %if the time waited is superior to the max reaction time        
    error_type = 1; %return error type 1 (waited time exceded in fixation)      
end
idle(0)

if 0==error_type %if the subject clicked on the fixation dot
    run_scene(scene_between); %run the waiting time and then the trial
    run_scene(scene_step2,20);
    rt = wth2.AcquiredTime;
    if wth2.Waiting %if the time waited is superior to the max reaction time 
        error_type = 2; %return error type 2 (waited time exceded in trial)      
    end
end
idle(0)

% reward
if 0==error_type %if the trial is a success
    run_scene(scene_sound,100); %play the sound twice
    run_scene(scene_sound,100);
    idle(0);                 
    goodmonkey(100, 'juiceline',1, 'numreward',10, 'pausetime', 0); 
    %and give the reward twice
else
    idle(700); %otherwise, wait 0.7s before the next trial            
end

trialerror(error_type); %record the error type in the metadata 
