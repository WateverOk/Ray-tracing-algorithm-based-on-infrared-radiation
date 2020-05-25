function [Image , Image_initial] = Ray2Image(u, v, cam, face_node_Triangle, node_xyz, face_vertex_Triangle, Temp_Triangle , Temp_Triangle_back, group_Divide, Part_information, Surface_Conditions, Downward_radiation_direction, Drad, Up_transmittance_ANSS, Up_transmittance_ave)
global Ray_storage_sum Ray_storage_sum_initial k%Downward_radiation_direction
    %% Coloring each grid
    function [R, G, B] = get_color(x, y)
        Ray = cam.get_ray(x, y);
        
        vertices=node_xyz';
        vert1 = vertices(face_node_Triangle(1,:),:); %所有三角形的第一个顶点坐标
        vert2 = vertices(face_node_Triangle(2,:),:); %所有三角形的第二个顶点坐标
        vert3 = vertices(face_node_Triangle(3,:),:); %所有三角形的第三个顶点坐标
        orig=Ray.origin;
        dir=Ray.direction;
        % 找到距离光线发射点最近的面片
        Ray_storage={}; %光线存储
        i=0;
        k=k+1;
        while(1)
            i=i+1;
            [intersect, t, ~, ~, xcoor] = TriangleRayIntersection(orig, dir, vert1, vert2, vert3);% 相交检测
            Serial_number=find(double(intersect)==1);
            t_number=t(Serial_number);
            RAY.number=Serial_number(t_number==min(t_number)); %射线距离发射点最近的面元序号
            [number,~]=size(RAY.number);
            if (number>1)
                RAY.number = RAY.number(1);
            end
            RAY.distance=t(RAY.number)*norm(dir); %射线距离发射点最近的距离
            if isempty(RAY.distance)
                break;
            end
            RAY.intersection=xcoor(RAY.number,:); %射线与最近面元的交点坐标
            RAY.temperature=Temp_Triangle(RAY.number);
            RAY.orig=orig;
            RAY.dir=dir;
            id_cmp=RAY.number<=group_Divide;
            id=find(id_cmp==1);
            Part_information_plus = cell2mat(Part_information(2:end,1));
            RAY.Part_ID=Part_information_plus(id(1)); % 面元的零件归属
            [n_part_infor,~]=size(Part_information);
            for i_part_infor = 1:n_part_infor
                if (Part_information{i_part_infor,1}==RAY.Part_ID)
                    part_infor=i_part_infor;
                    break;
                end
            end
            RAY.Surface_Condition=Part_information{part_infor,10}(1,10:end); % 面元的表面信息
            [n_Surf_Cond,~]=size(Surface_Conditions);
            for i_Surf_infor = 1:n_Surf_Cond
                if (strcmp(Surface_Conditions{i_Surf_infor,1},RAY.Surface_Condition))
                    Surf_infor=i_Surf_infor;
                    break;
                end
            end
            RAY.Emissivity=Surface_Conditions{Surf_infor,2}; % 发射率
            RAY.Absorptivity=Surface_Conditions{Surf_infor,3}; % 吸收率
            RAY.Type=Surface_Conditions{Surf_infor,4}; %零件类型
            A=face_vertex_Triangle(:,RAY.number);B=-dir;
            RAY.vertex_Triangle=A;
            [index,theta] = drad( A , Downward_radiation_direction );
            RAY.index = index;
            RAY.theta = theta;
            Reflection_ray = Reflection(A,B,RAY.intersection',RAY.Type);
            RAY.Reflection_ray=Reflection_ray;
            Ray_storage{i}=RAY;
            
            orig  = RAY.intersection + 0.0001*Reflection_ray'/norm(Reflection_ray);         % ray's origin
            dir   = Reflection_ray;         % ray's direction
        end
        [Radiation_value , q1] = Radiation_calculation( Ray_storage, Drad, Up_transmittance_ANSS, Up_transmittance_ave );
        Ray_storage_sum(u==x) = Radiation_value - q1; %反射辐射亮度值
        Ray_storage_sum_initial(u==x) = q1; %初始光线辐射亮度值
        
%         [R, G, B] = Ray.coloring(hitable, depth);
    end

    [m,n]=size(u);
    Ray_storage_sum=zeros(m,n);
    Ray_storage_sum_initial=zeros(m,n);
    k=0;
    for lie = 1:n
        for hang = 1:m
            get_color(u(hang,lie),v(hang,lie));
        end
    end
    
%     Radiance_max = 1e5; %辐亮度最大值
%     Radiance_min = min(min(Ray_storage_sum)); %辐亮度最小值
%     
%     Image = 255 * (Ray_storage_sum - Radiance_min) / (Radiance_max - Radiance_min);
      Image = Ray_storage_sum;
      Image_initial = Ray_storage_sum_initial;
end