%% This is the final version
%% Import
close all
%clear all
%dataOutput3 = struct;
clearvars -except dataOutput3

%xxxx = load('/Users/carolinemyers/Desktop/NormalizedData2/dataOutput3.mat');
%% Load experimental data. You should have a structure
%For subject XX

% subjectID = 'XX';
% ExpNo = 'u'; %u, u1, u2
% %load behavioral %where S = session
% behavioral.S1 = load('XXfile.mat')
% behavioral.S2 = load('XXfile.mat')
% behavioral.S3 = load('XXfile.mat')
% behavioral.S4 = load('XXfile.mat')
% behavioral.S5 = load('XXfile.mat')
% 
% %load saccade data
% addpath('sacInfo')
% sac.S1 = load('XXfile_sacInfo.mat')
% sac.S2 = load('XXfile_sacInfo.mat')
% sac.S3 = load('XXfile_sacInfo.mat')
% sac.S4 = load('XXfile_sacInfo.mat')
% sac.S5 = load('XXfile_sacInfo.mat')
% 
% 
% % %load edata
% addpath('edata')
% edata1.S1 = load('XXfile_edata.mat')
% edata1.S2 = load('XXfile_edata.mat')
% edata1.S3 = load('XXfile_edata.mat')
% edata1.S4 = load('XXfile_edata.mat')
% edata1.S5 = load('XXfile_edata.mat')

%% Make figures for non-saccade condition
neutralFigure = figure;
trialCounterNoSaccade = 0; %set trial counter at 0, this will count all trials in loop
fn = fieldnames(edata1); %get names of fields in input edata structure
 %preinit struct to fill with all of our data

for sessionnum = 1:numel(fn) %for all sessions in edata
    tempSnumber = strcat('S',num2str(sessionnum)); %this is how we temporarily index our session number, S is hard coded!!
    for blocknum = 1:length(edata1.(tempSnumber).edata)%for all blocks in input Edata for this session
         tempBnumber = strcat('B',num2str(blocknum));  %this is how we temporarily index our block number, B is hard coded!!
        
        %Setting loop to go through trials
        for trialnum = 1:length(edata1.(tempSnumber).edata(blocknum).pupil) %for all trials for this session and block, number of pupil entries (NOT lengths of each entry) will correspond to num trials
            tempTnumber = strcat('T',num2str(trialnum)); %this is how we temporarily index our trial number, T is hard coded!!
            %Condition 1, valid cue
            if  behavioral.(tempSnumber).trialInfo(blocknum).saccade(:) == 1 &  sac.(tempSnumber).sacInfo(blocknum).sacgoodtrial(trialnum) == 1 %If saccade = 1 (not 0) this is a neutral block, and if there was no bad saccade
                trialCounterNoSaccade = trialCounterNoSaccade + 1; %this counts as a good trial, update counter
                
                %extracting pupil size and timer for this trial
                tempPupilSize = edata1.(tempSnumber).edata(blocknum).pupil{1, trialnum}; %the pupil size for this trial
                tempTimer = edata1.(tempSnumber).edata(blocknum).timer{1, trialnum};%get the corresponding timer
                %disp('done extracting edata info')
                print('stupid bitch caroline ur running the wrong section')
                %extracting start time and end time for "normalization period"
                NormWindowStart = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum) - 200; %we want to normalize based on the 200 ms before cue onset
                NormWindowEnd = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum);%the window ends with cue onset
                %disp('extract normalization info')
                
                %Calculating baseline for normalization
                tempBaseline =  mean(tempPupilSize(NormWindowStart:NormWindowEnd)); %the average pupil size from -200 ms to cue onset for this trial, this is what we normalize by
                %disp('calculate baseline')
                
                clear normPupilSize
                %Getting normalized data
                for ii = 1:length(tempPupilSize) %since they are all different lengths
                    normPupilSize(ii) = ((tempPupilSize(ii)-tempBaseline)/tempBaseline)*100;
                end
                %disp('calculated normalized data')
                
                %get temp adjusted saccade onset
               
                
                
                %saving data set to structure
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).Pupil = normPupilSize; %Get pupil size for all time points, relative to fixation
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).Time = tempTimer;%Get timer
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).Saccade = behavioral.(tempSnumber).trialInfo(blocknum).saccade(trialnum);
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).sacgoodtrial = sac.(tempSnumber).sacInfo(blocknum).sacgoodtrial(trialnum);
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).sacnbads = sac.(tempSnumber).sacInfo(blocknum).sacnbads(trialnum);
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).cueOnset = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum);
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).stimOnset = edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum);
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).SOA = (edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum)) - (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum));
                
                dataOutput3.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).AdjSacOnset = (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum)) + (sac.(tempSnumber).sacInfo(blocknum).sacOnset(trialnum));
                
                tempSOA = (edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum)) - (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum));
                
                
                %dataOutput.(subjectID).SOAs(linenumber) = (edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum)) - (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum));
                %hist(dataOutput.(subjectID).(ExpNo).NeutralCond.(tempSnumber).(tempBnumber).(tempTnumber).SOA = (edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum)) - (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum)));
                plot(tempTimer,normPupilSize);
                set(0,'DefaultLegendAutoUpdate','off')
                %hist(tempSOA)
                
                
                %plot(edata1(1).tedfprescON(1),tempTimer(edata1(1).tedfprescON(1)))
                cueOnLine = xline(edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum),'color','r');
                %stimOnLine = xline(edata1.S1.edata(blocknum).tedfstimON(trialnum),'color', 'b');
                %stimOffLine = xline(edata1.S1.edata(blocknum).tedfstimOFF(trialnum),'color', 'c');
                %responseLine = xline(edata1.S1.edata(blocknum).tedfpress(trialnum));
              
                title(['Subject ', subjectID,', Experiment ',ExpNo, ', neutral condition']);

                %ylim([-100,100])
                hold on;
                
                ylim([-100,100])
            else
            end
            % hold on
            disp(blocknum)
        end
        %hold on
    end
