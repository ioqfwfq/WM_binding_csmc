function c = set_parameters(c)
%% General experimental settings
% Marker values
c.marker.expstart        = 89;
c.marker.expend          = 90;
c.marker.fixOnset        = 10;
c.marker.pic1            = 1;
c.marker.delay1          = 2;
c.marker.pic2            = 3;
c.marker.delay2          = 4;
c.marker.probeOnset      = 5;
c.marker.response        = 6;
c.marker.break           = 91;

%% key mapping
c.key.left = '4';
c.key.right = '6';
c.key.top = '2';
c.key.bottom  = '7';
c.key.middle  = '5';
%% General stimulus and timing settings

% stimili size
c.stimSizeW = 275; % horizontal pixels
c.stimSizeH  = c.stimSizeW; % vertical pixels
c.rectSizeW = c.stimSizeW + 10;
c.rectSizeH = c.stimSizeH + 10;

% Timing
c.t_blank_max = 0.2; % in seconds

c.t_pre_stim = 1; % in seconds
c.t_pre_stim_jitter = 0.2; % in seconds
c.t_stim = 1;
c.t_delay1 = 1;
c.t_delay1_jitter = 0.2;
c.t_delay2 = 2.5;
c.t_delay2_jitter = 0.2;

% countdown
c.countdown.num = 3;
c.countdown.t1 = 0.5;
c.countdown.t2 = 0.5;
end