function A=reduce(X,width)

% function A=reduce(X,width)
% reduce converts the matrix X with size m*n to the matrix A, by dividing
% the matrix X into matrices of size width*width. The width"width pixels
% are averaged and the value is the pixel value of the corresponding pixel
% of matrix A. If (m,n) modulo width does not equal (0,0), the remaining
% pixels are grouped with hight or with width and then averaged to form a
% pixel in A. The size of A is displayed. 

[m, n]=size(X);

for i=1:floor(m/width)
   for j=1:floor(n/width)
            A(i,j)=mean(mean(X(1+(i-1)*width:i*width, 1+(j-1)*width:j*width)));
   end
end

if (m-floor(m/width)*width)>0
        for j=1:floor(n/width)

        A(floor(m/width)+1,j)=mean(mean(X(1+floor(m/width)*width:m,1+(j-1)*width:j*width)));
end

if (n-floor(n/width)*width)>0



A(floor(m/width)+1,floor(n/width)+1)=mean(mean(X(1+floor(m/width)*width:m,1+floor(n/width)*width:n)));
        end
end
if (n-floor(n/width)*width)>0
        for i=1:floor(m/width)
        A(i, floor (n/width)+1)=mean(mean(X(1+(i-1)*width:i*width,1+floor(n/width)*width:n)));
end
end
redsize=size(A)