end
hold on
%Marisize(12,1);
ylim([-100,100]);
shg
disp(['Total number of trials without saccades = ', num2str(trialCounterNoSaccade)]);
numberBlocksNoSaccade = trialCounterNoSaccade/length(edata1.(tempSnumber).edata(blocknum).pupil);
disp(['Total number of blocks without saccades = ', num2str(numberBlocksNoSaccade)]);


%% Now saccade condition

sacFigure = figure; 
trialCounterSaccade = 0;
fn = fieldnames(edata1);
preSacWindow = [];
trialLength = [];
CueOnTimes = [];
pupilSizesAll = [];
StimOnTimes = [];
StimOffTimes = [];
timeFirstSac = [];
SOAs = [];
stimOnData = [];
stimOffData = [];
RespOnData = [];

for sessionnum = 1:numel(fn)
    tempSnumber = strcat('S',num2str(sessionnum));
    for blocknum = 1:length(edata1.(tempSnumber).edata)
        tempBnumber = strcat('B',num2str(blocknum));
        
        %Setting loop to go through trials
        for trialnum = 1:length(edata1.(tempSnumber).edata(blocknum).pupil)
            tempTnumber = strcat('T',num2str(trialnum));
            
            %only count blocks where there is a saccade and trials where
            %there is a good saccade
            if  behavioral.(tempSnumber).trialInfo(blocknum).saccade(:) == 2  &  sac.(tempSnumber).sacInfo(blocknum).sacgoodtrial(trialnum) == 1 %if it's a saccade block and the trial is a good saccade
                trialCounterSaccade = trialCounterSaccade + 1;
                
                %extracting pupil size and timer for this trial
                tempPupilSize = edata1.(tempSnumber).edata(blocknum).pupil{1, trialnum};
                tempTimer = edata1.(tempSnumber).edata(blocknum).timer{1, trialnum};
                %disp('done extracting edata info')
                
                %extracting start time and end time for normalization period
                NormWindowStart = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum) - 200;
                NormWindowEnd = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum);
                %disp('extract normalization info')
                
                %Calculating baseline for normalization
                tempBaseline =  mean(tempPupilSize(NormWindowStart:NormWindowEnd));
                %disp('calculate baseline')
                
                %Blink Interpolation
                [blinkPupilSize] = blinkinterp(tempPupilSize,1000,5,3,50,75);
                
                
                clear normPupilSize
                %Getting normalized data
                for ii = 1:length(blinkPupilSize)
                    normPupilSize(ii) = ((blinkPupilSize(ii)-tempBaseline)/tempBaseline)*100;
                end
                %disp('calculated normalized data')
                
                %get temp sac onset time
                tempSacOnset = (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum)) + (sac.(tempSnumber).sacInfo(blocknum).sacOnset(trialnum));
                
                interestStart = tempSacOnset-74;
                interestEnd = tempSacOnset+1;
                
                dataTime = tempTimer(interestStart:interestEnd);
                dataPupilSize = normPupilSize(interestStart:interestEnd);
                
                preSacWindow = [preSacWindow; dataPupilSize];
                
                
                %getting data zeroed at Cue Onset
                allStart = tempSacOnset;
                allNormPupilSize = normPupilSize(allStart:length(normPupilSize));
                allPupilSize = tempPupilSize(allStart:length(tempPupilSize));
                allTimer = tempTimer(allStart:length(tempTimer));
                allTimer = [1-75:length(allTimer)-75];
