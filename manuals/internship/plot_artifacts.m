figure;
%hold on
count = 0;
for ii = 1:size(spikemat,1)
 %   if mod(count,10)
        
    spike = spikemat(ii,:);
    artifact = identify_artifact(spike);
    if artifact
        plot(spike)
        pause(0.5)
    end
    count = count + 1;
end