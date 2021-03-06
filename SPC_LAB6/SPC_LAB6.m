% SPC-LAB6
% Konrad Białek 248993
 
clear; clc; close all; 
OX="czas [s]";
OY="wyjścia układów i modelu";
TYTUL="Zależność wyjść układów i modelu od czasu";
OY1="błędy układów";
TYTUL1="Zależność błędów układów od czasu";
OY2="wyjście regulatora korekcyjnego";
TYTUL2="Zależność wyjścia regulatora korekcyjnego od czasu";
steptime=1; y0=0; y=3; step=0.01; L=1; tk2=50;
a=8; b=3; c=2;

% Sygnał 2 dla zmiennej c
t0=16; tk=30;
x=[0:step:tk]';
fx=atan((x-ones(length(x),1)*t0))/pi+c+0.5;

%System 1. - zmienna c
out=sim('spc6',tk2);
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.y,'b',out.t,out.y1,'g',out.t,out.y2,'r',out.t,out.y3,'k');
xlabel(OX); ylabel(OY); title(TYTUL);
legend("c=const","c!=const","c!=const i REG2","model","Location","Southeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.e,'b',out.t,out.e1,'g',out.t,out.e2,'r');
xlabel(OX); ylabel(OY1); title(TYTUL1);
legend("c=const","c!=const","c!=const i REG2","Location","Northeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.reg2);
xlabel(OX); ylabel(OY2); title(TYTUL2);
legend("REG2","Location","Southeast");
%}

%System 1. - zmienna b
out=sim('spc61',tk2);
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.y,'b',out.t,out.y1,'g',out.t,out.y2,'r',out.t,out.y3,'k');
xlabel(OX); ylabel(OY); title(TYTUL);
legend("c=const","c!=const","c!=const i REG2","model","Location","Southeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.e,'b',out.t,out.e1,'g',out.t,out.e2,'r');
xlabel(OX); ylabel(OY1); title(TYTUL1);
legend("c=const","c!=const","c!=const i REG2","Location","Northeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.reg2);
xlabel(OX); ylabel(OY2); title(TYTUL2);
legend("REG2","Location","Northeast");% Nie zwróciłem uwagi, że tu jest
%Northeast
%}

%System 2. - zmienna c
q=3; a=8; b=3; c=2; tk2=100;
out=sim('spc62',tk2);
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.y,'b',out.t,out.y1,'g',out.t,out.y2,'r',out.t,out.y3,'k');
xlabel(OX); ylabel(OY); title(TYTUL);
legend("c=const","c!=const","c!=const i REG2","model","Location","Southeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.e,'b',out.t,out.e1,'g',out.t,out.e2,'r');
xlabel(OX); ylabel(OY1); title(TYTUL1);
legend("c=const","c!=const","c!=const i REG2","Location","Northeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.reg2);
xlabel(OX); ylabel(OY2); title(TYTUL2);
legend("REG2","Location","Northeast"); % Nie zwróciłem uwagi, że tu jest
%Northeast
%}

%System 3. - zmienna c
a=8; b=11; c=2; tk2=50;
out=sim('spc63',tk2);
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.y,'b',out.t,out.y1,'g',out.t,out.y2,'r',out.t,out.y3,'k');
xlabel(OX); ylabel(OY); title(TYTUL);
legend("c=const","c!=const","c!=const i REG2","model","Location","Southeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.e,'b',out.t,out.e1,'g',out.t,out.e2,'r');
xlabel(OX); ylabel(OY1); title(TYTUL1);
legend("c=const","c!=const","c!=const i REG2","Location","Northeast");
figure(L); grid on; hold on; L=L+1;
plot(out.t,out.reg2);
xlabel(OX); ylabel(OY2); title(TYTUL2);
legend("REG2","Location","Southeast");
%}