%        
                
                %pulling out average StimOn
                tempStimOn = edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum);
                tempStimOff = edata1.(tempSnumber).edata(blocknum).tedfstimOFF(trialnum);
                tempRespOn = edata1.(tempSnumber).edata(blocknum).tedfstimOFF(trialnum) + 400;
                stimOnData = [stimOnData;tempStimOn];
                stimOffData = [stimOffData;tempStimOff];
                RespOnData = [RespOnData;tempRespOn];
                
                %get trial lengths and put them in a matrix
                temptemptrialLength = length(normPupilSize);
                trialLength = [trialLength; temptemptrialLength];
                
                %get SOA lengths and put them in a matrix
                temptempSOA = (edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum)) - (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum));
                SOAs = [SOAs; temptempSOA];
                
                %get cue on times and put them in a matrix
                temptempCueOn = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum);
                CueOnTimes = [CueOnTimes; temptempCueOn];
                
                %get stim on times and put them in a matrix
                temptempStimOn = edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum);
                StimOnTimes = [StimOnTimes; temptempStimOn];
                
                %get stim on times and put them in a matrix
                temptempStimOff = edata1.(tempSnumber).edata(blocknum).tedfstimOFF(trialnum);
                StimOffTimes = [StimOffTimes; temptempStimOff];
                
                %get time of first saccade and put them in a matrix
                timeFirstSac = [timeFirstSac;tempSacOnset];
                
                %pupilSizesAll = [timeFirstSac;tempSacOnset];
                %pupilSizesAll(1:length(normPupilSize) = [pupilSizesAll; normPupilSize];
                
                currentPupilSize = nan(1,5000);
                currentPupilSize(1:length(normPupilSize)) = normPupilSize;
                
                pupilSizesAll = [pupilSizesAll; currentPupilSize];
                clearvars currentPupilSize
             
                 %saving data set to structure
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).Pupil = normPupilSize;%Get pupil size for all time points, relative to fixation
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).Time = tempTimer;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).Saccade = behavioral.(tempSnumber).trialInfo(blocknum).saccade(trialnum);
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).sacgoodtrial = sac.(tempSnumber).sacInfo(blocknum).sacgoodtrial(trialnum);
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).sacnbads = sac.(tempSnumber).sacInfo(blocknum).sacnbads(trialnum);
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).cueOnset = edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum);
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).stimOnset = edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum);
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).SOA = (edata1.(tempSnumber).edata(blocknum).tedfstimON(trialnum)) - (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum));
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).AdjSacOnset = (edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum)) + (sac.(tempSnumber).sacInfo(blocknum).sacOnset(trialnum));
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).allTimer = allTimer;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).allNormPupilSize = allNormPupilSize;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.(tempSnumber).(tempBnumber).(tempTnumber).allPupilSize = allPupilSize;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.timeFirstSac = timeFirstSac;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.StimOnTimes = StimOnTimes;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.StimOffTimes = StimOffTimes;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.CueOnTimes = CueOnTimes;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.trialLength = trialLength;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.SOAs = SOAs;
                dataOutput3.(subjectID).(ExpNo).SaccadeCond.pupilSizesAll = pupilSizesAll;
                %dataOutput.(subjectID).(ExpNo).SaccadeCond.trialLength = trialLength;
                
                
                plot(tempTimer,normPupilSize);
                %pupilSizesAll = [pupilSizesAll; normPupilSize];
                
                %plot(edata1(1).tedfprescON(1),tempTimer(edata1(1).tedfprescON(1)))
                %cueOnLine = xline(edata1.(tempSnumber).edata(blocknum).tedfprescON(trialnum),'color','r');
                %stimOnLine = xline(edata1.S1.edata(blocknum).tedfstimON(trialnum),'color', 'b');
                %stimOffLine = xline(edata1.S1.edata(blocknum).tedfstimOFF(trialnum),'color', 'c');
                %responseLine = xline(edata1.S1.edata(blocknum).tedfpress(trialnum));
                
                title(['Subject ', subjectID,', Experiment ',ExpNo, ', saccade condition']);

                ylim([-100,100]);
                xlim([-75,3500]);
                hold on;
                ylim([-100,100]);
                xlim([-75,3500]);

            else
            end
             hold on
            strcat('Session  ',tempSnumber,' Block  ',tempBnumber);
        end
        hold on
    end
