% SPC-LAB3
% Konrad Białek 248993
 
%clear; % ze względu na budowę programu i proces wypełniania macierzy kopt*
        % nie można użyć tego polecenia
clc; close all; 
 
%% definicja systemów
a=[0,5,14,0];
b=[2,8,2,3.5];
c=[7,3,1,0]; 
SYS=[tf([1],[a(1) b(1) c(1)]);             
    tf([1],[a(2) b(2) c(2)]);  
    tf([1],[a(3) b(3) c(3)]);   
    tf([1],[a(4) b(4) c(4)])]; 
 
%% sygnał pobudzający
c1=4;
y0=c1*1;
    
k0p=[0];
k0pi=[0,0];
k0pid=[0,0,0];
 
%% Uwaga: linie 31-48 należy odpowiednio odkomentować i zakomentować w taki
% sposób, żeby wypełnić macierze kopt* z linii 46-48, a następnie narysować
% wykresy, odkomentowano obsługę systemu 2. jako przykład.
% Jednocześnie należy też odpowiednio ustawić zmienne wyboru obiektu 'i' 
% wewnątrz funkcji MISE*, ustawionio zmienne dla systemu 2. jako przykład.
 
%kopt1p=fminsearch(@MISE_P,k0p,optimset('MaxFunEvals',40)); % O. 1., P
kopt2p=fminsearch(@MISE_P,k0p,optimset('MaxFunEvals',40)); % O. 2., P
%kopt3p=fminsearch(@MISE_P,k0p,optimset('MaxFunEvals',40)); % O. 3, P
%kopt4p=fminsearch(@MISE_P,k0p,optimset('MaxFunEvals',40)); % O. 4, P
 
%kopt1pi=fminsearch(@MISE_PI,k0pi,optimset('MaxFunEvals',120)); % O. 1., PI
kopt2pi=fminsearch(@MISE_PI,k0pi,optimset('MaxFunEvals',150)); % O. 2., PI
%kopt3pi=fminsearch(@MISE_PI,k0pi,optimset('MaxFunEvals',120)); % O. 3., PI
%kopt4pi=fminsearch(@MISE_PI,k0pi,optimset('MaxFunEvals',370)); % O. 4., PI
 
%kopt1pid=fminsearch(@MISE_PID,k0pid,optimset('MaxFunEvals',250)); % O. 1., PID
kopt2pid=fminsearch(@MISE_PID,k0pid,optimset('MaxFunEvals',250)); % O. 2., PID
%kopt3pid=fminsearch(@MISE_PID,k0pid,optimset('MaxFunEvals',250)); % O. 3., PID
%kopt4pid=fminsearch(@MISE_PID,k0pid,optimset('MaxFunEvals',250)); % O. 4., PID

%koptp=[kopt1p;kopt2p;kopt3p;kopt4p];  % te 3 macierze odkomentować dopiero 
%koptpi=[kopt1pi;kopt2pi;kopt3pi;kopt4pi]; % po uzyskaniu poprzednich 12 
%koptpid=[kopt1pid;kopt2pid;kopt3pid;kopt4pid]; % zmiennych

%% rysowanie odpowiedzi układów i błędów - po wypełnieniu macierzy 
%  % poniższą pętlę zakomentować i odkomentować po uzyskaniu powyższych
  % macierzy kopt*
for L=1:12
    if(L<=4)
        sys_reg=tf(koptp(L,1));
        Kotw=sys_reg*SYS(L);
    elseif(L>4 && L<=8)
        sys_reg=tf([koptpi(L-4,1) koptpi(L-4,2)],[1 0]);
        Kotw=sys_reg*SYS(L-4);
    elseif(L>8)
        sys_reg=tf([koptpid(L-8,3) koptpid(L-8,1) koptpid(L-8,2)],[1 0]);
        Kotw=sys_reg*SYS(L-8);
    end
    if(L==3 || L==6 || L==7)
        t0=50;
    elseif(L==10 || L==12 || L==8)
        t0=20;
    elseif(L==2)
        t0=5;   
    else
        t0=1;
    end
    
    Kz=Kotw/(1+Kotw);
    Ke=1/(1+Kotw);
    [x1,t1]=step(Kz,t0);
    [x2,t2]=step(Ke,t0);
    x1=y0.*x1;
    x2=y0.*x2;
    x3=x2.^2;
    figure(L);hold on; grid on;
    subplot(311);
    plot(t1,x1,'b');
    xlabel('czas [s]'); ylabel('x'); 
    title('Odpowiedź skokowa układu automatycznej regulacji');
    subplot(312);
    plot(t2,x2,'b');
    xlabel('czas [s]'); ylabel('\epsilon'); 
    title('Błąd odpowiedzi skokowej układu automatycznej regulacji');
    subplot(313);
    plot(t2,x3,'b');
    xlabel('czas [s]'); ylabel('\epsilon^2'); 
    title('Kwadrat błędu odpowiedzi skokowej układu automatycznej regulacji');
