function pos = getpointsXYZ(input_file_name,Center_xyz1,Center_xyz2,Center_xyz3,node_xyz,face_node,AZ,EL)
global i_i_i col_file col_back_file val1 vertex_node_xyz_sum vertex_node
data1=Center_xyz1;
data2=Center_xyz2;
data3=Center_xyz3;
n=1;
hold on
%hFigure= figure;
scatter3(data1(:,1),data1(:,2),data1(:,3),3,'.','black')
scatter3(data2(:,1),data2(:,2),data2(:,3),3,'.','black')
scatter3(data3(:,1),data3(:,2),data3(:,3),3,'.','black')
colormap('jet');
% colorbar('southoutside')
axis equal; 
grid on;
    
xlabel ( '--X axis--' )
ylabel ( '--Y axis--' )
zlabel ( '--Z axis--' )
title_string = s_escape_tex ( input_file_name );
title ( title_string )
handle = patch ( 'Vertices', node_xyz', 'Faces', face_node','FaceVertexCData',col_file{val1}(:,i_i_i),'FaceColor','flat' );
% handle = patch ( 'Vertices', vertex_node_xyz_sum', 'Faces', vertex_node','FaceVertexCData',col_back_file{val1}(:,i_i_i),'FaceColor','flat' );
set ( handle, 'EdgeColor', 'Black' );
colormap('jet');
colorbar('southoutside')
view(AZ,EL);
%
%  The TITLE function will interpret underscores in the title.
%  We need to unescape such escape sequences!
%  
hFigure=gcf;
%atacursormode on % 在当前图窗上启用数据游标模式
datacursormode on;
dcm_obj = datacursormode(hFigure);

pos = zeros(n,3);
for i = 1:n
    disp('Click line to display a data tip, then press Return.')
    %Wait while the user does this.
    pause 
    c_info = getCursorInfo(dcm_obj);
    pos(i,:) = c_info.Position;
end
end