end
dataOutput3.(subjectID).(ExpNo).SaccadeCond.preSacWindow = preSacWindow;
dataOutput3.(subjectID).(ExpNo).SaccadeCond.trialLength = trialLength;
hold on

ylim([-100,100]);
xlim([0,1500]);
shg;

%take average StimOn time
stimOnAvg = mean(stimOnData);
gcf
cueOnAvgLine = xline(mean(CueOnTimes),'color', 'b');
stimOnAvgLine = xline(mean(StimOnTimes),'color', 'r');
stimOffAvgLine = xline(mean(StimOffTimes),'color', 'r');
RespCueAvgLine = xline(mean(RespOnData),'color', 'k');
timeFirstSacLine = xline(mean(timeFirstSac),'color', 'c');
hold on
xlim([0 1500]);
ylim([-100 100]);
hold on
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);

hold on
xlim([0 1500]);
ylabel('% Change from baseline');
Marisize(12,1);


disp(['Total number of trials with saccades = ', num2str(trialCounterSaccade)]);
numberBlocksSaccade = trialCounterSaccade/length(edata1.(tempSnumber).edata(blocknum).pupil);
disp(['Total number of blocks with saccades = ', num2str(numberBlocksSaccade)]);


cd /Users/carolinemyers/Desktop/NormalizedData2/;
save('dataOutput3.mat','dataOutput3');

%% PLot 
%horzcat length and SOAs

trialEventss = horzcat(CueOnTimes,timeFirstSac, StimOnTimes,StimOffTimes);
LengthSOAs = horzcat(trialLength,SOAs);

sortedTL = sort(trialLength);


horzcat
figure
subplot(1,2,1)
histogram(LengthSOAs(:,2));
xlim([10,225])
avgSOA = mean(LengthSOAs(:,2))
minSOA = min(LengthSOAs(:,2))
maxSOA = max(LengthSOAs(:,2))
avgLength = mean(LengthSOAs(:,1))
minLength = min(LengthSOAs(:,1))
maxLength = max(LengthSOAs(:,1))
title(['Distribution of SOAs- ',num2str(subjectID)])
Marisize(12,1)
hold on 
annotation(gcf,'textbox',...
    [0.347428571428571 0.835714285714286 0.0972142857142857 0.0571428571428573],...
    'String',{'Avg = ',num2str(avgSOA), 'min = ', num2str(minSOA), 'max= ', num2str(maxSOA)},...
    'FitBoxToText','on');
hold on
subplot(1,2,2)
histogram(LengthSOAs(:,1),50);
hold on
annotation(gcf,'textbox',...
    [0.765285714285713 0.752380952380953 0.11875 0.142857142857143],...
    'String',{'Avg = ',num2str(avgLength), 'min = ', num2str(minLength), 'max = ',num2str(maxLength)},...
    'FitBoxToText','on');
hold on
title(['Distribution of Trial Lengths- ',num2str(subjectID)])
avgTrialLength = mean(LengthSOAs(:,1))
Marisize(12,1)
shg
