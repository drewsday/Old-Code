
function S = phys410(N)


for j = 14:N
    n = 2^N;

a = 0;
b = 1;

delx = (b-a)/n;

S(1) = 0.5*delx*((2/sqrt(pi)*exp(-a^2)) + (2/sqrt(pi)*exp(-b^2)));

for i = 2:n
    
    S(i) = S(i-1) + delx*((2/sqrt(pi)*exp(-(i*delx)^2)));
end

n
S(n)
end
