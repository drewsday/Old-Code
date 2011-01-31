% This script orchestrates the SI plot suite. It reads the appropriate data and  
% calls sivec 2, clrarea, placepan, stitch. Plot format specially modified for the Colloquium 
% at NIU - uses the cone plotter. 
% Input file formats
% Each file contains all bands for all directions in order xyz. 
% Data is CSV formatted with each row pertaining to one band with band 1 
% listed first. 
% There are 30 rows of data - the first 10 for x, the second for y the 
% last for z.
% All data is in dB
% References: Pressure= 2e-5 N/m^2; Power = 1e-12 W/m^2
%
% This script must be customised for the measurement grid and files

% B Copeland  September 2001


%Set data for call to sivec3
xmin = 0; ymin = 0;
threshold = 0;
dx = 7; dy = 7;
radius = 28; bowldepth = 16; skirtlength = 23; %pan parameters
cmin=35;cmax=70;

disp('SI 3D Plotting Software')
usersel = input('Please enter SI analysis type (AI, RI or SP):','s');
usersel = lower(usersel);
if usersel ~='ai'&usersel~='ri'&usersel~='sp'
   error('Wrong type specification')
end

%Edit these lines for appropriate file names
%See readme 
fp1r1 = strcat(usersel,'p1r1.csv'); 
fp1r2 = strcat(usersel,'p1r2.csv');
fp1r3=strcat(usersel,'p1r3.csv');
%fp2r1=strcat(usersel,'p2r1.csv');
%fp2r2=strcat(usersel,'p2r2.csv');
%fp2r3=strcat(usersel,'p2r3.csv');

%Get files
p1r1 = csvread(fp1r1);
p1r2 = csvread(fp1r2);
p1r3 = csvread(fp1r3);
%p2r1 = csvread(fp2r1);
%p2r2 = csvread(fp2r2);
%p2r3 = csvread(fp2r3);

% Display blocks count
blks1 = size(p1r1,2); blks2 = size(p1r2,2); blks3 = size(p1r3,2);
disp(strcat('Count Region1 :', num2str(blks1)))
disp(strcat('Count Region2 :', num2str(blks2)))
disp(strcat('Count Region3 :', num2str(blks3)))

%Check no of bands for analysis
nbands = size(p1r1,1);nbands2 = size(p1r2,1);nbands3 = size(p1r3,1);
if nbands ~= nbands2|nbands ~= nbands3
   error('Warning! Data matrices do not have same no. of rows!')
end
nbands = nbands/3;
if round(nbands) ~=nbands
   error('At least one data matrix does not have same number of x,y or z analysis bands') 
end
disp(strcat('No. of frequency bands:',' ',num2str(nbands)))

%adjust sign for the regions according to known microphone orientation
%x&y in Reg.1, y in reg 2
band = -1;
while band > nbands|band < 1
   band = round(str2num(input('Please enter the analysis band number','s')));
end
   
   
%Plane 1: unpack x,y,z components in each region
xp1r1 = -1*p1r1(band,:)';
yp1r1 = -1*p1r1(nbands+band,:)';
zp1r1 = p1r1(2*nbands+band,:)';
xp1r2 = 1*p1r2(band,:)';
yp1r2 = -1*p1r2(nbands+band,:)';
zp1r2 = p1r2(2*nbands+band,:)';
xp1r3 = p1r3(band,:)';
yp1r3 = p1r3(nbands+band,:)';
zp1r3 = p1r3(2*nbands+band,:)';

%Pack for call to stitch
D1 = [xp1r1 yp1r1 zp1r1];
D2 = [xp1r2 yp1r2 zp1r2];
D3 = [xp1r3 yp1r3 zp1r3];
[XYZp1, xblk1,yblk1] = stitch(D1,D2,D3,8,8,11,5); %Get composite data

%Plane 2
%xp2r1 = -1*p2r1(band,:)';
%yp2r1 = -1*p2r1(nbands+band,:)';
%zp2r1 = p2r1(2*nbands+band,:)';
%xp2r2 = 1*p2r2(band,:)';
%yp2r2 = -1*p2r2(nbands+band,:)';
%zp2r2 = p2r2(2*nbands+band,:)';
%xp2r3 = p2r3(band,:)';
%yp2r3 = p2r3(nbands+band,:)';
%zp2r3 = p2r3(2*nbands+band,:)';

%Pack for call to stitch
%D1 = [xp2r1 yp2r1 zp2r1];
%D2 = [xp2r2 yp2r2 zp2r2];
%D3 = [xp2r3 yp2r3 zp2r3];
%%D1= D1+5*ones(size(D1));D2= D2+5*ones(size(D2));
%[XYZp2, xblk2,yblk2] = stitch(D1,D2,D3,8,8,11,5);


for i = 1:size(XYZp1,3)
   XYZp1(:,:,i) = flipud(XYZp1(:,:,i));
%   XYZp2(:,:,i) = flipud(XYZp2(:,:,i));
end


%Pack for call to sivec2
style = input('Enter Plot type string: p(pcolor), q(quiver),c(contour),n(coneplot):','s');

xypos = [xmin ymin xblk1 yblk1 dx dy 0]';
%yzpos = [-56 0 xblk2 yblk2 dx dy 37.5]';

%cmin=min(min(min(abs(XYZp1)))); cmax=max(max(max(abs(XYZp1))));
h=figure;caxis([cmin cmax]);
%sivec3dev(threshold,style,usersel,XYZp1,xypos,XYZp2,yzpos)
%sivec3dev(threshold,style,usersel,[],[],XYZp2,yzpos)
sivec3dev(threshold,style,usersel,XYZp1,xypos)
hold on

Hpan = placepan([56,49,0],radius,skirtlength,bowldepth);
set(Hpan, 'EdgeColor','Cyan')

%set axis color same as figure color and adjust z-axis limits to accomodate pan
%if not done, the pan range can affect the color displayed
figcol = get(gcf,'Color');
h = gca;
ZLim = [get(h,'Zlim') ; [-1*radius radius]];
ZLim = [min(min(ZLim)) max(max(ZLim))];
%set(gca,'ZLim',ZLim,'Color',figcol);
set(gca,'ZLim',ZLim);
%zlabel('z Axis, cm')
%xlabel('x Axis, cm')
%ylabel('y Axis, cm')
ylabel('');xlabel('');zlabel('')
set(gca, 'Xtick',[],'YTick',[])% Do I really need the axiis marks?
axis off

%axis vis3d                     %freeze aspect ratio for rotation
hold off
%Use si3 to select files 
