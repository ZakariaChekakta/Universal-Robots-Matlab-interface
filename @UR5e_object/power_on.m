function power_on(obj)
%% UR�ϵ磬����ƶ�
% obj: UR�����˶���
fopen(obj.s1); 
fprintf(obj.s1,'power on\n');     
pause(4);
fprintf(obj.s1,'brake release\n');  
fclose(obj.s1);

