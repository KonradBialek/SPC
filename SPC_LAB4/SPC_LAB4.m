% SPC-LAB4
% Konrad Białek 248993
 
clear;
clc; close all; 
t0=250;

%% 1. definicja systemu
T1=11; T2=5;
SYS1=tf([1],[T1 1 0]);
SYS2=tf([1],[T2 1]);
SYS=SYS1*SYS2;
step(SYS,t0);

%% 2. analiza regulatorów ciągłego i dyskretnego
y0=1;

i=21;
T=[0.001 0.04:0.04:0.8 1];

% wyznaczenie nastaw regulatora dyskretnego przy pomocy funkcji c2d()
PIDdyskr_p=c2d(tf([0.138853730402029]),T(i));
PIDdyskr_i=c2d(tf([0.00141162222627038],[1 0]),T(i));
PIDdyskr_d=c2d(tf([25.476518479819823 0],[1 14.3917663722426]),T(i));

%sim('spc4',T0); 
% niewykorzystane - symulacja uruchamiana z poziomu narzędzia Simulink

%% wykres różnicy uchybów

roznica=[-0.02138;-0.78020;-1.35600;-1.77100;-2.05500;-2.40900;-2.38800;
    -2.58800;-2.47000;-2.71700;-2.55900;-2.34300;-2.07200;-2.32600;
    -1.96000;-1.47500;-0.69330;0.43780;2.29700;6.39600;21.96000];

figure(2); hold on; grid on;
plot(T(1,1:21),roznica','b*');
xlabel('czas próbkowania (sample time) [s]'); ylabel('różnica całek kwadratów uchybów (\int\epsilon_n^2dt - \int\epsilon^2(t)dt)'); 
title('Wykres zależności różnicy całek kwadratów uchybów obu regulatorów od czasu próbkowania');
