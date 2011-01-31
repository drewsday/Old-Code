function A=median2(x,M)
% function A=median2 (X,M) or A=median2(X)
% 2-dim. median filter on any size matrices X(min 2 by 2). Element A(i,j) is the
% median value of the surrounding elements in a 3 by 3 matrix. Edges and corners
% are median values of neighbor element s in matrix.  Uses ma s k,  M,  if it exists.

narg=nargin;

[m,n]=size(x);
if narg==2
        [Mm,Mn]=size(M) ;

        if ~(Mm==m & Mn==n)
                narg=1;
        end
end
 
for i=2:m-1
        for j=2:n-1
 
        if narg==2
                if M(i,j)>=1
                        A(i,j)=median([x(i-1, j-1:j+1),x(i,j-1:j+1),x(i+1,j-1:j+1)]);
                else
                        A(i,j)=x(i,j);
                end
        else
                A(i,j)=median([x(i-1,j-1:j+1),x(i,j-1:j+1),x(i+1,j-1:j+1)]);
        end
        end
end
for i=2:m-1
        A(i,j)=median([x(i-1,j:j+1),x(i,j:j+1),x(i+1,j:j+1)]);
end
j=n;
for i=2:m-1
        A(i,j)=median([x(i-1,j-1:j),x(i,j-1:j),x(i+1,j-1:j)]);
end
i=1;
for j=2:n-1
        A(i,j)=median([x(i,j-1:j+1),x(i+1,j-1:j+1)]);
end
 
i =m;
for j=2:n-1
 
A(i,j)=median([x(i-1,j-1:j+1),x(i,j-1:j+1)]);
 
end
 
A(1,1)=median([x(1,1:2),x(2,1:2)]); 
A(m,1)=median([x(m-1,1:2),x(m,1:2)]); 
A(1,n)=median([x(1,n-1:n),x(2,n-1:n)]); 
A(m,n)=median([x(m-1,n-1:n),x(m,n-1:n)]);
