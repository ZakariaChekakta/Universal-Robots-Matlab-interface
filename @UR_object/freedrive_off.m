function freedrive_off(obj)
%% �ر������϶�ģʽ
% obj: UR�����˶���


if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end


cmd  = 'def endfreedrive():\n';
cmd  = strcat(cmd,'end\n');
fprintf(obj.s2,cmd);  
