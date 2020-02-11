function cmd = move_tcp(obj,offset,path_type)
%% movetcp����������ڹ�������ϵ�����ƶ�
%  offset: [x,y,z,rx,ry,rz],xyz��λΪ�ף�rx,ry,rz��λΪ����

%   path_type :'cart' �ѿ����ռ����Բ�ֵ
%              'joint'�ؽڿռ����Բ�ֵ

% �����µ�target_pose������UR����ĸ�����
offset = offset(:); % ��������������������������ɰ�������
R = obj.Rxyz2R(obj.pose(4:6));
R_offset =  obj.Rxyz2R(offset(4:6));
obj.target_pose(1:3) = obj.pose(1:3) + R*offset(1:3);
obj.target_pose(4:6) =  obj.R2Rxyz(R*R_offset);

% ��UR�����˶�����
if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

t=0;r=0;%Ĭ��ֵ 

if nargin==2
    path_type = 'cart';
end

if strcmp(path_type,'cart')
    cmd = sprintf(...
         'movel(pose_trans(get_target_tcp_pose(),p[%f,%f,%f,%f,%f,%f]),%f,%f,%f,%f)\n'...
         ,offset,obj.a_tool,obj.v_tool,t,r);
elseif strcmp(path_type,'joint')
    cmd = sprintf(...
         'movej(pose_trans(get_target_tcp_pose(),p[%f,%f,%f,%f,%f,%f]),%f,%f,%f,%f)\n'...
         ,offset,obj.a_joint,obj.v_joint,t,r);    
end
 
 
 if nargout==0
     fprintf(obj.s2,cmd);
 end
    

    