function artifact = identify_artifact(spike)


artifact = false;

pks = findpeaks(spike);

mnma = spike(islocalmin(spike));

%find if there are more that one peak

pdiff = pks - max(pks);

pdiff = abs(pdiff(pdiff~=0));

if  sum([(pks - mnma)] > max(pks)*2/3) > 2            %sum(pdiff < max(pks)*2/3) > 1
    
    artifact = true;
    
end


end