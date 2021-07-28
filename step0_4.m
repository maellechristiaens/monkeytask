hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
%This hotkey allows the experimentator to escape the experiment when they
%want
hotkey('r', 'goodmonkey(100, ''juiceline'',1, ''numreward'',1, ''pausetime'',500);');
%This hotkey allows the experimentator to give a reward when they want
hotkey('1', 'TrialRecord.User.step=1');
hotkey('2', 'TrialRecord.User.step=2');
hotkey('3', 'TrialRecord.User.step=3');
hotkey('4', 'TrialRecord.User.step=4');
hotkey('5', 'TrialRecord.User.step=5');
%These hotkeys allow the experimentator to change the step as they want

bhv_code(10,'Fix',40, 'Step4',100,'Reward'); 
%Keep record of the events happening in the metadata

behavior_choosen = TrialRecord.User.behavior_choosen;
%store the behavior choosen for this condition 
other_unrelated_behaviors = TrialRecord.User.other_unrelated_behaviors;
%store the list of all the other behaviors of the other relationships

pos = EyeCal.norm2deg([0.2 0.2; 0.8 0.2; 0.5 0.5; 0.2 0.8; 0.8 0.8]);
%list of the 5 possible positions for the pictures

m = randperm(5,3);
%pick 3 random numbers between 1 and 5 (will be the numbers of the
%positions choosen for displaying the pictures)

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

cd(char(behavior_choosen)); %go in the folder of the choosen behavior
list_images = dir('*.bmp*');
im = ImageGraphic(touch_);
im.List = {char(list_images(1).name), pos(m(1),:), 1.1}; 
%take the last image of the subfolder of the behavior choosen and present
%it in the first random position choosen from the 5 positions possible
cd ../.. %go back to the main folder

cd Learning2 %go to the Learning2 folder (for the other behaviors)
which1 = randi([1,8]); %pick a random number between 1 and 8 (n)
cd(char(other_unrelated_behaviors(which1))); %go to the folder of the 
% nth unrelated behavior 
list_distractor1 = dir('*.bmp*');
size1 = size(list_distractor1,1);
distractor1 = randi([1,size1(1)]); 
im_incor1 = ImageGraphic(touch_); %get a random picture from the nth unrelated behavior
im_incor1.List = {char(list_distractor1(distractor1).name), pos(m(2),:), 1.1}; 
% present this picture in another random position from the 5 possible
cd .. %go back to the learning folder

which2 = randi([1,8]); %pick a random number between 1 and 8 (n)
cd(char(other_unrelated_behaviors(which2))); %go to the folder of the 
% nth unrelated behavior 
list_distractor2 = dir('*.bmp*');
size2 = size(list_distractor2,1);
distractor2 = randi([1,size2(1)]); 
im_incor2 = ImageGraphic(touch_); %get a random picture from the nth unrelated behavior
im_incor2.List = {char(list_distractor2(distractor2).name), pos(m(3),:), 1.1}; 
% present this picture in another random position from the 5 possible
cd .. %go back to the learning folder

cd .. %go back to the main folder of the task
snd = AudioSound(null_);
snd.List = 'sound.wav';
scene_sound = create_scene(snd);
%create the sound played when the subject successes at the trial

max_reaction_time = 10000;

% create scenes: fixation and presentation of the choosen behavior along 
% with 2 other unrelated behaviors in random positions of the screen 
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

fix_corr = SingleTarget(im);
fix_corr.Target = im.Position;
fix_corr.Threshold = im.Size*1.3;
wth_corr = WaitThenHold(fix_corr);
wth_corr.WaitTime = max_reaction_time;
wth_corr.HoldTime = 0; %no need to hold the click for a certain time

fix_incor1 = SingleTarget(im_incor1);
fix_incor1.Target = im_incor1.Position;
fix_incor1.Threshold = im_incor1.Size*1.3;
wth_incor1 = WaitThenHold(fix_incor1);
wth_incor1.WaitTime = max_reaction_time;
wth_incor1.HoldTime = 0; %no need to hold the click for a certain time

fix_incor2 = SingleTarget(im_incor2);
fix_incor2.Target = im_incor2.Position;
fix_incor2.Threshold = im_incor2.Size*1.3;
wth_incor2 = WaitThenHold(fix_incor2);
wth_incor2.WaitTime = max_reaction_time;
wth_incor2.HoldTime = 0; %no need to hold the click for a certain time

all_three = AllContinue(wth_corr); %display all 3 pictures at once
all_three.add(wth_incor1);
all_three.add(wth_incor2);
scene_step4 = create_scene(all_three);

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
    run_scene(scene_step4,40);
    rt = wth_corr.AcquiredTime;
    if wth_incor1.Success || wth_incor2.Success %if the subject clicks on an incorrect picture  
        error_type = 3; %return error type 3 (incorrect picture in learning)
    elseif wth_corr.Waiting %if the time waited is superior to the max reaction time 
        error_type = 2; %return error type 2 (waited time exceded in trial)
    end
end
idle(0)

% reward
if 0==error_type %if the trial is a success
    run_scene(scene_sound,100); %play the sound twice
    run_scene(scene_sound,100);
    idle(0);                 
    goodmonkey(100, 'juiceline',1, 'numreward',20, 'pausetime',10); 
    %and give the reward twice
else
    idle(700); %otherwise, wait 0.7s before the next trial              
end

trialerror(error_type); %record the error type in the metadata 
 