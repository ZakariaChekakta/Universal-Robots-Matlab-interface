function cmd_out = force_mode_tcp(obj,varargin)
%% ����UR������ģʽ
%   varargin = tare_trigger,DoF,wrench,cmd
%   arg1: tare_trigger  =1 ����֮ǰ������������  =0 ����֮ǰ������
%   arg2: DoF: 6ά����������1��Ӧ�����ɶ�Ϊ���ԣ�0��Ӧ��Ϊ����
%   arg3: wrench: tcp�����ʩ�ӵ�6ά��/����������DoFΪ0�����ɶ��Զ�����
%   arg4: cmd_motion: urscript�˶�ָ��,����ͨ��move_tcp�������Զ�����
%                   ��cmdȱʡ����Ϊ�����棬��δȱʡ������ʩ������ͬʱ�����˶�

damp = 0.005; %��������  Ĭ��ֵ0.005
gain = 1;     %���淴������  Ĭ��ֵ1

tare_trigger = varargin{1};
DoF          = varargin{2};
wrench       = varargin{3};
if nargin==5
    cmd_motion = varargin{4};
else
    cmd_motion = [];
end

if tare_trigger == 1
    cmd_tare = 'zero_ftsensor()\n';
else
    cmd_tare = [];
end

arg_DoF = sprintf('[%d,%d,%d,%d,%d,%d]',DoF);
arg_wrench = sprintf('[%f,%f,%f,%f,%f,%f]',wrench);
lim = ones(6,1);
lim(DoF==1) = obj.v_tool;
arg_lim = sprintf('[%f,%f,%f,%f,%f,%f]',lim);

cmd_fm = strcat('force_mode(get_actual_tcp_pose(),',...      %ע�⣬���صĲο�����ϵ�����빤�߶˹���
                 arg_DoF,',',arg_wrench,',2,',arg_lim,')\n'); 

cmd =            'def myProg():\n';
cmd = strcat(cmd,'\t',cmd_tare);
cmd = strcat(cmd,'\t','thread myThread():\n');
cmd = strcat(cmd,'\t\t','while (True):\n');
cmd = strcat(cmd,'\t\t\t','force_mode_set_damping(', num2str(damp), ')\n');  %��������  Ĭ��ֵ0.005
cmd = strcat(cmd,'\t\t\t','force_mode_set_gain_scaling(', num2str(gain),')\n'); %���淴������  Ĭ��ֵ1
cmd = strcat(cmd,'\t\t\t', cmd_fm);                       %��������
cmd = strcat(cmd,'\t\t\t','sync()\n');
cmd = strcat(cmd,'\t\t','end\n');
cmd = strcat(cmd,'\t','end\n');
cmd = strcat(cmd,'\t','thrd = run myThread()\n');
cmd = strcat(cmd,'\t',cmd_motion,'\n');        %���˶������滻cmd4,�ο�move_tcp����ĵ�����
cmd = strcat(cmd,'\t','join thrd\n');
% cmd = strcat(cmd,'    sleep(2)\n'); %��join thrd��sleep������
cmd = strcat(cmd,'end\n');
cmd_out = sprintf(cmd);

if nargout==0
    fprintf(obj.s2,cmd_out);
end