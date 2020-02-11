function freedrive_status = refresh_freedrive_status(obj)
    %% 从30002端口读取UR机器人的各种信息
    %% 利用readasync命令读取原始的二进制状态信息
    
% pose = [0,0,0,0,0,0]';    
    if strcmp(obj.s3.status,'closed')  %如果没打开端口，则打开之
        fopen(obj.s3);
        pause(0.1);
    end
    readasync(obj.s3);
    msg = fread(obj.s3);
    if  size(msg,1)<4
%         aa = msgbox('UR连接错误,将重新连接');
%         uiwait(aa);
        disp('UR连接错误,将重新连接');
        fclose(obj.s3);
        freedrive_status = obj.freedrive_status;  %返回值之前要给pose赋值，不然不会返回给成员属性
        return;
    end
    len = msg(3)*256+msg(4);
    if len ~= length(msg)
%         aa = msgbox('UR读数错误，将重新读数');
%         uiwait(aa);
        length(msg);
        disp('UR读数错误，将重新读数');
        freedrive_status = obj.freedrive_status;
        return;
    end

    %% 从原始二进制状态信息中提取感兴趣的信息
    ct = 5; %计数器初始化
    while(ct<len)
        pkg_len = msg(ct+3)*256+msg(ct+4); %数据包长度
        pkg_type = msg(ct+5);
        if (pkg_type == 0)
            freedrive_status = msg(ct+22);
            break;
        end
        ct = ct+pkg_len;          
    end


   
