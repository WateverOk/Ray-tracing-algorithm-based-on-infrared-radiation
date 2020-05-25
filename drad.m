function [ index , theta ] = drad( vertex_Triangle , Downward_radiation_direction )
[m,~] = size(Downward_radiation_direction);
index = randperm(m,1);
theta = acos(dot(vertex_Triangle,Downward_radiation_direction(index,:))/(norm(vertex_Triangle)*norm(Downward_radiation_direction(index,:))));
a = 0;
while(theta < 0 || theta > pi/2 ||a > m)
    a = a+1;
    index = randperm(m,1);
    theta = acos(dot(vertex_Triangle,Downward_radiation_direction(index,:))/(norm(vertex_Triangle)*norm(Downward_radiation_direction(index,:))));
end
if(a > m)
    index =  0;
end
end

