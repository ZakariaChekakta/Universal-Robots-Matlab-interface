classdef UR_object < handle
%% a
%% public parameters
    properties
        a_joint =  0.35; %�ؽڿռ���ٶ�����
        a_tool  =  1 ; %�ѿ����ռ���ٶ�����
        v_joint =  0.2;    %�ؽڿռ��ٶ�����
        v_tool  =  0.1; %�ѿ����ռ��ٶ�����
        ip_UR='192.168.1.111'     %����������Ĭ��ip
        tcp_data;      %tcp��Ϣ��������������tcpλ�ˣ�������ʼ��ֵ 
        n_tcp;         % ��ǰ�����tcp�ı��
        target_pose;   %tcp��Ŀ��λ��
    end
%% privately accessable parameters    
    properties  (SetAccess = private, GetAccess = public) 
        s1        %����������˿�1�������ϵ磬�ϵ磬�Ӵ��ƶ���
        s2        %����������˿�2�����������˶����TCP���ò����� 
        s3        %����������˿�3�����ڶ�ȡ�������궨����
        pose      %��ǰ��������̬
        q         %��ǰ�����˹ؽڽǶ�
        force     %���¶�ȡ���Ĺ��߶�����
        active_tcp   %��ǰ���tcp����
        freedrive_status %�����϶�״̬
    end 
   
    methods   
        function obj = UR_object(varargin)  %��������ɺ���
          % ����ΪUR��ip��ַ����ȱʡ������Ĭ�ϵ�ip��ִַ��
          % ��ʼ��LAN����
           LAN_init(obj,varargin{:});
          % ��ʼ��tcp_data
           tcp_data_init(obj);
          % Ĭ�ϼ���1��tcp_data
           obj.n_tcp = 1;
          % ��ʼ��target_pose
           obj.target_pose = obj.pose;
        end

        LAN_init(obj,varargin);  %��ʼ������˿ڲ���

        tcp_data_init(obj);  %����Ĭ�ϵ�tcp����

        set_active_tcp(obj); % ����ѡ����tcp����

        power_on(obj);  %UR��ʼ�����ϵ�

        power_off(obj);   %UR�ϵ�
        
        unlock(obj); %���������ֹͣ
        
        freedrive_on(obj); %�����϶�
        
        freedrive_off(obj); %�ر������϶�
        
        [pose,q,force] = refresh_status(obj);  %����URλ�á��ؽڽ��Լ���
        
        freedrive_status = refresh_freedrive_status(obj); %���������϶�����

        cmd = move_tcp(obj,offset,path_type) %����ڹ�������ϵ�����ƶ�

        cmd = set_pose(obj,tgt_pose,path_type,axis_no_rotate); %�ƶ���������ϵ�е�ָ��λ�ã��ѿ����ռ���߹ؽڿռ��ֵ��
        
        cmd = set_joint(obj,tgt_q); %�ƶ���ָ���ĹؽڽǶ�
        
        cmd = set_speed(obj,varargin); %���ڻ�����ϵ�и������ٶ��˶�
        
        cmd = set_speed_tcp(obj,varargin); %���ڹ�������ϵ�и������ٶ��˶�
        
        cmd = force_mode_tcp(obj,varargin)

        cmd = stop(obj); %ֹͣ��ǰ��UR�˶�
        
        resume(obj,varargin)% �ָ�����ͣ���˶� 
        
        R = R2Rxyz(obj,R);  %��̬����->��תʸ��
        
        Rxyz = Rxyz2R(obj,Rxyz);  %��תʸ��->��̬����

    end
   
    methods  % set��get���
        function pose = get.pose(obj)   %����ѯpose����ʱ,��������ˢ�º�����ȡ�µ�status
           [pose,~,~] = obj.refresh_status;
        end
        
        function q = get.q(obj)   %����ѯq����ʱ,��������ˢ�º�����ȡ�µ�status
           [~,q,~] = obj.refresh_status;
        end
        
        function force = get.force(obj)   %����ѯforce����ʱ,��������ˢ�º�����ȡ�µ�status
           [~,~,force] = obj.refresh_status;
        end

        function freedrive_status = get.freedrive_status(obj)   %����ѯforce����ʱ,��������ˢ�º�����ȡ�µ�status
           freedrive_status = obj.refresh_freedrive_status;
        end
        
        function set.n_tcp(obj,n_tcp)      
           obj.n_tcp = n_tcp;
           set_active_tcp(obj);
        end

        function active_tcp = get.active_tcp(obj)
           active_tcp = obj.tcp_data(obj.n_tcp);
        end
        
        function set.tcp_data(obj,tcp_data) %ÿ������tcp����ʱˢ��UR��tcp����
           obj.tcp_data = tcp_data;
           set_active_tcp(obj);
        end
    end
   
end