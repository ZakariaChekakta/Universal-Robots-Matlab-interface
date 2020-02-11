function LAN_init(obj,ip_UR)
%% ��ʼ������
if nargin > 1
   obj.ip_UR = ip_UR;
end    
rport1 = 29999;               %UR�����˶˿ںţ�29999Ϊdashboard�˿ڣ����Խ����ϵ磬����ƶ����ػ��Ȳ���
rport2 = 30003;               %30003Ϊʵʱ�˿ڣ�ˢ����125Hz��30001��30002�˿�ˢ����Ϊ10Hz
rport3 = 30001;               %30001ˢ����10Hz,���ڶ�calibration data

obj.s1 = tcpip(obj.ip_UR,rport1);

obj.s2 = tcpip(obj.ip_UR,rport2);
obj.s2.ReadAsyncMode = 'manual';
obj.s2.Timeout = 0.0001;
obj.s2.InputBufferSize = 1116;

obj.s3 = tcpip(obj.ip_UR,rport3);
obj.s3.ReadAsyncMode = 'manual';
obj.s3.Timeout = 0.0001;
obj.s3.InputBufferSize = 716;  %UR5e�������������716

