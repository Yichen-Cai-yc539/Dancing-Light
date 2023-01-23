%% Setup
clear all

% Standard parametric equation for our variation of Lissajous figure:
% x = A sin(at) + B sin(bt)
% z = C sin(ct + f) + D sin(dt + g)
% where a=c=w1, b=d=w2.

% Frequency input param
w1 = 330.4;
w2 = 460.8;
ratio = w2/w1;


% Freq1 param
A = 1; a = w1;
C = 1; c = w1; f = 0.75;
% Freq2 param
B = 1; b = w2;
D = 1; d = w2; g = 0;

% Optical illusion param
T = double(lcm(sym([w1, w2]))*2*pi/(w1*w2)); % Total time for 1 trace
t_exp = 1/10; % Camera/eye exposure time
t_vid = 5; % Total video time
framerate = 16;
slomo = 1; % slomo > 1: slow down; slomo < 1: speed up.

N = 100000; % Total dots for video time. 1s <-> 10000 dots
t = linspace(0, t_vid, N);
n_T = round(T/t_vid*N); % actual number of dots required to capture entire shape
n_exp = round(t_exp/t_vid*N); % experiment number of samples

%% Check total graph and one graph
nn = 100000;
tt = linspace(0, T, nn*T);
x = A*sin(a*tt) + B*sin(b*tt);
z = C*sin(c*tt + f*pi) + D*sin(d*tt + g*pi);
figure

scatter(x, z, '.')
axis equal
lim = 4;
xlim([-lim lim])
ylim([-lim lim])
title(sprintf('Complete Trace of Lissajous Figure (t=0-%0.3fs)', T))
subtitle(sprintf('w1=%0.2f  w2=%0.2f  (r=%0.3f)  f=%0.2f  g=%0.2f', ...
    w1, w2, ratio, f, g))

nn = 10000;
tt = linspace(0, t_exp, nn*t_exp);
x = A*sin(a*tt) + B*sin(b*tt);
z = C*sin(c*tt + f*pi) + D*sin(d*tt + g*pi);
figure
scatter(x, z, '.');
axis equal
lim = 4;
xlim([-lim lim])
ylim([-lim lim])
title(sprintf('Lissajous Figure In One Exposure Time (t=0-%0.3fs)', t_exp))
subtitle(sprintf('w1=%0.2f  w2=%0.2f  (r=%0.3f)  f=%0.2f  g=%0.2f', ...
    w1, w2, ratio, f, g))

%% Rotation video

% Video param
realtimevid = VideoWriter(sprintf('w1-%0.2f_w2-%0.2f_(r-%0.3f)_f-%0.2f_g-%0.2f__SPEEDdiv%d', ...
    w1, w2, ratio, f, g, slomo), 'MPEG-4'); %open video file
realtimevid.FrameRate = framerate;  %can adjust this, 5 - 10 works well for me
open(realtimevid)
set(gca, 'box', 'off', 'FontSize', framerate) % 16 frames per second (1/16)

frameo = round(1/framerate/t_vid*N); % number of dots to skip between each frame
frameo = frameo/slomo;
for i = 1:frameo:N-n_exp
    twin = t(i:i+n_exp);
    x = A*sin(a*twin) + B*sin(b*twin);
    z = C*sin(c*twin + f*pi) + D*sin(d*twin + g*pi);

    scatter(x, z, '.')
    axis equal
    lim = 2.2;
    xlim([-lim lim])
    ylim([-lim lim])
    title(sprintf('t = %0.3f - %0.3f s', i/N*t_vid, (i+n_exp)/N*t_vid))
    subtitle(sprintf('w1=%0.2f  w2=%0.2f  (r=%0.3f)  f=%0.2f  g=%0.2f  SPEEDx1/%d', ...
        w1, w2, ratio, f, g, slomo))

    %         pause(0.0001);
    frame = getframe(gcf); %get frame
    writeVideo(realtimevid, frame);
    clf;
end
close(realtimevid)

% figure;
% x = A*sin(a*t + fx);
% y = B*sin(b*t) + C*sin(c*t);
% scatter(x, y, '.')
% axis equal
%
% figure;