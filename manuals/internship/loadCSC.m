%This script is for educational purposes on spike detection in neuronal data. It is in no way optimized for usability or speed.
%It should just give you an understanding of the basic routines you have to perform when encountering neuronal data in order to detect spikes in it.

clc;                %Clear screen
clear all;          %delete all variables in current workspace

TimeToStart=0;           %when to start reading (in sec)
TimeToStop=600;           %when to stop reading (in sec)
sr=32768;               %sampling rate in Hz
passband=[300 3000];    %passband in Hz
ncsFile=fopen('CSC3.ncs', 'r');        %openFile in read mode
headerLength=1024*16;                   %16KB header length
DatapointsPerPackage=512;
BytesOfDatapointsPerPackage=DatapointsPerPackage*2;
packageHeaderLength=8+4+4+4;                  %20B packageHeaderLength
packageLength=BytesOfDatapointsPerPackage+packageHeaderLength;      %Total package length
ncsHeaderInfo=fread(ncsFile, headerLength, 'uint8=>char');  %Read Header
sprintf('%s', ncsHeaderInfo)                              %Display Header
DataPointsToStart=floor(sr*TimeToStart);
BytesOfDataPointsToStart=DataPointsToStart*2;
PackagesToStart=floor(BytesOfDataPointsToStart/BytesOfDatapointsPerPackage);
BytesOfHeaderToStart=PackagesToStart*packageHeaderLength;

PartlyReadPackageSize=mod(DataPointsToStart,DatapointsPerPackage);
PointsToReadOfPartlyReadPackage=DatapointsPerPackage-PartlyReadPackageSize;

%Move reading position in file to the first 512 datapoints to read (past the 16KB file header and 20B package header)
if(fseek(ncsFile, headerLength+packageHeaderLength + PackagesToStart*packageLength + PartlyReadPackageSize, 'bof')==-1) %BytesOfHeaderToStart+BytesOfDataPointsToStart
        display('Sorry, fseek failed');
end
        



%Read from TimeToStart to TimeToStop
raw_values=fread(ncsFile, PointsToReadOfPartlyReadPackage, 'int16=>int16');
if(fseek(ncsFile, packageHeaderLength, 'cof'))
        display('Sorry, fseek failed');
end

raw_values=[raw_values' fread(ncsFile, floor(sr*(TimeToStop-TimeToStart)-PointsToReadOfPartlyReadPackage), '512*int16=>int16', packageHeaderLength)']';


raw_values=double(raw_values)*0.030518510385491027;

% plot(raw_values)


%close file
fclose(ncsFile);

        
%%

%Setting up a second order elliptic filter
[b a]=ellip(2, 0.1, 40, passband.*2./sr);
%Filter signal (bidirectional)
filtered_signal=filtfilt(b,a,raw_values);
        

%Calculate automatic spike threshold according to QQ.
thr=5.0/0.6745*median(abs(filtered_signal));



% % %Plot signal + threshold
% figure(1);
% hold on;
% plot(filtered_signal);
% plot([0 length(filtered_signal)] , [thr thr], 'r', 'LineWidth', 2)


searchRadius=20;
w_pre=19;						%Number of datapoints before spike
w_post=44;						%Number of datapoints after spike
intFactor=1000;     			%For cubic spline interpolation 
nspk=0;                         %Number of spikes (so far none)
ref=48;                         %Refractory period (in datapoints!)
lastpeak=-ref;               %Last peak was at index (at this point there was no peak, so we set it to a reasonable value)

i=w_pre+1;        %Start detection at index i
valuesperspike=w_pre+1+w_post;  %How many datapoints each spike will have
while(i < length(filtered_signal)-w_post)    %Loop through the whole signal (very very slow in matlab...we will improve this later)
        if(filtered_signal(i) >= thr)                      	%Is datapoint above threshold?
                    [~, imax]=max(   filtered_signal( (i-searchRadius):(i+searchRadius) ) );	%find index of maximum (peak) 
                    imax=(i-21)+imax;		%max only returns index for the little excerpt we fed it with, so we have to add the index when the excerpt started.
                            if(imax-lastpeak >= ref)			%Is peak further away from the last saved spike than the censor period?
                                 y=filtered_signal((imax-w_pre):(imax+w_post));	%copy the spike in a new variable (not really needed)
                                 y=[y(1) y' y(end)]';									%pad with zeros so that first or last point after interpolation will still be valid if peak maximum is at an interpolated value
                                 x=intFactor:intFactor:(length(y)*intFactor);	%x values of current spike 
                                 xx=1:1:(length(y)*intFactor);					%the values we want to interpolate (ratio between x and xx is important)
                                 interpolSpike=spline(x,y,xx);					%interpolate using cubic spline interpolation
                                 [~, imaxinterpol]=max(interpolSpike((w_pre*intFactor):((w_pre+2)*intFactor)));		%find new maximum (peak) after interpolation (must be near the original peak),
                                 imaxinterpol=imaxinterpol+w_pre*intFactor-1;     %max only returns index for the little excerpt we fed it with, so we have to add the index when the excerpt started.
                                 spike=interpolSpike((imaxinterpol-intFactor*w_pre):(imaxinterpol+intFactor*w_post));	%cut out the spike so that it will be aligned to the peak
                                 spike=spike(1:intFactor:end);					%downsample the spike to original sampling rate
                                 nspk=nspk+1;									%increase number of spikes
                                 spikemat(nspk, :)=spike;						%save in matrix
                                 i=i+ref;											%after spike was detected, move ref datapoints forward (increment i by ref)
                                 lastpeak=imax;	
                            end
                            %save index of last spike
        end
        i=i+1;				%increment i by 1 to move forward
end
        

%Plot spikes
figure(2)
plot(spikemat');

