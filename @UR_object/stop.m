function cmd = stop(obj)
%% ֹͣ��ǰ�Ļ������˶� 
if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

cmd = sprintf('stopl(%f)\n',3*obj.a_tool);

if nargout==0
    fprintf(obj.s2,cmd);
end