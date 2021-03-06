% SPC-LAB2
% Konrad Białek 248993

clear; clc; close all; format('long');
s=tf('s');
 
%% deinicja systemów i zmiennych
T0=2; T1=1/3; T2=1/5; T3=7; a_osc=3; b_osc=5; tau=0.11;
T4=0.1; T5=0.7; T6=0.8;
SYS=[1/(T0*s+1);                      % s1=-1/T0 
    1/((T1*s+1)*(T2*s+1));            % s1=-1/T1, s2=-1/T2 
    1/(T3*s);                         % s1=0 
    exp(-tau*s);                      % s1 nie istnieje
    1/((T4*s+1)*(T5*s+1)*(T6*s+1))];  % s1=-1/T4, s2=-1/T5, s3=-1/T6 (tylko 
   % w 3. części laboratorium)       
 
t=linspace(0,9.99,1000)';
omega=5; 
u=sin(omega*t);
 
%% zadanie 1. - odpowiedzi na pobudzenie sinusoidalne
 
% A i fi dla każdego systemu wyznaczono ręcznie
A=[sqrt(101)/101, sqrt(153)/34, 1/35, 1];
fi=[atan(-10), atan(-12/(-3))+pi, -pi/2, atan(tan(-0.55))];
 
for L=1:4
    figure(L); hold on; 
    plot(t,A(L)*sin(omega*t+fi(L)),'r');
    lsim(SYS(L),u,t);
    grid on;
    legend('A*sin(\omega*t)','lsim()');
end
 
%% przygotowanie charakterystyk Nyquista
omega=logspace(-2,3,500000)';
[re1,im1,omega1]=nyquist(SYS(1),omega);
re1=squeeze(re1);
im1=squeeze(im1);
[re2,im2,omega2]=nyquist(SYS(2),omega);
re2=squeeze(re2);
im2=squeeze(im2);
[re3,im3,omega3]=nyquist(SYS(3),omega);
re3=squeeze(re3);
im3=squeeze(im3);
[re4,im4,omega4]=nyquist(SYS(4),omega);
re4=squeeze(re4);
im4=squeeze(im4);
 
%% zadanie 2. - charakterystyka amplitudowo-fazowa w 3D
 
figure;
plot3(im1, re1, omega1);
set(gca, 'ZScale', 'log');
ylabel('Re(K(j*\omega))'); xlabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/(T_0*s+1)'); grid on;
 
figure;
plot3(im2, re2, omega2);
set(gca, 'ZScale', 'log');
ylabel('Re(K(j*\omega))'); xlabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/((T_1*s+1)*(T_2*s+1))'); grid on;
 
figure;
plot3(im3, re3, omega3);
set(gca, 'ZScale', 'log');
ylabel('Re(K(j*\omega))'); xlabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/(T_3*s)'); grid on;
 
figure; 
plot3(im4, re4, omega4);
set(gca, 'ZScale', 'log');
ylabel('Re(K(j*\omega))'); xlabel('Im(K(j*\omega))'); zlabel('\omega');
title("K(s)=e^-^\tau^*^s"); grid on;
 
%% zadanie 3. - sprawdzenie zgodności charakterystyki
 
figure; 
nyquist(SYS(1),omega);
xlabel('Re(K(j*\omega))'); ylabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/(T_0*s+1)'); grid on;

figure; 
nyquist(SYS(2),omega);
xlabel('Re(K(j*\omega))'); ylabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/((T_1*s+1)*(T_2*s+1))'); grid on;

figure; 
nyquist(SYS(3),omega);
xlabel('Re(K(j*\omega))'); ylabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/(T_3*s)'); grid on;

figure; 
nyquist(SYS(4),omega);
xlabel('Re(K(j*\omega))'); ylabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=e^-^\tau^*^s'); grid on;

figure; 
nyquist(SYS(5),omega);
xlabel('Re(K(j*\omega))'); ylabel('Im(K(j*\omega))'); zlabel('\omega');
title('K(s)=1/((T_4*s+1)*(T_5*s+1)*(T_6*s+1))'); grid on;
 
%% po odczytaniu wartości z wykresów 9-13
% t=linspace(0,9.99,1000)'; %oś czasu zostanie zmieniona w 3., 4., i 5.
% badaniu
 
A1=0.206422503618186;
fi1=-1.363424850858049;
w1=2.37;
figure; hold on; 
plot(t,A1*sin(w1*t+fi1),'r'); 
lsim(SYS(1),sin(w1*t),t);
grid on;
legend('A*sin(\omega*t)','lsim()');
 
A2=0.803674063286853;
fi2=-0.892946183552701;
w2=1.82;
figure; hold on; 
plot(t,A2*sin(w2*t+fi2),'r'); 
lsim(SYS(2),sin(w2*t),t);
grid on;
legend('A*sin(\omega*t)','lsim()');
 
t=linspace(0,2999,1000)'; %%%%%
A3=14.300000000000001;
fi3=-1.570796326794897;
w3=0.01;
figure; hold on; 
plot(t,A3*sin(w3*t+fi3),'r'); 
lsim(SYS(3),sin(w3*t),t);
grid on;
legend('A*sin(\omega*t)','lsim()');
 
t=linspace(0,0.999,1000)'; 
A4=1.000476386527938;
fi4=3.380753200548031;
w4=-30.7;
figure; hold on; 
plot(t,A4*sin(w4*t+fi4),'r'); 
lsim(SYS(4),sin(w4*t),t);
grid on;
legend('A*sin(\omega*t)','lsim()');
 
t=linspace(0,99.9,1000)'; %%%%%
A5=0.979435041235507;
fi5=-0.309158388215250;
w5=0.194;
figure; hold on; 
plot(t,A5*sin(w5*t+fi5),'r'); 
lsim(SYS(5),sin(w5*t),t);
grid on;
legend('A*sin(\omega*t)','lsim()');
