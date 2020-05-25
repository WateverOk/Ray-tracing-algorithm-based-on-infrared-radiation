function [ y ] = cellstr2num( x )
[m,~]=size(x);
y=zeros(m,1);
for i=1:m
    y(i)=str2num(x{i});
end

