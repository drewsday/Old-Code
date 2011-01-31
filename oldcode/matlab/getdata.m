function B=getdata(filename)

% function B=getdata(filename)
% getdata stores an image (8 or 16-bit) from RTI, PCHOLO, in B and
% displays the header (256 bytes). Matris B is rotated -90 degrees
% and flipped left to right. This gives the right image when viewed
% with image or imagese.

fid=fopen(filename,'r');
A=fread (fid,256,'uchar');
if A(9)==16
 B=fread (fid, [512,480],' ushort ');
elseif A(9)==8
 B=fread(fid, [512,480],'uchar');
end
fclose(fid);

disp(setstr(A(1:4)'))
disp(setstr(A(5:8)'))
disp(['Data size = ',num2str(A(9))])
disp(['AOI   =     ',num2str(A(17)+256*A(18)),'   ',num2str(A(19)+256*A(20)),' ',num2str(A(21)+256*A(22)),' ',num2str(A(23)+256*A(24))])
disp(['Data offset = ',num2str(A(29)+256*A(30)+256^2*A(31)+256^3*A(32))])
disp(['Comment: ',setstr(A(33:112)')])

B=fliplr(rot90(B,3));
