function freedrive_on(obj)
%% ���������϶�ģʽ
% obj: UR�����˶���


if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end


cmd  = 'def freedrive():\n';
cmd  = strcat(cmd,'freedrive_mode()\n');
cmd  = strcat(cmd,'sleep(100)\n');
cmd  = strcat(cmd,'end\n');
fprintf(obj.s2,cmd);   

