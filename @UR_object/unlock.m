function unlock(obj)
%% ���������ֹͣ
% obj: UR�����˶���
%     fopen(obj.s1); 
    disp(query(obj.s1,'unlock protective stop'));
%     fclose(obj.s1);