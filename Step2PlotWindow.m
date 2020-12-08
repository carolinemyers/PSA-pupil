%% Step 2: Plot pupil traces
%v1: original code written by Caroline Myers 10/1/20


%% Readme
%This script plots raw pupil traces- it takes the output of Step 1, which,
%if run for each subject and condition, should be dataOutput3

%dataOutput3 structure:

%dataOutput3: contains all subjects. For each subject, you have 3
%conditions (u, u1, u2 corresponding to low, medium, high uncertainty)
%We only have the saccade condition, but inside you have:

%S1-Sn: raw pupil size for every session
%timeFirstSac: Time of first saccade
%StimOnTimes: time point of stimulus onset
%StimOffTimes: time point of stimulus offset
%CueOnTimes: time point of stimulus offset
%trialLength: self-explanatory
%SOAs: length of time between cue and stimulus
%pupilSizesAll: normed pupil sizes for every time point; rows are trials, columns are time
%preSacWindow: rows are trials, columns are start time of 200 ms before
%saccade
%meansPupilSizesAll: mean pupil sizes drawn from every trial in every
%session




%% Init
clear all
load('dataOutput3.mat')
%dataOutput3 = dataOutput
clearvars dataOutput

%% Plug in condition and subject here

condition = 'u';
subjectID = 'HL';


