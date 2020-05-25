clear global node_xyz face_order face_node Center_xyz1 Center_xyz2 Center_xyz3 input_file_name AZ EL i_i_i...
       face_num Sliderstep  index face_vertex vertex_node...
       vertex_node_xyz_sum col_file col_back_file context_xlsx_file ex_data_sum val1 vertex_Center_xyz1...
       vertex_Center_xyz2
clear;clc;
timestamp ( );
global node_xyz face_order face_node Center_xyz1 Center_xyz2 Center_xyz3 input_file_name AZ EL i_i_i...
       face_num Sliderstep index face_vertex vertex_node...
       vertex_node_xyz_sum col_file col_back_file context_xlsx_file ex_data_sum val1 vertex_Center_xyz1...
       vertex_Center_xyz2
export_data={'Temperature (癈)','Conduction - Incident Heat Rate (W)',...
             'Conduction - Outgoing Heat Rate (W)','Conduction - Net Heat Rate (W)',...
             'Convection - Incident Heat Rate (W)','Convection - Outgoing Heat Rate (W)',...
             'Convection - Net Heat Rate (W)','Convection - Incident Heat Rate Flux (W/m?',...
             'Convection - Outgoing Heat Rate Flux (W/m?','Convection - Net Heat Rate Flux (W/m?',...
             'Radiation - Incident Heat Rate (W)','Radiation - Outgoing Heat Rate (W)',...
             'Radiation - Net Heat Rate (W)','Radiation - Incident Heat Rate Flux (W/m?',...
             'Radiation - Outgoing Heat Rate Flux (W/m?','Radiation - Net Heat Rate Flux (W/m?',...
             'Solar - Net Heat Rate (W)','Solar - Net Heat Rate Flux (W/m?','Imposed - Net Heat Rate (W)',...
             'Imposed - Net Heat Rate Flux (W/m?'};
a='C:\Users\dell\Desktop\科创计划\实验过程文件\';
b='C:\Users\dell\Desktop\科创计划\实验过程生成文件\';
c=0;
val1=1;
f=1; % 计数
sign=0;
fir_sign=1;
sec_sign=1;
fileWrite_sum=[];
ex_data_sum=[];
files = dir('C:\Users\dell\Desktop\科创计划\实验过程文件\*.csv');   % 读取生成的CSV名称
fileNumber = length(files);
for i = 1 : fileNumber
    fileName = [a files(i).name];   % 文件名，带路径
    [~, ~, context] = xlsread(fileName);  % 全部读取，不分数字和文本
    context(1:9,:)=[]; % 删除注释信息
    First_column=length(context(:,1));
    export=length(export_data);
    for j=1:First_column
        for m=1:export
            if isequal(export_data{m},context{j,1})
                fir_sign=sec_sign;
                sec_sign=j;
                sign=sign+1;
                break;
            end
        end
        if sign==2
            ex_data=context{fir_sign,1};          %按种类导出数据
            ex_data_sum{f}=ex_data;
            fileWrite=[b ex_data(1:end-3) '_' files(i).name];
            fileWrite_sum{f}=[fileWrite(1:end - 3), 'xlsx'];
            f=f+1;
            xlswrite([fileWrite(1:end - 3), 'xlsx'], context(fir_sign:sec_sign-1,:)); % 去掉原始后缀，改为xlsx后缀
            sign=1;
        end
        if j==First_column       % 导出最后一组数据
            ex_data=context{sec_sign,1};
            ex_data_sum{f}=ex_data;
            fileWrite=[b ex_data(1:end-3) '_' files(i).name];
            fileWrite_sum{f}=[fileWrite(1:end - 3), 'xlsx'];
            xlswrite([fileWrite(1:end - 3), 'xlsx'], context(sec_sign:end,:)); % 去掉原始后缀，改为xlsx后缀
            sign=1;
        end
    end