end
%}
function e2p=MISE_P(kp) % funkcja błędu MISE regulatora P
    t0=1000; e2p=0;
    k_p=kp(1);
    
    %% deinicja obiektów
    a=[0,5,14,0];
    b=[2,8,2,3.5];
    c=[7,3,1,0];  
    i=2; % wybór obiektu - zmieniać w miarę wypełniania macierzy koptp
    %% sygnał pobudzający
    c1=4;
    y0=c1*1;
 
    %% właściwa funkcja
    sys_ob=tf([1],[a(i) b(i) c(i)]); % transmitancja obiektu
    sys_reg=tf(k_p);                 % transmitancja regulatora
    Kotw=sys_reg*sys_ob;             % transmitancja układu otwartego
    Ke=1/(1+Kotw);                   % transmitancja uchybu
    [at,tt]=step(Ke,t0);
    at=y0.*at;
    e2p=at(1).^2.*tt(1);
    for i=2:length(at)
        e2p=e2p+at(i)^2*(tt(i)-tt(i-1)); % wyznaczenie błędu MISE
    end
end
 
function e2pi=MISE_PI(kpi) % funkcja błędu MISE regulatora PI
    t0=1000; e2pi=0;
    k_i=kpi(2);
    k_p=kpi(1);
    
    %% deinicja obiektów
    a=[0,5,14,0];
    b=[2,8,2,3.5];
    c=[7,3,1,0];  
    i=2; % wybór obiektu - zmieniać w miarę wypełniania macierzy koptpi
    %% sygnał pobudzający
    c1=4;
    y0=c1*1;
 
    %% właściwa funkcja
    sys_ob=tf([1],[a(i) b(i) c(i)]); % transmitancja obiektu
    sys_reg=tf([k_p k_i],[1 0]);     % transmitancja regulatora
    Kotw=sys_reg*sys_ob;             % transmitancja układu otwartego
    Ke=1/(1+Kotw);                   % transmitancja uchybu
    [at,tt]=step(Ke,t0);
    at=y0.*at;
    e2pi=at(1).^2.*tt(1);
    for i=2:length(at)
        e2pi=e2pi+at(i)^2*(tt(i)-tt(i-1)); % wyznaczenie błędu MISE
    end
end
 
function e2pid=MISE_PID(kpid) % funkcja błędu MISE regulatora PID
    t0=1000; e2pid=0;
    k_d=kpid(3);
    k_i=kpid(2);
    k_p=kpid(1);
    
    %% deinicja obiektów
    a=[0,5,14,0];
    b=[2,8,2,3.5];
    c=[7,3,1,0];  
    i=2; % wybór obiektu - zmieniać w miarę wypełniania macierzy koptpid
    %% sygnał pobudzający
    c1=4;
    y0=c1*1;
 
    %% właściwa funkcja
    sys_ob=tf([1],[a(i) b(i) c(i)]);      % transmitancja obiektu
    sys_reg=tf([k_d k_p k_i],[1 0]);      % transmitancja regulatora
    Kotw=sys_reg*sys_ob;                  % transmitancja układu otwartego
    Ke=1/(1+Kotw);                        % transmitancja uchybu
    [at,tt]=step(Ke,t0);
    at=y0.*at;
    e2pid=at(1).^2.*tt(1);
    for i=2:length(at)
        e2pid=e2pid+at(i)^2*(tt(i)-tt(i-1)); % wyznaczenie błędu MISE
    end
end
