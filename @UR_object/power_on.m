function power_on(obj)
%% UR�ϵ磬����ƶ�
% obj: UR�����˶���
% fopen(obj.s1); 
disp(query(obj.s1,'power on'));     
pause(4);
disp(query(obj.s1,'brake release'));  
% fclose(obj.s1);

obj.set_active_tcp; %TCP������������ϵ�����Ч���ϵ���Զ�ˢ��TCP