end
%   [num, txt, context] = xlsread(fileName);  % 全部读取，不分数字和文本
% col
[~,n_file]=size(fileWrite_sum);
col_file={};
col_back_file={};
context_xlsx_file={};
for i_file=1:n_file
    file_chose=fileWrite_sum{i_file};
    [~, ~, context_xlsx] = xlsread(file_chose);  % 全部读取，不分数字和文本
    context_xlsx(1:2,:)=[];
    context_xlsx(:,1:2)=[]; 
    [~,n_xlsx]=size(context_xlsx);
    if (n_xlsx==16382)
        [ index,col_file,col_back_file,context_xlsx_file ] = Direct_read( fileName );
    else
        for i_xlsx=1:n_xlsx
            word_xlsx=context_xlsx{1,i_xlsx};
            [~,n_word]=size(word_xlsx);
            if n_word<4||s_eqi ( word_xlsx(1:4), 'Elem' )==0;
                context_xlsx(:,i_xlsx:end)=[]; % 删除空间区域信息
                break;
            end
        end
        % 剔选数据，得到两个矩阵
        past_xlsx=0; % 记录上一个目标位置
        past_xlsx_back=0;
        now_xlsx=0;  % 记录当前目标位置
        now_xlsx_back=0;
        d=0;d_back=0;
        index={}; % 面片索引
        index_back={};
        [m_xlsx,n_xlsx]=size(context_xlsx);
        for i_i_xlsx=1:n_xlsx
            word2_xlsx=context_xlsx{2,i_i_xlsx};
            if s_eqi ( word2_xlsx, '(front)' )==1
                d=d+1;
                col(d,:)=cell2mat(context_xlsx(3:end,i_i_xlsx)); % 面片温度
                past_xlsx=now_xlsx;
                now_xlsx=i_i_xlsx;
                if (past_xlsx==0 && now_xlsx-1==0)
                else
                    index{d-1}={past_xlsx,now_xlsx-1};
                end
            elseif s_eqi ( word2_xlsx, '(back)' )==1
                d_back=d_back+1;
                col_back(d_back,:)=cell2mat(context_xlsx(3:end,i_i_xlsx)); % 面片温度
            end
        end
        % 记录上最后一列的索引
        index{d}={now_xlsx,n_xlsx};
        col_file{i_file}=col;
        col_back_file{i_file}=col_back;
        context_xlsx_file{i_file}=context_xlsx;
    end
end
disp('文件信息读取完毕！')
 % OBJ文件读取和处理
 
  i_i_i=1;
  Sliderstep=1; % 输出结果步长，可自主设置
  input_file_name='houseobj.obj';
  fprintf ( 1, '\n' );
  fprintf ( 1, '  OBJ_DISPLAY\n' );
  fprintf ( 1, '  MATLAB version\n' );
  fprintf ( 1, '\n' );
  fprintf ( 1, '  Reads an object in an ASCII OBJ file.\n' );
  fprintf ( 1, '  Display it as a MATLAB shape.\n' );
  %没啥太大用处
%
%  Get sizes.
%  order_max是用来记录一个面片最多由几个顶点组成
%   [ node_num, face_num, normal_num, order_max ] = obj_size ( input_file_name );
[ node_num, face_num, normal_num, order_max, group_num] = obj_size ( input_file_name );
%  Print the sizes.
%
%   obj_size_print ( input_file_name, node_num, face_num, normal_num, order_max );
obj_size_print ( input_file_name, node_num, face_num, normal_num, order_max, group_num );
%
%  Get the data.
%  读取了点坐标、法向量坐标和其对应的面索引的信息
%   [ node_xyz, face_order, face_node, normal_vector, vertex_normal ] = ...
%     obj_read ( input_file_name, node_num, face_num, normal_num, order_max );
  [ node_xyz, face_order, face_node, normal_vector, vertex_normal, group ] = ...
    obj_read ( input_file_name, node_num, face_num, normal_num, order_max, group_num );
%  计算并存储每个面中心点的坐标位置
[Center_xyz1,Center_xyz2,Center_xyz3]  = Geometric_center_point( node_xyz,face_node,face_order,face_num );
%
%  FACE_NODE may contain polygons of different orders.
%  To make the call to PATCH, we will assume all the polygons are the same order.
%  To do so, we'll simply "stutter" the first node in each face list.
%
  for face = 1 : face_num
    face_node(face_order(face)+1:order_max,face) = face_node(1,face);
  end
%
%  If any node index is still less than 1, set the whole face to 1's.
%  We're giving up on this presumably meaningless face, but we need to
%  do it in a way that keeps MATLAB happy!
%
  for face = 1 : face_num
    for i = 1 : order_max
      face_node(i,face) = max ( face_node(i,face), 1 );
    end
  end
