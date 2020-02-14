function freedrive_status = refresh_freedrive_status(obj)
    %% ��30002�˿ڶ�ȡUR�����˵ĸ�����Ϣ
    %% ����readasync�����ȡԭʼ�Ķ�����״̬��Ϣ
    
%     if strcmp(obj.s3.status,'closed')  %���û�򿪶˿ڣ����֮
%         fopen(obj.s3);
%         pause(0.1);
%     end

    readasync(obj.s3);
    msg = fread(obj.s3);
    if  size(msg,1)<4
        warning('s3 connection error, reconnecting');
        fclose(obj.s3);
        LAN_init(obj,obj.ip_UR);
        freedrive_status = obj.freedrive_status;  %����ֵ֮ǰҪ��pose��ֵ����Ȼ���᷵�ظ���Ա����
        return;
    end
    len = msg(3)*256+msg(4);
    if len ~= length(msg)
        warning('s3 data error, rereading');
        freedrive_status = obj.freedrive_status;
        return;
    end

    %% ��ԭʼ������״̬��Ϣ����ȡ����Ȥ����Ϣ
    ct = 5; %��������ʼ��
    while(ct<len)
        pkg_len = msg(ct+3)*256+msg(ct+4); %���ݰ�����
        pkg_type = msg(ct+5);
        if (pkg_type == 0)
            freedrive_status = msg(ct+22);
            break;
        end
        ct = ct+pkg_len;          
    end


   
