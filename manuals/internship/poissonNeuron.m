clear all;

sr=32768;
firingRate=60;
signalLength = sr * 60;
prob=firingRate/sr;

absRefSec=0.001;
relRefSec=0.002;
absRevPoints=ceil(absRefSec*sr);
relRefPoints=ceil(relRefSec*sr);
recovFunc=1./(1+exp(-([-5:(10/relRefPoints):5])));

nspk=0;
lastSpikeTime=-absRevPoints-relRefPoints;

for i=1:signalLength
%             if(mod(i,10*sr)==0)
%                 disp(i)
%             end
    if(i-lastSpikeTime > absRevPoints)
        if(i-lastSpikeTime-absRevPoints > relRefPoints)
            if(rand() < prob)
               lastSpikeTime=i;
               nspk=nspk+1;
               timestamps(nspk)=i;
            end
        else
            if(rand() < prob*recovFunc(i-lastSpikeTime-absRevPoints)) 
               lastSpikeTime=i;
               nspk=nspk+1;
               timestamps(nspk)=i;
            end
        end

    end
end


timestamps=timestamps./sr;

figure()
plot(recovFunc)

figure()
plot([timestamps; timestamps], [zeros(size(timestamps)); ones(size(timestamps))], 'b')
ylim([-5 5])