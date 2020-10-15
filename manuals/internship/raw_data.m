function raw_values = raw_data(TimeToStart,TimeToStop)

%clc;                %Clear screen
%clear all;          %delete all variables in current workspace

%TimeToStart=0;           %when to start reading (in sec)
%TimeToStop=600;           %when to stop reading (in sec)
sr=32768;               %sampling rate in Hz
%passband=[300 3000];    %passband in Hz
ncsFile=fopen('CSC3.ncs', 'r');        %openFile in read mode
headerLength=1024*16;                   %16KB header length
DatapointsPerPackage=512;
BytesOfDatapointsPerPackage=DatapointsPerPackage*2;
 packageHeaderLength=8+4+4+4;                  %20B packageHeaderLength
 packageLength=BytesOfDatapointsPerPackage+packageHeaderLength;      %Total package length
 ncsHeaderInfo=fread(ncsFile, headerLength, 'uint8=>char');  %Read Header
% sprintf('%s', ncsHeaderInfo)                              %Display Header
 DataPointsToStart=floor(sr*TimeToStart);
 BytesOfDataPointsToStart=DataPointsToStart*2;
 PackagesToStart=floor(BytesOfDataPointsToStart/BytesOfDatapointsPerPackage);
 BytesOfHeaderToStart=PackagesToStart*packageHeaderLength;
% 
 PartlyReadPackageSize=mod(DataPointsToStart,DatapointsPerPackage);
 PointsToReadOfPartlyReadPackage=DatapointsPerPackage-PartlyReadPackageSize;
% 
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

end