function cmd = set_speed_tcp(obj,varargin)
% servo_cart���ڻ����˻�����ϵ���Ը����ٶ�V�˶�
% v: [x,y,z,rx,ry,rz],xyz��λΪm/s��rx,ry,rz��λΪrad/s

if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

v = varargin{1};

if nargin==3
    a = varargin{2};
else
    a = obj.a_tool;
end

t=100;
R_robot = obj.Rxyz2R(obj.pose(4:6));
v(1:3) = v(1:3)*R_robot';
v(4:6) = v(4:6)*R_robot';

cmd = sprintf(...
     'speedl([%f,%f,%f,%f,%f,%f],%f,%f)\n'...
      ,v,a,t);
  
if nargout==0
    fprintf(obj.s2,cmd);
end
