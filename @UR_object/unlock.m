function unlock(obj)
%% ���������ֹͣ
% obj: UR�����˶���
    fopen(obj.s1); 
    fprintf(obj.s1,'unlock protective stop');
    fclose(obj.s1);