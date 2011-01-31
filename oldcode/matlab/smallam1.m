function [A00,A09,A18,A27,Ami,Apl,Ams]=smallam1(filename,lowmod,prenr,ismed,redfactor)
% function [A00,A09,A18,A27,Ami,Apl,Ams]=smallam1(filename,lowmod,prenr,ismed,redfactor)
%
% smallam1 reads the raw data files from RTI, PCH0L0. It checks for pixels with
% low modulation (threshold=lowmod) and replaces these pixels with the average of
% the neighboring pixels. If prenr is nonzero median or convolution filtering is
% performed prenr times. ismed=l for median filtering, 0 for convolution. If redfactor is
% nonzero, the data matrices are reduce with a factor redfactor.

tic

i=length(filename);
while filename(i)~='.',

i=i-1;

end

strtemp=filename(1:i-3);

strtmp=[strtemp,'00',filename(i:length(filename))];
A00=getdata(strtmp);
strtmp=[strtemp,'09',filename(i:length(filename))];
A09=getdata(strtmp);
strtmp=[strtemp,'18',filename(i:length(filename))];
A18=getdata(strtmp);
strtmp=[strtemp,'27',filename(i:length(filename))];
A27=getdata(strtmp);
strtmp=[strtemp,'MI',filename(i:length(filename))];
Ami=getdata (strtmp) ;
strtmp=[strtemp,'PL',filename(i:length(filename))];
Apl=getdata(strtmp);
strtmp=[strtemp,'MS','.DIM'];
Ams=getdata(strtmp);

lownr=0;

for i=2:479
 for j=2:511
        if Ams(i,j)>0

        if A00(i,j)<=lowmod
         A00(i,j)=mean(mean(A00(i-1:i+1,j-1:j+1)));
         lownr=lownr+1;
        end

        if A09(i,j)<=lowmod
         A09(i,j)=mean(mean(A09(i-1:i+1,j-1:j+1)));
         lownr=lownr+1;
        end

        if A18(i,j)<=lowmod
         A18(i,j)=mean(mean(A18(i-1:i+1,j-1:j+1)));
         lownr=lownr+1;
        end

        if A27(i,j)<=lowmod
         A27(i,j)=mean(mean(A27(i-1:i+1,j-1:j+1)));
         lownr=lownr+1;
        end

        if Ami(i,j)<=lowmod
         Ami(i,j)=mean(mean(Ami(i-1:i+1,j-1:j+1)));
         lownr=lownr+1;
        end

        if Apl(i,j)<=lowmod
         Apl(i,j)=mean(mean(Apl(i-1:i+1,j-1:j+1)));
         lownr=lownr+1;
        end
        end
 end
end

lownr

if prenr>0
        if ismed==1
        for i=l:prenr

A00=median2(A00,Ams);
A09=median2(A09,Ams);
A18=median2(A18,Ams);
A27=median2(A27,Ams);
Ami=median2 (Ami, Ams );
Apl=median2 (Apl, Ams );

end
else
for i=1:prenr

A00=conv2(A00,ones(3),'same')/9;
A09=conv2(A09,ones(3),'same')/9;
A18=conv2(A18,ones(3),'same')/9;
A27=conv2(A27,ones(3),'same')/9;
Ami=conv2(Ami,ones(3),'same')/9;
Apl=conv2(Apl,ones(3),'same')/9;


end
end
end


if redfactor>0


A00=reduce(A00,redfactor);
A09=reduce(A09,redfactor);
A18=reduce(A18,redfactor);
A27=reduce(A27,redfactor);
Apl=reduce(Apl,redfactor);
Ami=reduce(Ami,redfactor);
Ams=reduce(Ams,redfactor);

end

[m,n]=size(Ams);
for i=1:m
for j=1:n


if Ams(i,j)>=0.5
Ams (i, j)=1;
else

Ams (i, j)=0;
end

end
end
toc