% col = rand(face_num,10); % col必须为列向量;color在这之中代表的是TAITherm导出的数据，比如温度 
% col_back=rand(face_num,10);
% 计算面片的法向量
face_vertex=zeros(3,face_num);
[m_vertex,n_vertex]=size(vertex_normal);
for i_vertex=1:n_vertex
    vertex=0;
    sum1=0;
    vector=vertex_normal(:,i_vertex);
    for j_vertex=sort(1:m_vertex,'descend')
        if (vector(j_vertex)==0)
            vector(j_vertex)=[];
        end
    end
    [m,~]=size(vector);
    for i=1:m
        sum1=sum1+normal_vector(:,vector(i));
    end
    face_vertex(:,i_vertex)=sum1/m;
end

% % 按面平移坐标点，其平移方向与法线方向相同
% % vertex_node_xyz=zeros(size(node_xyz));
% vertex_Center_xyz1=[];vertex_Center_xyz2=[];vertex_node_xyz_sum=[];
% [m_node,n_node]=size(face_node);
% for i_node=1:n_node
%     for j_node=1:m_node
%         vertex_node_xyz(:,j_node)=node_xyz(:,face_node(j_node,i_node))-0.0025*face_vertex(:,i_node); % 逆着法向量的方向
%     end
%     vertex_node_xyz_sum=[vertex_node_xyz_sum vertex_node_xyz];
%     X_node1=sum(vertex_node_xyz(1,1:3))/3;X_node2=sum(vertex_node_xyz(1,end-2:end))/3;
%     Y_node1=sum(vertex_node_xyz(2,1:3))/3;Y_node2=sum(vertex_node_xyz(2,end-2:end))/3;
%     Z_node1=sum(vertex_node_xyz(3,1:3))/3;Z_node2=sum(vertex_node_xyz(3,end-2:end))/3;
%     %确定背面片的点，共两个
%     vertex_Center_xyz1=[vertex_Center_xyz1;X_node1,Y_node1,Z_node1];
%     vertex_Center_xyz2=[vertex_Center_xyz2;X_node2,Y_node2,Z_node2];
%     hold on
%     scatter3(vertex_Center_xyz1(:,1),vertex_Center_xyz1(:,2),vertex_Center_xyz1(:,3),3,'.','black')
%     scatter3(vertex_Center_xyz2(:,1),vertex_Center_xyz2(:,2),vertex_Center_xyz2(:,3),3,'.','black')
% end
% vertex_node=reshape(1:m_node*face_num,m_node,face_num);
% % handle = patch ( 'Vertices', vertex_node_xyz_sum', 'Faces', vertex_node','FaceVertexCData',col_back(:,i_i_i),'FaceColor','flat' );
% % set ( handle, 'EdgeColor', 'Black' );
% % colormap('jet');
% % colorbar('southoutside')

view(3)
%
%  Terminate.
%
  fprintf ( 1, '\n' );
  fprintf ( 1, '  OBJ_DISPLAY:\n' );
  fprintf ( 1, '  Normal end of execution.\n' );
  fprintf ( 1, '\n' );

  slider_text
%   [m_edit,n_edit]=size(index{1});
%   MainFigure=gcf;
%   for i_edit=1:n_edit
%       % 标识显示框
%       edit_1{i_edit}=uicontrol('style','edit','position',[465 360-(i_edit*40) 40 20],'parent',MainFigure,'callback',@edit1_callback);
%       edit_1{i_edit}.Units='normalized';
%       % 数据显示框
%       edit_2{i_edit}=uicontrol('style','edit','position',[515 360-(i_edit*40) 40 20],'parent',MainFigure,'callback',@edit1_callback);
%       edit_2{i_edit}.Units='normalized';
%   end
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
%           elseif (isequal(pos,vertex_Center_xyz1(i,:)))
%               iscenter_back=1;
%               face_Serial_number_back=i;
%               break;
%           elseif (isequal(pos,vertex_Center_xyz2(i,:)))
%               iscenter_back=1;
%               face_Serial_number_back=i;
%               break;
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
              edit_2{i_edit}=uicontrol('style','edit','position',[515*Position1 (360-(i_edit*40))*Position1 40*Position1 20*Position2],'parent',MainFigure);
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
  timestamp ( );