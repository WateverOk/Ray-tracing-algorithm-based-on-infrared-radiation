clear global node_xyz face_order face_node Center_xyz1 Center_xyz2 Center_xyz3 input_file_name AZ EL i_i_i...
       face_num Sliderstep  index face_vertex vertex_node...
       vertex_node_xyz_sum col_file col_back_file context_xlsx_file ex_data_sum val1 vertex_Center_xyz1...
       vertex_Center_xyz2 
clear;clc;
% timestamp ( );
global node_xyz face_order face_node input_file_name face_num index col_file col_back_file context_xlsx_file ex_data_sum val1
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

tic
input_file_name='houseobj.obj';
hitable = 1; %建立场景
%  Get sizes.
%  order_max是用来记录一个面片最多由几个顶点组成
  [ node_num, face_num, normal_num, order_max, group_num] = obj_size ( input_file_name );
%  Print the sizes.
  obj_size_print ( input_file_name, node_num, face_num, normal_num, order_max, group_num );
%  Get the data.
%  读取了点坐标、法向量坐标和其对应的面索引的信息
%  node_xyz 顶点坐标
%  face_order 每个面的顶点数量
%  face_node 面的连接顺序
%  normal_vector 顶点法向量坐标
%  vertex_normal 面的法向量顺序
  [ node_xyz, face_order, face_node, normal_vector, vertex_normal, group ] = ...
    obj_read ( input_file_name, node_num, face_num, normal_num, order_max, group_num );
%   face_node(:,5198:5205)=[];face_node(:,5184:5191)=[];
%   face_order(5198:5205)=[];face_order(5184:5191)=[];
%   group(:,end)=5300;
  [Part_information,Surface_Conditions ] = elements_property(); %读取元件的材质信息

%对于四边形面元进行三角形划分
[m,~]=size(face_order);
face_node_Triangle=[];
vertex_normal_Triangle=[];
Temp=col_file{1}(:,1); %小括号里数字表示某一时刻的温度
Temp_back=col_back_file{1}(:,1); %小括号里数字表示某一时刻的温度
Temp_Triangle=[];
Temp_Triangle_back=[];
group_Divide=[];
for i=1:m
    if (face_order(i)==3)
        face_node_Triangle=[face_node_Triangle face_node(1:face_order(i),i)];
        vertex_normal_Triangle=[vertex_normal_Triangle vertex_normal(1:face_order(i),i)];
        Temp_Triangle=[Temp_Triangle;Temp(i)];
        Temp_Triangle_back=[Temp_Triangle_back;Temp_back(i)];
    else
          node_number = face_order(i);
          for i_node = 3:node_number
              Triangle1 = [face_node(1,i);face_node(i_node,i);face_node(i_node-1,i)];
              face_node_Triangle=[face_node_Triangle Triangle1];
              
              Triangle1 = [vertex_normal(1,i);vertex_normal(i_node,i);vertex_normal(i_node-1,i)];
              vertex_normal_Triangle=[vertex_normal_Triangle Triangle1];
              
              Temp_Triangle=[Temp_Triangle;Temp(i)];
              Temp_Triangle_back=[Temp_Triangle_back;Temp_back(i)];
          end
    end
    if (sum(double(i==group)))
        [~,n_group]=size(face_node_Triangle);
        group_Divide=[group_Divide n_group];
    end
end
disp('划分完毕！')

% t的值是相对于dir的模而言，实际距离需要乘以|dir|
figure(1); clf;
handle = patch ( 'Vertices', node_xyz', 'Faces', face_node_Triangle','FaceVertexCData',Temp_Triangle,'FaceColor','flat' );
% handle = patch ( 'Vertices', node_xyz', 'Faces', face_node_Triangle','FaceAlpha',0);
set ( handle, 'EdgeColor', 'Black' );
colormap('jet');
colorbar('southoutside')
xlabel ( '--X axis--' )
ylabel ( '--Y axis--' )
zlabel ( '--Z axis--' )
timestamp ( );
% 
% % 计算面片的法向量
% [~,n_vertex_Triangle]=size(vertex_normal_Triangle);
% face_vertex_Triangle=zeros(3,n_vertex_Triangle);
% for i_vertex=1:n_vertex_Triangle
%     vertex=0;
%     sum1=0;
%     vector=vertex_normal_Triangle(:,i_vertex);
%     [m,~]=size(vector);
%     for i=1:m
%         sum1=sum1+normal_vector(:,vector(i));
%     end
%     face_vertex_Triangle(:,i_vertex)=sum1/m;
% end
% disp('法向量计算完毕！')
% 
% % %读取大气数据信息
% load('Atmosphere_data2.mat')
% disp('大气数据处理完毕！')
% 
% vertices=node_xyz';
% vert1 = vertices(face_node_Triangle(1,:),:); %所有三角形的第一个顶点坐标
% vert2 = vertices(face_node_Triangle(2,:),:); %所有三角形的第二个顶点坐标
% vert3 = vertices(face_node_Triangle(3,:),:); %所有三角形的第三个顶点坐标
% 
% %% Set # of pixels
px = 10*[40 70]; %像素值

%% Generate camera 生成照相机
lookfrom = [-60;10;0];
lookat = [0;0;0];
dist_focus = norm(lookfrom-lookat); %计算距离 距离焦点
lookat=lookfrom+15*(lookat-lookfrom)/dist_focus;
dist_focus = norm(lookfrom-lookat);
aperture = 0.2; %光圈
cam = camera(lookfrom, lookat, [0; 1; 0], 21, px(2)/px(1), aperture, dist_focus);

%% Set grid
ix = 0:px(2)-1;
iy = 0:px(1)-1;
[u, v] = meshgrid(ix, iy);


%% Generate image 生成图像
ns = 6;
nss = 100;
Image = zeros(px(1), px(2)); %存放图片数据
Image_initial = zeros(px(1), px(2));
Image_sum = zeros(px(1), px(2));
Image_tmp = zeros(px(1), px(2), ns);
Image_tmp_initial = zeros(px(1), px(2), ns);
p=parpool;
for ss = 1:nss
tic
    parfor s = 1:ns
%         Generate random number from halton sequense
        hs = haltonset(px(2), 'Skip', abs(randi(500)), 'Leap', abs(randi(500)));
        hs = scramble(hs, 'RR2');
% hs = rand(2*px(1), px(2));
% Generate image
[Image_tmp(:, :, s) , Image_tmp_initial(:, :, s)] = Ray2Image((u+hs(1:px(1), :))./px(2), (v+hs(px(1)+1:2*px(1), :))./px(1), cam,...
                        face_node_Triangle, node_xyz, face_vertex_Triangle,...
                        Temp_Triangle, Temp_Triangle_back, group_Divide, Part_information,...
                        Surface_Conditions, Downward_radiation_direction, Drad, Up_transmittance_ANSS, Up_transmittance_ave);
    end
t = toc;
% Image = Image + mean(Image_tmp, 3);
disp([num2str(ss) '/' num2str(nss) ': t = ' num2str(t) ' sec.']);
Image = Image + sum(Image_tmp, 3);
Image_initial = (Image_initial*ns*(ss-1) + sum(Image_tmp_initial, 3))/(ns*ss);
Image_sum = Image + Image_initial;
Image_sum  = Gray_value_Z( Image_sum );
% Show image
imshow(uint8(Image_sum));
% imshow(sqrt(Image./(ss)));
drawnow;
end
delete(p);

