
function [amp,phase,mask]=smallam2(A00,A09,A18,A27,Ami,Apl,Ams,delta,postnr,ismed2)
%function[amp,phase,mask]=smallam2 (A00,A09,Al8,A27,Ami,Apl,Ams,delta,postnr,ismed2)
% smallam2 uses the output from smallam1 to produce the result matrices amp,phase
% and mask. delta is the amplitude increment in meters used for I+delta and I-delta.
% If postnr is nonzero amp and phase are median or convolution filtered postnr times.
% ismed=l for median and ismed=0 for convolution. The mask is used to erase nonvalid
% areas of the matrices,

tic

I1=A09-A27;
I2=A18-A00;

phase=atan2(I1,I2);

I3=sqrt(I1.^2+I2.^2);

slope=Ami-Apl;
[m,n]=size(slope);
for i=1:m
for j=1:n
if slope(i,j)~=0
amp(i,j)=delta*I3(i,j)/slope(i,j);
else
amp(i,j)=0;

end
end
end
if postnr>0
if ismed2==1
for i=1:postnr
phase=median2(phase,Ams);
amp=median2(amp,Ams);
end
else
for i=1:postnr
phase=conv2(phase,ones(3),'same')/9;
amp=conv2(amp,ones(3),'same')/9;
end
end
end
mask=Ams;
toc
