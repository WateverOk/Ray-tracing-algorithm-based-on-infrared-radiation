function [ index,col_file,col_back_file,context_xlsx_file ] = Direct_read( fileName )
fid = fopen(fileName);
tline = fgetl(fid);
i=0;
while ischar(tline)
    i=i+1;
    str = deblank(tline);
    if (i<=11)
    else
        S = regexp(str, ',', 'split');
        if (i-11<=2)
            S(:,1:2)=[];
            context_xlsx(i-11,:)=S;
        else
            S(:,1:3)=[];
            context_xlsx(i-11,:)=S;
        end
    end
    tline = fgetl(fid);
    if (i+1==8||i+1==9||i+1==11)
        tline='There is no information in this line';
    end
    if(isempty(tline))
        break;
    end
end
fclose(fid);
col_file={};
col_back_file={};
[~,n_xlsx]=size(context_xlsx);
    
    for i_xlsx=1:n_xlsx
        word_xlsx=context_xlsx{1,i_xlsx};
        [~,n_word]=size(word_xlsx);
        if n_word<5||s_eqi ( word_xlsx(1:5), '"Elem' )==0;
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
    [~,n_xlsx]=size(context_xlsx);
    for i_i_xlsx=1:n_xlsx
        word2_xlsx=context_xlsx{2,i_i_xlsx};
        if s_eqi ( word2_xlsx, '(front)' )==1
            d=d+1;
            col(d,:)=cellstr2num(context_xlsx(3:end,i_i_xlsx)); % 面片温度
            past_xlsx=now_xlsx;
            now_xlsx=i_i_xlsx;
            if (past_xlsx==0 && now_xlsx-1==0)
            else
                index{d-1}={past_xlsx,now_xlsx-1};
            end
        elseif s_eqi ( word2_xlsx, '(back)' )==1
            d_back=d_back+1;
            col_back(d_back,:)=cellstr2num(context_xlsx(3:end,i_i_xlsx)); % 面片温度
        end
    end
    % 记录上最后一列的索引
    index{d}={now_xlsx,n_xlsx};
    col_file{1}=col;
    col_back_file{1}=col_back;
    context_xlsx_file{1}=context_xlsx;
end

