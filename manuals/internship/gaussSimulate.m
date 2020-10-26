clear all;
clc;
 
load("times_CSC62.mat");

clusterID=cluster_class(:,1);
timestamps=cluster_class(:,2);

numAllSpikes=length(timestamps);
totalSec = timestamps(end) - timestamps(1);
bin_size = 1000;
totalBins = round(totalSec / bin_size);

edges = linspace(timestamps(1), timestamps(end), totalBins);

numCluster=max(clusterID)+1;

% populate table with firing rates, plot
for i=1:numCluster
    cluster(i).binnedTrain=histcounts(timestamps(clusterID == i), totalBins);
    
    figure;
    plot(edges, cluster(i).binnedTrain);
end

% get parameters
for i=1:numCluster
    cluster(i).averageFR = mean(cluster(i).binnedTrain);
    cluster(i).stdFR = std(cluster(i).binnedTrain);
end

% define gaussians
for i=1:numCluster
    gaussians(i).results = normrnd(cluster(i).averageFR, cluster(i).stdFR, [1, totalBins]);
end

