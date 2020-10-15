

%% Reconstruct spike train
clear;
clc;

load('times_CSC3.mat');
clusterID=cluster_class(:,1);
timestamps=cluster_class(:,2);
timestampsSec=(timestamps-timestamps(1))/1000;
numAllSpikes=length(timestampsSec);

sr=32768;                       %sampling rate in Hz
w_pre=19;						%Number of datapoints before spike
w_post=44;						%Number of datapoints after spike

duration=timestampsSec(end)+2;
durationDatapoints=floor(duration*sr);

numCluster=max(clusterID)+1;

spikeTrain=zeros(1,durationDatapoints);

for i=1:numCluster
    cluster(i).spkTrain=zeros(1,durationDatapoints);
end

for i=1:numAllSpikes
    peakIndex=floor(timestampsSec(i)*sr);
    peakIndex
    spikeTrain( (peakIndex-w_pre+sr) : (peakIndex+w_post+sr) )=spikes(i,:);
    cluster(clusterID(i)+1).spkTrain( (peakIndex-w_pre+sr) : (peakIndex+w_post+sr) )=spikes(i,:);
%     spikeTrainMat(clusterID(i)+1, (peakIndex-w_pre+sr) : (peakIndex+w_post+sr) )=spikes(i,:);
end

figure();
plot(spikeTrain(1:(60*sr)));

myColors{1}='r';
myColors{2}='g';
myColors{3}='b';
myColors{4}='m';
myColors{5}='c';
myColors{6}='y';
myColors{7}='k';

% figure();
% hold on;
% for i=1:numCluster
%     plot(spikeTrainMat(i,1:(60*sr)),myColors{i});
% end

for i=1:numCluster
%     autocorr=xcorr(spikeTrainMat(i,(1:(60*sr))),spikeTrainMat(i,(1:(60*sr))),floor(0.1*sr));
    autocorr=xcorr(cluster(i).spkTrain(1:(60*sr)),  cluster(i).spkTrain(1:(60*sr)),  floor(0.1*sr));
    figure();
    plot(autocorr);
end


clear spikeTrain;
clear autocorr;

close all;

figure(666)
for i=1:numCluster
    for j=i:numCluster
        subplot(numCluster,numCluster,(i-1)*numCluster+j)
        autocorr=xcorr(cluster(i).spkTrain(1:(60*sr*1.5)),  cluster(j).spkTrain(1:(60*sr*1.5)),  floor(0.1*sr));
        plot(autocorr);
    end 
end

return;

figure();
hold on;
for i=1:numCluster
    cluster(i).spikes=spikes(clusterID==i-1,:);
    cluster(i).mean=mean(cluster(i).spikes);
    cluster(i).std=std(cluster(i).spikes);
    cluster(i).baseline=mean(cluster(i).mean(1:8));
    
    plot(cluster(i).mean,myColors{i}, 'Linewidth', 5)
    plot(cluster(i).mean+cluster(i).std,myColors{i}, 'Linewidth', 1)
    plot(cluster(i).mean-cluster(i).std,myColors{i}, 'Linewidth', 1)
end
hold off;


for i=1:numCluster
    figure();
    hold on;
    plot(cluster(i).mean,myColors{i}, 'Linewidth', 5)
    plot(cluster(i).mean+cluster(i).std,myColors{i}, 'Linewidth', 1)
    plot(cluster(i).mean-cluster(i).std,myColors{i}, 'Linewidth', 1)
    hold off;
end