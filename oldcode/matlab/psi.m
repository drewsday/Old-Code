psi11 = ones(201,201);
psi12 = ones(201,201);
psi21 = ones(201,201);
psi22 = ones(201,201);


for i = 1:201
for j=1:201
psi11(i,j)=cos((1*pi*x(i))/(2*1))*cos((1*pi*y(j))/(2*1));
psi21(i,j)=sin((2*pi*x(i))/(2*1))*cos((1*pi*y(j))/(2*1));
psi12(i,j)=cos((1*pi*x(i))/(2*1))*sin((2*pi*y(j))/(2*1));
psi22(i,j)=sin((2*pi*x(i))/(2*1))*sin((2*pi*y(j))/(2*1));
end
end
