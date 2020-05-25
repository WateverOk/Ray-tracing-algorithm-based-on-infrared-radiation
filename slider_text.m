function slider_text
global node_xyz Sliderstep face_node Center_xyz1 Center_xyz2 Center_xyz3 input_file_name AZ EL i_i_i...
         face_num index vertex_node vertex_node_xyz_sum...
         col_file col_back_file context_xlsx_file ex_data_sum val1 vertex_Center_xyz1...
         vertex_Center_xyz2 lookfrom lookat h h_edit3 h_edit5 
MainFigure=gcf;
[~,n]=size(col_file{1});
x=rem(n/Sliderstep,1);
while (x~=0)
    fprintf ( 1, '\n' );
    fprintf ( 1, '步长设置不合理:\n' );
    Sliderstep = input ( 'Enter the step:' );
    x=rem(n/Sliderstep,1);
end
step=[Sliderstep/n 1];
edit1=uicontrol('style','edit','parent',MainFigure,'position',[125 390 50 20],'callback',@edit1_callback);
edit2=uicontrol('style','edit','parent',MainFigure,'position',[30 190 50 20],'callback',@edit2_callback);
edit3=uicontrol('style','edit','parent',MainFigure,'position',[90 190 50 20],'callback',@edit3_callback);
edit4=uicontrol('style','edit','parent',MainFigure,'position',[30 160 50 20],'callback',@edit4_callback);
edit5=uicontrol('style','edit','parent',MainFigure,'position',[90 160 50 20],'callback',@edit5_callback);
slider1=uicontrol('style','slider','parent',MainFigure,'position',[15 390 100 20],'callback',@slider1_callback,'Value',1,'Max',n,'Min',1,'Sliderstep',step);
button1=uicontrol('style','pushbutton','parent',MainFigure,'position',[20 5 60 20],'string','开始','callback',@plotButtonPushed);
button2=uicontrol('style','pushbutton','parent',MainFigure,'position',[30 130 50 20],'string','视线','callback',@plotButtonPushed2);
button3=uicontrol('style','pushbutton','parent',MainFigure,'position',[90 130 50 20],'string','仿真','callback',@plotButtonPushed3);
popupmenu1=uicontrol('style','popupmenu','parent',MainFigure,'position',[480 392 60 20],'string',ex_data_sum,'callback',@popupmenu1_callback);
edit1.Units='normalized';
edit2.Units='normalized';
edit2.String='lookfrom';
edit3.Units='normalized';
edit4.Units='normalized';
edit4.String='lookat';
edit5.Units='normalized';
slider1.Units='normalized';
button1.Units='normalized';
button2.Units='normalized';
button3.Units='normalized';
popupmenu1.Units='normalized';
function slider1_callback(hObject,event)
% set(edit1,'string',num2str(get(hObject,'value')))
sliderValue = get(hObject,'Value');
i_i_i = ceil(sliderValue);
set(edit1,'string',num2str(i_i_i));
while(1)
      iscenter=0;
      iscenter_back=0;
      face_Serial_number=0; % 选中的面片序号 
      face_Serial_number_back=0;
      [AZ,EL] = view;
      pos = getpointsXYZ(input_file_name,Center_xyz1,Center_xyz2,Center_xyz3,node_xyz,face_node,AZ,EL); % 获取坐标
      for i=1:face_num
          if (isequal(pos,Center_xyz1(i,:)))
              iscenter=1;
              face_Serial_number=i;
              break;
          elseif (isequal(pos,Center_xyz2(i,:)))
              iscenter=1;
              face_Serial_number=i;
              break;
          elseif (isequal(pos,Center_xyz3(i,:)))
              iscenter=1;
              face_Serial_number=i;
              break;
          elseif (isequal(pos,vertex_Center_xyz1(i,:)))
              iscenter_back=1;
              face_Serial_number_back=i;
              break;
          elseif (isequal(pos,vertex_Center_xyz2(i,:)))
              iscenter_back=1;
              face_Serial_number_back=i;
              break;
          end
      end
      X=[];Y=[];Z=[];X_back=[];Y_back=[];Z_back=[];
      if(iscenter==1)
          % 导出面片信息(front)
          fprintf ( 1, '  选中的是(front)中心点.\n' );
          [~,n_index]=size(index{face_Serial_number});
          for i1=1:n_index
              mat=cell2mat(index{face_Serial_number});
              fprintf ( 1, '  %s''s %s is %d(%s) :\n', ...
                              cell2mat(context_xlsx_file{val1}(1,mat(i1))),...
                              ex_data_sum{val1},...
                              cell2mat(context_xlsx_file{val1}(i_i_i+2,mat(i1))),...
                              cell2mat(context_xlsx_file{val1}(2,mat(i1))));
          end
            face_node_chose=face_node(:,face_Serial_number);
            for i_i=1:4
                X=[X node_xyz(1,face_node_chose(i_i))];
                Y=[Y node_xyz(2,face_node_chose(i_i))];
                Z=[Z node_xyz(3,face_node_chose(i_i))];
            end
            [~,n_edit]=size(index{face_Serial_number});
            MainFigure=gcf;
            Position1=MainFigure.Position(3)/560;
            Position2=MainFigure.Position(4)/420;
            for i_edit=1:n_edit
                % 标识显示框
                edit_1{i_edit}=uicontrol('style','edit','position',[465*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
                edit_1{i_edit}.Units='normalized';
                edit_1{i_edit}.String=cell2mat(context_xlsx_file{val1}(2,mat(i_edit)));
                % 数据显示框
                edit_2{i_edit}=uicontrol('style','edit','position',[515*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
                edit_2{i_edit}.Units='normalized';
                edit_2{i_edit}.String=cell2mat(context_xlsx_file{val1}(i_i_i+2,mat(i_edit)));
            end
            edit_3=uicontrol('style','edit','position',[250*Position1 5 60*Position1 20*Position2],'parent',MainFigure);
            edit_3.Units='normalized';
            edit_3.String=cell2mat(context_xlsx_file{val1}(1,mat(i_edit)));
            fill3(X,Y,Z,'m')
            pause
            for i_edit=1:n_edit
                % 标识显示框
                edit_1{i_edit}.Visible='off';
                % 数据显示框
                edit_2{i_edit}.Visible='off';
            end
            edit_3.Visible='off';
      elseif(iscenter_back==1)
          % 导出面片信息(front)
          fprintf ( 1, '  选中的是(back)中心点.\n' );
          [~,n_index_back]=size(index{face_Serial_number_back});
          for i1_back=sort(1:n_index_back,'descend')
              mat_back=cell2mat(index{face_Serial_number_back});
              fprintf ( 1, '  %s''s %s is %d(%s) :\n', ...
                              cell2mat(context_xlsx_file{val1}(1,mat_back(i1_back))),...
                              ex_data_sum{val1},...
                              cell2mat(context_xlsx_file{val1}(i_i_i+2,mat_back(i1_back))),...
                              cell2mat(context_xlsx_file{val1}(2,mat_back(i1_back))));
          end
          face_node_chose_back=vertex_node(:,face_Serial_number_back);
          for i_i_back=1:4
              X_back=[X_back vertex_node_xyz_sum(1,face_node_chose_back(i_i_back))];
              Y_back=[Y_back vertex_node_xyz_sum(2,face_node_chose_back(i_i_back))];
              Z_back=[Z_back vertex_node_xyz_sum(3,face_node_chose_back(i_i_back))];
          end
          [~,n_edit_back]=size(index{face_Serial_number_back});
          MainFigure=gcf;
          Position1=MainFigure.Position(3)/560;
          Position2=MainFigure.Position(4)/420;
          for i_edit=1:n_edit_back
              i_edit_back=sort(1:n_edit_back,'descend');
              % 标识显示框
              edit_1{i_edit}=uicontrol('style','edit','position',[465*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
              edit_1{i_edit}.Units='normalized';
              edit_1{i_edit}.String=cell2mat(context_xlsx_file{val1}(2,mat_back(i_edit_back(i_edit))));
              % 数据显示框
              edit_2{i_edit}=uicontrol('style','edit','position',[515*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
              edit_2{i_edit}.Units='normalized';
              edit_2{i_edit}.String=cell2mat(context_xlsx_file{val1}(i_i_i+2,mat_back(i_edit_back(i_edit))));
          end
          edit_3=uicontrol('style','edit','position',[250*Position1 5 60*Position1 20*Position2],'parent',MainFigure);
          edit_3.Units='normalized';
          edit_3.String=cell2mat(context_xlsx_file{val1}(1,mat_back(i_edit_back(i_edit))));
          fill3(X_back,Y_back,Z_back,'m')
          pause
          for i_edit=1:n_edit
              % 标识显示框
              edit_1{i_edit}.Visible='off';
              % 数据显示框
              edit_2{i_edit}.Visible='off';
          end
          edit_3.Visible='off';
      end
end
end
function edit1_callback(hObject,event)
    set(slider1,'value',str2num(get(hObject,'string')))
end
function edit3_callback(hObject,event)
    delete(h_edit3)
    lookfrom=get(hObject,'string');
    lookfrom=str2num(lookfrom);
    x1=lookfrom(1);y1=lookfrom(2);z1=lookfrom(3);
    h_edit3=plot3(x1,y1,z1,'ro');
    disp('lookfrom点绘制结束')
end
function edit5_callback(hObject,event)
    delete(h_edit5)
    lookat=get(hObject,'string');
    lookat=str2num(lookat);
    x1=lookat(1);y1=lookat(2);z1=lookat(3);
    h_edit5=plot3(x1,y1,z1,'go');
    disp('lookat点绘制结束')
end
function popupmenu1_callback(hObject,event)
% list=get(hObject,'String');
val1=get(hObject,'Value');
while(1)
      iscenter=0;
      iscenter_back=0;
      face_Serial_number=0; % 选中的面片序号 
      face_Serial_number_back=0;
      [AZ,EL] = view;
      pos = getpointsXYZ(input_file_name,Center_xyz1,Center_xyz2,Center_xyz3,node_xyz,face_node,AZ,EL); % 获取坐标
      for i=1:face_num
          if (isequal(pos,Center_xyz1(i,:)))
              iscenter=1;
              face_Serial_number=i;
              break;
          elseif (isequal(pos,Center_xyz2(i,:)))
              iscenter=1;
              face_Serial_number=i;
              break;
          elseif (isequal(pos,Center_xyz3(i,:)))
              iscenter=1;
              face_Serial_number=i;
              break;
          elseif (isequal(pos,vertex_Center_xyz1(i,:)))
              iscenter_back=1;
              face_Serial_number_back=i;
              break;
          elseif (isequal(pos,vertex_Center_xyz2(i,:)))
              iscenter_back=1;
              face_Serial_number_back=i;
              break;
          end
      end
      X=[];Y=[];Z=[];X_back=[];Y_back=[];Z_back=[];
      if(iscenter==1)
          % 导出面片信息(front)
          fprintf ( 1, '  选中的是(front)中心点.\n' );
          [~,n_index]=size(index{face_Serial_number});
          for i1=1:n_index
              mat=cell2mat(index{face_Serial_number});
              fprintf ( 1, '  %s''s %s is %d(%s) :\n', ...
                              cell2mat(context_xlsx_file{val1}(1,mat(i1))),...
                              ex_data_sum{val1},...
                              cell2mat(context_xlsx_file{val1}(i_i_i+2,mat(i1))),...
                              cell2mat(context_xlsx_file{val1}(2,mat(i1))));
          end
            face_node_chose=face_node(:,face_Serial_number);
            for i_i=1:4
                X=[X node_xyz(1,face_node_chose(i_i))];
                Y=[Y node_xyz(2,face_node_chose(i_i))];
                Z=[Z node_xyz(3,face_node_chose(i_i))];
            end
            [~,n_edit]=size(index{face_Serial_number});
            MainFigure=gcf;
            Position1=MainFigure.Position(3)/560;
            Position2=MainFigure.Position(4)/420;
            for i_edit=1:n_edit
                % 标识显示框
                edit_1{i_edit}=uicontrol('style','edit','position',[465*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
                edit_1{i_edit}.Units='normalized';
                edit_1{i_edit}.String=cell2mat(context_xlsx_file{val1}(2,mat(i_edit)));
                % 数据显示框
                edit_2{i_edit}=uicontrol('style','edit','position',[515*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
                edit_2{i_edit}.Units='normalized';
                edit_2{i_edit}.String=cell2mat(context_xlsx_file{val1}(i_i_i+2,mat(i_edit)));
            end
            edit_3=uicontrol('style','edit','position',[250*Position1 5 60*Position1 20*Position2],'parent',MainFigure);
            edit_3.Units='normalized';
            edit_3.String=cell2mat(context_xlsx_file{val1}(1,mat(i_edit)));
            fill3(X,Y,Z,'m')
            pause
            for i_edit=1:n_edit
                % 标识显示框
                edit_1{i_edit}.Visible='off';
                % 数据显示框
                edit_2{i_edit}.Visible='off';
            end
            edit_3.Visible='off';
      elseif(iscenter_back==1)
          % 导出面片信息(front)
          fprintf ( 1, '  选中的是(back)中心点.\n' );
          [~,n_index_back]=size(index{face_Serial_number_back});
          for i1_back=sort(1:n_index_back,'descend')
              mat_back=cell2mat(index{face_Serial_number_back});
              fprintf ( 1, '  %s''s %s is %d(%s) :\n', ...
                              cell2mat(context_xlsx_file{val1}(1,mat_back(i1_back))),...
                              ex_data_sum{val1},...
                              cell2mat(context_xlsx_file{val1}(i_i_i+2,mat_back(i1_back))),...
                              cell2mat(context_xlsx_file{val1}(2,mat_back(i1_back))));
          end
          face_node_chose_back=vertex_node(:,face_Serial_number_back);
          for i_i_back=1:4
              X_back=[X_back vertex_node_xyz_sum(1,face_node_chose_back(i_i_back))];
              Y_back=[Y_back vertex_node_xyz_sum(2,face_node_chose_back(i_i_back))];
              Z_back=[Z_back vertex_node_xyz_sum(3,face_node_chose_back(i_i_back))];
          end
          [~,n_edit_back]=size(index{face_Serial_number_back});
          MainFigure=gcf;
          Position1=MainFigure.Position(3)/560;
          Position2=MainFigure.Position(4)/420;
          for i_edit=1:n_edit_back
              i_edit_back=sort(1:n_edit_back,'descend');
              % 标识显示框
              edit_1{i_edit}=uicontrol('style','edit','position',[465*Position1 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
              edit_1{i_edit}.Units='normalized';
              edit_1{i_edit}.String=cell2mat(context_xlsx_file{val1}(2,mat_back(i_edit_back(i_edit))));
              % 数据显示框
              edit_2{i_edit}=uicontrol('style','edit','position',[515*Position2 (360-(i_edit*40))*Position2 40*Position1 20*Position2],'parent',MainFigure);
              edit_2{i_edit}.Units='normalized';
              edit_2{i_edit}.String=cell2mat(context_xlsx_file{val1}(i_i_i+2,mat_back(i_edit_back(i_edit))));
          end
          edit_3=uicontrol('style','edit','position',[250*Position1 5 60*Position1 20*Position2],'parent',MainFigure);
          edit_3.Units='normalized';
          edit_3.String=cell2mat(context_xlsx_file{val1}(1,mat_back(i_edit_back(i_edit))));
          fill3(X_back,Y_back,Z_back,'m')
          pause
          for i_edit=1:n_edit
              % 标识显示框
              edit_1{i_edit}.Visible='off';
              % 数据显示框
              edit_2{i_edit}.Visible='off';
          end
          edit_3.Visible='off';
      end
end
end
function plotButtonPushed(src,event)
% global node_xyz  face_node col Center_xyz input_file_name i_i_i 
view(3)
data1=Center_xyz1;
data2=Center_xyz2;
data3=Center_xyz3;
%hFigure= figure;
scatter3(data1(:,1),data1(:,2),data1(:,3),3,'.','black')
scatter3(data2(:,1),data2(:,2),data2(:,3),3,'.','black')
scatter3(data3(:,1),data3(:,2),data3(:,3),3,'.','black')
hold on
[~,n1]=size(col_file{val1});
if (i_i_i==n1)
    i_i_i=1;
end
colormap('jet');
colorbar('southoutside')
axis equal; 
grid on;
    
xlabel ( '--X axis--' )
ylabel ( '--Y axis--' )
zlabel ( '--Z axis--' )
title_string = s_escape_tex ( input_file_name );
title ( title_string )
for i_i_i=i_i_i:n1
    set(edit1,'string',num2str(i_i_i))
    set(slider1,'value',i_i_i)
    handle = patch ( 'Vertices', node_xyz', 'Faces', face_node','FaceVertexCData',col_file{val1}(:,i_i_i),'FaceColor','flat' );
    handle = patch ( 'Vertices', vertex_node_xyz_sum', 'Faces', vertex_node','FaceVertexCData',col_back_file{val1}(:,i_i_i),'FaceColor','flat' );
    set ( handle, 'EdgeColor', 'Black' );
    colormap('jet');
    colorbar('southoutside')
%     % 按面平移坐标点，其平移方向与法线方向相同
%     % vertex_node_xyz=zeros(size(node_xyz));
%     vertex_Center_xyz1=[];vertex_Center_xyz2=[];
%     [m_node,n_node]=size(face_node);
%     for i_node=1:n_node
%         for j_node=1:m_node
%             vertex_node_xyz(:,j_node)=node_xyz(:,face_node(j_node,i_node))-0.25*face_vertex(:,i_node); % 逆着法向量的方向
%         end
%         X_node1=sum(vertex_node_xyz(1,1:3))/3;X_node2=sum(vertex_node_xyz(1,end-2:end))/3;
%         Y_node1=sum(vertex_node_xyz(2,1:3))/3;Y_node2=sum(vertex_node_xyz(2,end-2:end))/3;
%         Z_node1=sum(vertex_node_xyz(3,1:3))/3;Z_node2=sum(vertex_node_xyz(3,end-2:end))/3;
%         %确定背面片的点，共两个
%         vertex_Center_xyz1=[vertex_Center_xyz1;X_node1,Y_node1,Z_node1];
%         vertex_Center_xyz2=[vertex_Center_xyz2;X_node2,Y_node2,Z_node2];
%         hold on
%         scatter3(vertex_Center_xyz1(:,1),vertex_Center_xyz1(:,2),vertex_Center_xyz1(:,3),3,'.','black')
%         scatter3(vertex_Center_xyz2(:,1),vertex_Center_xyz2(:,2),vertex_Center_xyz2(:,3),3,'.','black')
%         handle = patch ( 'Vertices', vertex_node_xyz', 'Faces', 1:m_node,'FaceVertexCData',col_back(i_node,i_i_i),'FaceColor','flat' );
%         set ( handle, 'EdgeColor', 'Black' );
%         colormap('jet');
%         colorbar('southoutside')
%     end
    pause(0.5)
end
end
function plotButtonPushed2(src,event)
    delete(h)
    x=lookfrom(1);y=lookfrom(2);z=lookfrom(3);
    u=lookat(1)-lookfrom(1);v=lookat(2)-lookfrom(2);w=lookat(3)-lookfrom(3);
    h=quiver3(x,y,z,u,v,w);
    disp('视线绘制结束')
end
function plotButtonPushed3(src,event)
    Ray_tracing_function( input_file_name )
end
end