%% Plot pupil traces for each subject for each condition- NOT excluding trials
figure
subplot(3,1,1);
uplot = plot(dataOutput3.(subjectID).u.SaccadeCond.pupilSizesAll');
hold on
stimOnAvgLineu = xline(mean(dataOutput3.(subjectID).u.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on
cueOnAvgLineu = xline(mean(dataOutput3.(subjectID).u.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

xlim([0 1500]);
ylim([-100 100]);
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);
ledgy = legend([patchy,stimOnAvgLineu,cueOnAvgLineu],{'normalization period','avg. stim on','avg. cue on'},'Location','Southwest');
title(['Subject ',num2str(subjectID),' Exp. u']);
ylabel(['% change from baseline']);
xlabel('time');
Marisize(12,1)


%now u1
subplot(3,1,2)
u1plot = plot(dataOutput3.(subjectID).u1.SaccadeCond.pupilSizesAll');
hold on
stimOnAvgLineu1 = xline(mean(dataOutput3.(subjectID).u1.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on
cueOnAvgLineu1 = xline(mean(dataOutput3.(subjectID).u1.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

xlim([0 1500]);
ylim([-100 100]);
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);
title(['Subject ',num2str(subjectID),' Exp. u1']);
ylabel(['% change from baseline']);
xlabel('time');
Marisize(12,1)
%now u2
subplot(3,1,3);
u2plot = plot(dataOutput3.(subjectID).u2.SaccadeCond.pupilSizesAll'); 
hold on
stimOnAvgLineu2 = xline(mean(dataOutput3.(subjectID).u2.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on
cueOnAvgLineu2 = xline(mean(dataOutput3.(subjectID).u2.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

xlim([0 1500]);
ylim([-100 100]);
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);
title(['Subject ',num2str(subjectID),' Exp. u2']);
hold off
ylabel(['% change from baseline']);
xlabel('time');
Marisize(12,1)

%% Data cleaning
%let's take out trials that contain pupil sizes that are greater than a
%certain threshold. It's not physically possible for pupil size to shoot up
%to past 50% change from baseline so rapidly. 

%Some studies suggest that this could be due to the fact that these are
%saccadic trials, and our measure of pupil size is thrown off
%by changes in gaze position when subjects are saccading to upcoming stimulus locations. 

%So, let's set a cutoff (threshold) and exclude trials that contain pupil
%values exceeding that threshold. Mathot et al weren't sure what to do with this either 

%Ideally, we'll run this for every subject and condition separately (by
%plugging in the SubID and condition) because we want to see what our data even looks
%like. It's only 4 subjects, we'll live. 

%comment this out if not the first time this is run:
%dataOutput3copy = dataOutput3

threshold = 50; 
dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded = [];
for kk = 1:size(dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAll,1)
    tempMax = max(dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAll(kk,:));
    %maximumPupilSizesTrials = maximumPupilSizesTrials';
    if tempMax < threshold
        dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded = [dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded;dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAll(kk,:)];
        
    else 
    end

end

%now get the mean pupil size for each time point, for the cleaned data. 
%This is what we'll plot later on. 
meansExcluded = nan(1,size(dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded,2));

for jj = 1:size(dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded,2)
    meansExcluded(jj) = (mean(dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded(:,jj),'omitnan'));
end
dataOutput3copy.(subjectID).(condition).SaccadeCond.meansPupilSizesAllExcluded = meansExcluded;
save('dataOutput3copy.mat','dataOutput3copy', '-v7.3');


%% Now plot new traces, excluding trials that denote impossible changes in pupil size >50
figure
subplot(3,1,1);
uplot = plot(dataOutput3copy.(subjectID).u.SaccadeCond.pupilSizesAllExcluded');
hold on
stimOnAvgLineu = xline(mean(dataOutput3copy.(subjectID).u.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on
cueOnAvgLineu = xline(mean(dataOutput3copy.(subjectID).u.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

xlim([0 1500]);
ylim([-100 100]);
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);
ledgy = legend([patchy,stimOnAvgLineu,cueOnAvgLineu],{'normalization period','avg. stim on','avg. cue on'},'Location','Southwest');
title(['Subject ',num2str(subjectID),' Exp. u']);
ylabel(['% change from baseline']);
xlabel('time');
Marisize(12,1) 


%now u1
subplot(3,1,2)
u1plot = plot(dataOutput3copy.(subjectID).u1.SaccadeCond.pupilSizesAllExcluded');
hold on
stimOnAvgLineu1 = xline(mean(dataOutput3copy.(subjectID).u1.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on
cueOnAvgLineu1 = xline(mean(dataOutput3copy.(subjectID).u1.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

xlim([0 1500]);
ylim([-100 100]);
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);
title(['Subject ',num2str(subjectID),' Exp. u1']);
ylabel(['% change from baseline']);
xlabel('time');
Marisize(12,1)
%now u2
subplot(3,1,3);
u2plot = plot(dataOutput3copy.(subjectID).u2.SaccadeCond.pupilSizesAllExcluded'); 
hold on
stimOnAvgLineu2 = xline(mean(dataOutput3copy.(subjectID).u2.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on
cueOnAvgLineu2 = xline(mean(dataOutput3copy.(subjectID).u2.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

xlim([0 1500]);
ylim([-100 100]);
x = [200 400 400 200];
y = [-100  -100   100   100];
patchy = patch(x,y,'red','FaceAlpha',.3);
title(['Subject ',num2str(subjectID),' Exp. u2']);
hold off
ylabel(['% change from baseline']);
xlabel('time');
Marisize(12,1)


%% Now plot NEW means


figure
%condtion u
uPlot = plot(dataOutput3copy.(subjectID).u.SaccadeCond.meansPupilSizesAllExcluded,'color','g','Linewidth',2);
hold on
stimOnAvgLineu = xline(mean(dataOutput3copy.(subjectID).u.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on

%condtion u1
u1Plot = plot(dataOutput3copy.(subjectID).u1.SaccadeCond.meansPupilSizesAllExcluded,'color','b','Linewidth',2);
hold on
stimOnAvgLineu1 = xline(mean(dataOutput3copy.(subjectID).u1.SaccadeCond.StimOnTimes),'color','b','Linewidth',2,'Linestyle','--');
hold on

%condtion u2
u2Plot = plot(dataOutput3copy.(subjectID).u2.SaccadeCond.meansPupilSizesAllExcluded,'color','r','Linewidth',2);
hold on
stimOnAvgLineu2 = xline(mean(dataOutput3copy.(subjectID).u2.SaccadeCond.StimOnTimes),'color','r','Linewidth',2,'Linestyle','--');
hold on

% add line
cueOnAvgLineu2 = xline(mean(dataOutput3copy.(subjectID).u2.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

hold on
%shade in normalization period
x = [200 400 400 200];
y = [-5  -5   20   20];
patchy = patch(x,y,'red','FaceAlpha',.3);
hold on

addpath('Analysis')
gcf
Marisize(12,1)
%legend('u','u1','u2')

ledgy = legend([uPlot u1Plot u2Plot cueOnAvgLineu2 stimOnAvgLineu patchy],{'u', 'u1', 'u2','cue on','stim on','normalization period'});
set(ledgy,'Location','northwest');
ylabel('% change from baseline')
xlabel('time')



xlim([0 1500])
ylim([-5 20])
title(['% change from baseline, all conditions, sub. ',num2str(subjectID)])
shg
save('dataOutput3copy.mat','dataOutput3copy', '-v7.3');
%% junk    
%     if dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAll.(kk) > 50
%     %if kk contains pupil size > 5
%     dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded(kk,:) = nan
%     else
%         dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAllExcluded(kk,:) = dataOutput3copy.(subjectID).(condition).SaccadeCond.pupilSizesAll(kk,:);
%     end
%     %means(kk) = (mean(dataOutput3.(subjectID).(condition).SaccadeCond.pupilSizesAll(kk,:),'omitnan'));
% end
%% Get means
means = nan(1,size(dataOutput3.(subjectID).(condition).SaccadeCond.pupilSizesAll,2));

for jj = 1:size(dataOutput3.(subjectID).(condition).SaccadeCond.pupilSizesAll,2)
    means(jj) = (mean(dataOutput3.(subjectID).(condition).SaccadeCond.pupilSizesAll(:,jj),'omitnan'));
end
dataOutput3.(subjectID).(condition).SaccadeCond.meansPupilSizesAll = means;
save('dataOutput3.mat','dataOutput3');


%% Plot mean pupil sizes for all conditions

figure
%condtion u
uPlot = plot(dataOutput3.(subjectID).u.SaccadeCond.meansPupilSizesAll,'color','g','Linewidth',2);
hold on
stimOnAvgLineu = xline(mean(dataOutput3.(subjectID).u.SaccadeCond.StimOnTimes),'color','k','Linewidth',2, 'Linestyle','--');
hold on

%condtion u1
u1Plot = plot(dataOutput3.(subjectID).u1.SaccadeCond.meansPupilSizesAll,'color','b','Linewidth',2);
hold on
stimOnAvgLineu1 = xline(mean(dataOutput3.(subjectID).u1.SaccadeCond.StimOnTimes),'color','b','Linewidth',2,'Linestyle','--');
hold on

%condtion u2
u2Plot = plot(dataOutput3.(subjectID).u2.SaccadeCond.meansPupilSizesAll,'color','r','Linewidth',2);
hold on
stimOnAvgLineu2 = xline(mean(dataOutput3.(subjectID).u2.SaccadeCond.StimOnTimes),'color','r','Linewidth',2,'Linestyle','--');
hold on

% add line
cueOnAvgLineu2 = xline(mean(dataOutput3.(subjectID).u2.SaccadeCond.CueOnTimes),'color','k','Linewidth',2);

hold on
%shade in normalization period
x = [200 400 400 200];
y = [-5  -5   20   20];
patchy = patch(x,y,'red','FaceAlpha',.3);
hold on

addpath('Analysis')
gcf
Marisize(12,1)
%legend('u','u1','u2')

ledgy = legend([uPlot u1Plot u2Plot cueOnAvgLineu2 stimOnAvgLineu patchy],{'u', 'u1', 'u2','cue on','stim on','normalization period'});
set(ledgy,'Location','northwest');
ylabel('% change from baseline')
xlabel('time')



xlim([0 1500])
ylim([-5 20])
title(['% change from baseline, all conditions, sub. ',num2str(subjectID)])
shg

%% Plot SOAs
trialEvents = horzcat(dataOutput3.(subjectID).(condition).SaccadeCond.CueOnTimes,dataOutput3.(subjectID).(condition).SaccadeCond.timeFirstSac,dataOutput3.(subjectID).(condition).SaccadeCond.StimOnTimes,dataOutput3.(subjectID).(condition).SaccadeCond.StimOffTimes);

LengthSOAs = horzcat(dataOutput3.(subjectID).(condition).SaccadeCond.trialLength,dataOutput3.(subjectID).(condition).SaccadeCond.SOAs);

sortedTL = sort(dataOutput3.(subjectID).(condition).SaccadeCond.trialLength);


horzcat
figure
subplot(1,2,1)
histogram(LengthSOAs(:,2));
xlim([10,225])
avgSOA = mean(LengthSOAs(:,2));
minSOA = min(LengthSOAs(:,2));
maxSOA = max(LengthSOAs(:,2));
medSOA = median(LengthSOAs(:,2));

avgLength = mean(LengthSOAs(:,1));
minLength = min(LengthSOAs(:,1));
maxLength = max(LengthSOAs(:,1));
medLength = median(LengthSOAs(:,1));
title(['SOAs- ',num2str(subjectID),', exp ' num2str(condition)]);
Marisize(12,1);
hold on ;
annotation(gcf,'textbox',...
    [0.347428571428571 0.835714285714286 0.0972142857142857 0.0571428571428573],...
    'String',{'Avg = ',num2str(avgSOA),'median = ',num2str(medSOA) ,'min = ', num2str(minSOA), 'max= ', num2str(maxSOA)},...
    'FitBoxToText','on');
hold on;
subplot(1,2,2);
histogram(LengthSOAs(:,1),50);
hold on;
annotation(gcf,'textbox',...
    [0.765285714285713 0.752380952380953 0.11875 0.142857142857143],...
    'String',{'Avg = ',num2str(avgLength), 'median = ', num2str(medLength),'min = ', num2str(minLength), 'max = ',num2str(maxLength)},...
    'FitBoxToText','on');
hold on;
title(['Trial Lengths- ',num2str(subjectID),', exp ' num2str(condition)]);
avgTrialLength = mean(LengthSOAs(:,1));
Marisize(12,1);
shg

