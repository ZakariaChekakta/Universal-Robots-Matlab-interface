function [pose,q,force] = refresh_status(obj)
    %% ��30002�˿ڶ�ȡUR�����˵ĸ�����Ϣ
    %% ����readasync�����ȡԭʼ�Ķ�����״̬��Ϣ
       
%     if strcmp(obj.s2.status,'closed')  %���û�򿪶˿ڣ����֮
%         fopen(obj.s2);
%         pause(0.1);
%     end

    readasync(obj.s2);
    msg = fread(obj.s2);
    if  size(msg,1)<4
        warning('s2 connection error, reconnecting');
        fclose(obj.s2);
        LAN_init(obj,obj.ip_UR);
        [pose,q,force] = refresh_status(obj);  %����ֵ֮ǰҪ��ֵ����Ȼ���᷵�ظ���Ա����
        return;
    end
    len = msg(3)*256+msg(4);
    if len ~= length(msg)
        warning('s2 data error, rereading');
        [pose,q,force] = refresh_status(obj);  %����ֵ֮ǰҪ��ֵ����Ȼ���᷵�ظ���Ա����
        return;
    end

    %% ��ԭʼ������״̬��Ϣ����ȡ����Ȥ����Ϣ
    pose = NaN(6,1);
    q = NaN(6,1);
    force = NaN(6,1);
    
    % �������ȡ"Cartesion Info"(type4)
    if obj.s2.InputBufferSize == 1116
        % read tcp pose
        for i=1:1:6
            tmp = msg(445+(i-1)*8:444+i*8);
            tmp = dec2hex(tmp)';
            tmp = strcat(tmp(:)');
            pose(i) = hex2num(tmp);
        end  
        
        % read joint positions
        for i=1:1:6
            tmp = msg(253+(i-1)*8:252+i*8);
            tmp = dec2hex(tmp)';
            tmp = strcat(tmp(:)');
            q(i) = hex2num(tmp);
        end  
        
        % read tcp force
        for i=1:1:6
            tmp = msg(541+(i-1)*8:540+i*8);
            tmp = dec2hex(tmp)';
            tmp = strcat(tmp(:)');
            force(i) = hex2num(tmp);
        end
    else
        [pose,q,force] = refresh_status(obj);
    end

   
