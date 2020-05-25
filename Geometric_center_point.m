function  [Center_xyz1,Center_xyz2,Center_xyz3]  = Geometric_center_point( node_xyz,face_node,face_order,face_num )
Center_xyz1=zeros(face_num,3);
Center_xyz2=zeros(face_num,3);
Center_xyz3=zeros(face_num,3);
for i=1:face_num
    num=face_order(i,1);
    A=zeros(num,3); %存储每一个面的坐标
    for j=1:num
        A(j,1)=node_xyz(1,face_node(j,i));
        A(j,2)=node_xyz(2,face_node(j,i));
        A(j,3)=node_xyz(3,face_node(j,i));
    end
    Center_xyz1(i,:)=sum(A)/num;
    Center_xyz2(i,:)=(Center_xyz1(i,:)+A(1,:)+A(2,:))/3;
    Center_xyz3(i,:)=(Center_xyz1(i,:)+A(3,:)+A(2,:))/3;
end
end

