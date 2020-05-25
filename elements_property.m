function [ Part_information,Surface_Conditions ] = elements_property()
timestamp ( );
a='C:\Users\dell\Desktop\�ƴ��ƻ�\���������Ϣ\';
files = dir('C:\Users\dell\Desktop\�ƴ��ƻ�\���������Ϣ\*.csv');   % ��ȡ���ɵ�CSV����
fileName = [a files.name];   % �ļ�������·��
[~, ~, context] = xlsread(fileName);  % ȫ����ȡ���������ֺ��ı�
[m,~]=size(context);

for i=2:m
    if (isnan(context{i,1}))
        break;
    end
end
Part_information = context(1:i-1,:); % �����Ϣ

[m_part,~] = size(Part_information);
for i_part = sort(2:m_part,'descend')
%     if (~strcmp(context{i_part,4},'Front Layer')&&~strcmp(context{i_part,4},'Back Layer'))
    if (~strcmp(context{i_part,4},'Front Layer'))
        Part_information(i_part,:) = [];
    end
end

j1=0;j2=0;
for j=1:m
    if (strcmp(context{j,1},'Section Start: Surface Conditions'))
        j1=j;
    elseif (strcmp(context{j,1},'Section Start: Materials')) 
        j2=j;
    end
end
Surface_Conditions = context(j1+2:j2-2,:); % ������Ϣ
Surface_Conditions(:,5:end) = [];

timestamp ( );

end

