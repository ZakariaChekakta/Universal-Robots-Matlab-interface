function cmd = set_joint(obj,tgt_q)
%%   SET_JOINT �ƶ���ָ���ؽڽǶ�
%   tgt_q: [q1,q2,q3,q4,q5,q6],Ŀ��ؽڽǶȣ���λΪ���ȣ�������               

if strcmp(obj.s2.status,'closed')  %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

t=0;
r=0; % movej(q,    a=1.4, v=1.05, t=0, r=0)��Ĭ��t,r=0�����ȼ���a��v֮ǰ 

cmd = sprintf('movej([%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
             tgt_q, obj.a_joint, obj.v_joint, t, r);

%cmd
if nargout==0
    fprintf(obj.s2,cmd);
end
