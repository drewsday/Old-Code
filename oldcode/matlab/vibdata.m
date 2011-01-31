function [result, Pout, disp] = vibdata(filename,max,min,maxrange,graphtitle)
% process Holovibe datasets
result = dlmread(filename,' ');
Pout = result.*(max-min)/255+min;
disp = Pout./512;
figure
plot(disp(17:maxrange,8),'.')
title(graphtitle)