% SPC-LAB1
% Konrad Białek 248993
 
clear; clc; close all;
 
%% deinicja systemów
a=[0,0,0,0,0,0,0,8,7,5]; 
b=[12,9,36,17,3,2,15,0,9,28]; 
c=[0,0,2,27,0,7,4,0,2,1]; 
d=[0,3,26,6,5,0,9,3,20,5]; 
e=[7,4,44,3,0,0,0,2,24,-14];
 
%% odpowiedzi step() i impulse()
for L=1:10
    sys=tf([a(L) b(L)],[c(L),d(L),e(L)]);
    figure(L); hold on; grid on;
    subplot(121);
    pzmap(sys);
    subplot(222);
    step(sys);
    subplot(224);
    impulse(sys);
end
 
%% zależność odpowiedzi od  biegunów i zer transmitancji
clear a; clear b; clear c; clear d; clear e;
for k=1:9
    if k==1
        a=[0,0,0,0];
        b=[12,5,0,0]; 
        c=[0,0,0,1];
        d=[0,0,0,0];
        e=[7,17,2,0];        
    elseif k==2
        a=[0,0,0,0];
        b=[9,9,9,9]; 
        c=[0,0,0,0];
        d=[3,2,1,1];
        e=[4,5,14,-2];        
    elseif k==3
        a=[0,0,0,0]; 
        b=[36,36,36,36]; 
        c=[2,1,1,1]; 
        d=[26,11,17,3]; 
        e=[44,18,70,-40];            
    elseif k==4
        a=[0,0,0,0]; 
        b=[17,17,17,17]; 
        c=[27,27,27,27]; 
        d=[15,12,5,0.5]; 
        e=[3,3,3,3];        
    elseif k==5
        a=[0,0,0,0];
        b=[3,3,3,3]; 
        c=[0,0,0,0];
        d=[5,6,20,1];
        e=[0,0,0,0];        
    elseif k==6
        a=[0,0,0,0];
        b=[3,3,3,3]; 
        c=[7,8,30,1];
        d=[0,0,0,0];
        e=[0,0,0,0];     
    elseif k==7
        a=[0,0,0,0];
        b=[15,15,15,15]; 
        c=[4,4,8,4];
        d=[9,20,9,-2];
        e=[0,0,0,0];       
    elseif k==8
        a=[8,8,8,8];
        b=[0,0,0,0];
        c=[0,0,0,0];
        d=[3,3,12,3];
        e=[2,20,2,-5];      
    elseif k==9
        a=[7,7,4,7];
        b=[9,-3,17,9];
        c=[2,2,2,1];
        d=[20,20,20,-1];
        e=[48,48,48,6];       
    end
        
    sys1=tf([a(1) b(1)],[c(1),d(1),e(1)]);
    sys2=tf([a(2) b(2)],[c(2),d(2),e(2)]);
    sys3=tf([a(3) b(3)],[c(3),d(3),e(3)]);
    sys4=tf([a(4) b(4)],[c(4),d(4),e(4)]);    
    figure(k+10); hold on; grid on;
    subplot(131);
    pzmap(sys1,'k',sys2,'r',sys3,'b',sys4,'m');
    subplot(232);
    step(sys1,'k',sys2,'r',sys3,'b');
    subplot(235);
    impulse(sys1,'k',sys2,'r',sys3,'b');
    legend('sys1','sys2','sys3','location','northeast');
    subplot(233);
    step(sys4,'m');
    subplot(236);
    impulse(sys4,'m');
    legend('sys4','location','northwest');
end
 
%% deinicja systemów
a=[0,0,0,0,0,0,0,8,7,5]; 
b=[12,9,36,17,3,2,15,0,9,28]; 
c=[0,0,2,27,0,7,4,0,2,1]; 
d=[0,3,26,6,5,0,9,3,20,5]; 
e=[7,4,44,3,0,0,0,2,24,-14];
 
%% pobudzenie sygnałem U[0,1] i U[0,1]+sin(2*pi*(1+1.005*t).*t)
 
t=(0:0.001:0.999)';
for m=1:10
    sys=tf([a(m) b(m)],[c(m),d(m),e(m)]);
    figure(m+19); hold on; grid on;
    subplot(121);
    pzmap(sys);
    subplot(222);
    u=rand(1000,1);
    lsim(sys,u,t);  
    subplot(224);    
    u=u+sin(2*pi*(1+1.005*t).*t);
    lsim(sys,u,t);
end

