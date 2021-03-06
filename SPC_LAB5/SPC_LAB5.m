% SPC-LAB5
% Konrad Białek 248993
 
clear; clc; close all; 
OX1='liczba pomiarów N';
OX2='wielkość zakłócenia z_n';
OY0='wyjście systemu Y_n';
OY1='jakość estymacji (błąd ||b_n^{\^off}-b||)';
OY2='jakość estymacji (błąd ||b_n^{\^on}-b||)';
TYTUL0='Wykres zależności wyjścia Y_n od wejścia U_n i zakłóceń Z_n';
TYTUL1='Wykres zależności jakości estymacji od liczby pomiarów';
TYTUL2='Wykres zależności jakości estymacji od wariancji zakłócenia';
b=[2,7,5]'; Nmax=1000; Zmax=1000; L=1;
U=rand(1,Nmax)';  % Sygnał wejściowy i zakłócenia wygenerowano wspólne dla
Z=randn(1,Nmax)'; % wszystkich badanych systemów.
% macierz wektorów wejścia Fi dla każdego systemu generowana tylko w 
%% 1. Estymator off-line w zależności od N
normaoff=zeros(Nmax,1);
Fi=[U(1:Nmax) [0; U(1:Nmax-1)] [0; 0; U(1:Nmax-2)]];
Y=Fi(1:Nmax,:)*b+Z(1:Nmax);
for N=3:Nmax
    boff=pinv(Fi(1:N,:)'*Fi(1:N,:))*Fi(1:N,:)'*Y(1:N);
    normaoff(N)=norm(boff-b);
end

figure(L); hold on; grid on; L=L+1;
plot([1:Nmax],Y,'b.'); plot([1:Nmax],U,'r.'); plot([1:Nmax],Z,'g.');
xlabel(OX1); ylabel(OY0); title(TYTUL0);
legend("Y_n","U_n","Z_n","Location","Northeast");
figure(L); hold on; grid on; L=L+1;
plot([3:Nmax],normaoff(3:Nmax)','b.');
xlabel(OX1); ylabel(OY1); title(TYTUL1);

%% 2. Estymator off-line w zależności od wariancji zakłóceń
% Fi z poprzedniej części:
% Fi=[U(1:Nmax) [0; U(1:Nmax-1)] [0; 0; U(1:Nmax-2)]];
normaoffz=zeros(Zmax,1);
for z=1:Zmax
    Yz=Fi*b+z*0.005*Z(1:Nmax); % Macierz Fi wykorzystywana jako całość, 
    boff=pinv(Fi'*Fi)*Fi'*Yz;  % więc doprecyzowanie Fi(1:Nmax,:) nie jest
    normaoffz(z)=norm(boff-b); % potrzebne.
end

var=((1:Zmax)'.*0.005).^2;
figure(L); hold on; grid on; L=L+1;
plot(var,normaoffz(1:Zmax)','b.');
xlabel(OX2); ylabel(OY1); title(TYTUL2);

%% 3. Estymator on-line w zależności od N; P=diag([10^1 10^1 10^1]');
bon=[0;0;0];
P=ones(3,1)*10^1; 
P0=diag(P); Pn=P0;
normaon=zeros(Nmax,1);
for n=3:Nmax
    fin=Fi(n,:)';
    Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
    en=Y(n)-fin'*bon; % wektor Y wygenerowany w części 1.
    bon=bon+Pn*fin*en;
    normaon(n)=norm(bon-b);
end

figure(L); hold on; grid on; L=L+1;
plot([3:Nmax],normaon(3:Nmax)','b.');
xlabel(OX1); ylabel(OY2); title(TYTUL1);
%% 4. Estymator on-line w zależności od N; P=diag([10^3 10^3 10^3]');
bon=[0;0;0];
P=ones(3,1)*10^3; 
P0=diag(P); Pn=P0;
normaon=zeros(Nmax,1);
for n=3:Nmax
    fin=Fi(n,:)';
    Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
    en=Y(n)-fin'*bon; % wektor Y wygenerowany w części 1.
    bon=bon+Pn*fin*en;
    normaon(n)=norm(bon-b);
end

figure(L); hold on; grid on; L=L+1;
plot([3:Nmax],normaon(3:Nmax)','b.');
xlabel(OX1); ylabel(OY2); title(TYTUL1);
%% 5. Estymator on-line w zależności od N; P=diag([10^5 10^5 10^5]');
bon=[0;0;0];
P=ones(3,1)*10^5; 
P0=diag(P); Pn=P0;
normaon=zeros(Nmax,1);
for n=3:Nmax
    fin=Fi(n,:)';
    Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
    en=Y(n)-fin'*bon; % wektor Y wygenerowany w części 1.
    bon=bon+Pn*fin*en;
    normaon(n)=norm(bon-b);
end

figure(L); hold on; grid on; L=L+1;
plot([3:Nmax],normaon(3:Nmax)','b.');
xlabel(OX1); ylabel(OY2); title(TYTUL1);

%% 6. Estymator on-line w zależności od wariancji zakłócenia; 
% P=diag([10^3 10^3 10^3]');
bon=[0;0;0];
P=ones(3,1)*10^3;
P0=diag(P); Pn=P0;
normaonz=zeros(Zmax,1);
for z=1:Zmax
    Yz=Fi*b+z*0.005*Z(1:N);
    for n=3:Nmax
        fin=Fi(n,:)';
        Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
        en=Y(n)-fin'*bon;
        bon=bon+Pn*fin*en;
    end
    normaonz(z)=norm(bon-b);
end

var=((1:Zmax)'.*0.005).^2;
figure(L); hold on; grid on; L=L+1;
plot(var,normaonz(1:Zmax)','b.');
xlabel(OX2); ylabel(OY2); title(TYTUL2);

%% Zadanie dodatkowe:
a=0.9;

%% 7. Estymator off-line w zależności od N
normaoff1=zeros(Nmax,1);
Y1=[1:Nmax]';
% Przez komponent autoregresyjny iteracyjne generowanie wartości wyjścia Y 
% jest konieczne.
Y1(1)=a*0+Fi(1,:)*b+Z(1);
for n=2:Nmax
    Y1(n)=a*Y1(n-1)+Fi(n,:)*b+Z(n);
end
YFi=[[0; Y1(1:Nmax-1)] Fi];
for N=4:Nmax
    voff=pinv(YFi(1:N,:)'*YFi(1:N,:))*YFi(1:N,:)'*Y1(1:N);
    normaoff1(N)=norm(voff-[a;b]);
end
figure(L); hold on; grid on; L=L+1;
plot([1:Nmax],Y1,'b.'); plot([1:Nmax],U,'r.'); plot([1:Nmax],Z,'g.');
xlabel(OX1); ylabel(OY0); title(TYTUL0);
legend("Y_n","U_n","Z_n","Location","Northeast");

figure(L); hold on; grid on; L=L+1;
plot([4:Nmax],normaoff1(4:Nmax)','b.');
xlabel(OX1); ylabel(OY1); title(TYTUL1);

%% 8. Estymator off-line w zależności od wariancji zakłócenia
% Fi z poprzedniej części:
%Fi=[[0; Y1(1:Nmax-1)] U(1:Nmax) [0; U(1:Nmax-1)] [0; 0; U(1:Nmax-2)]];
normaoffz1=zeros(Zmax,1);
Yz1=[1:N]';
for z=1:Zmax
    Yz1(1)=a*0+Fi(1,:)*b+z*0.005*Z(1);
    for n=2:N
        Yz1(n)=a*Yz1(n-1)+Fi(n,:)*b+z*0.005*Z(n);
    end
    YFiz=[[0; Yz1(1:N-1)] Fi];
    voff=pinv(YFiz'*YFiz)*YFiz'*Yz1;
    normaoffz1(z)=norm(voff-[a;b]);
end

var=((1:Zmax)'.*0.005).^2;
figure(L); hold on; grid on; L=L+1; 
plot(var,normaoffz1(1:Zmax)','b.');
xlabel(OX2); ylabel(OY1); title(TYTUL2);

%% 9. Estymator on-line w zależności od N; P=diag([10^3 10^3 10^3]');
von=[0;0;0;0];
P=ones(4,1)*10^3;
P0=diag(P); Pn=P0;
normaon1=zeros(Nmax,1);
for n=4:Nmax
    fin=YFi(n,:)';
    Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
    en=Y1(n)-fin'*von;
    von=von+Pn*fin*en;
    normaon1(n)=norm(von-[a;b]);
end

figure(L); hold on; grid on; L=L+1;
plot([4:Nmax],normaon1(4:Nmax)','b.');
xlabel(OX1); ylabel(OY2); title(TYTUL1);

%% 10. Estymator on-line w zależności od wariancji zakłócenia;
% P=diag([10^3 10^3 10^3]');
normaonz1=zeros(Zmax,1);
von=[0;0;0;0];
P=ones(4,1)*10^3;
P0=diag(P); Pn=P0;
Yz2=[1:N]';
for z=1:Zmax
    Yz2(1)=a*0+Fi(1,:)*b+z*0.005*Z(1);
    for n=2:N
        Yz2(n)=a*Yz2(n-1)+Fi(n,:)*b+Z(n);
    end
    YFi=[[0; Yz2(1:N-1)] Fi];
    for n=3:Nmax
        fin=YFi(n,:)';
        Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
        en=Yz2(n)-fin'*von;
        von=von+Pn*fin*en;
    end
    normaonz1(z)=norm(von-[a;b]);
end

var=((1:Zmax)'.*0.005).^2;
figure(L); hold on; grid on; L=L+1;
plot(var,normaonz1(1:Zmax)','b.');
xlabel(OX2); ylabel(OY2); title(TYTUL2);

%% Badanie innego wektora parametrów b w pierwszym systemie
b=[20,70,50]';
% Dalsza część kodu programu jest kopią punktów 1.-4. poza wektorami
% odpowiedzialnymi za zachowanie informacji o jakości estymacji.

%% 11. Estymator off-line w zależności od N
normaoff2=zeros(Nmax,1);
Fi=[U(1:Nmax) [0; U(1:Nmax-1)] [0; 0; U(1:Nmax-2)]];
Y=Fi(1:Nmax,:)*b+Z(1:Nmax);
for N=3:Nmax
    boff=pinv(Fi(1:N,:)'*Fi(1:N,:))*Fi(1:N,:)'*Y(1:N);
    normaoff2(N)=norm(boff-b);
end

figure(L); hold on; grid on; L=L+1;
plot([1:Nmax],Y,'b.'); plot([1:Nmax],U,'r.'); plot([1:Nmax],Z,'g.');
xlabel(OX1); ylabel(OY0); title(TYTUL0);
legend("Y_n","U_n","Z_n","Location","Northeast");
figure(L); hold on; grid on; L=L+1;
plot([3:Nmax],normaoff2(3:Nmax)','b.');
xlabel(OX1); ylabel(OY1); title(TYTUL1);

%% 12. Estymator off-line w zależności od wariancji zakłóceń
% Fi z poprzedniej części:
% Fi=[U(1:Nmax) [0; U(1:Nmax-1)] [0; 0; U(1:Nmax-2)]];
normaoffz2=zeros(Zmax,1);
for z=1:Zmax
    Yz=Fi*b+z*0.005*Z(1:Nmax); % Macierz Fi wykorzystywana jako całość, 
    boff=pinv(Fi'*Fi)*Fi'*Yz;  % więc doprecyzowanie Fi(1:Nmax,:) nie jest
    normaoffz2(z)=norm(boff-b); % potrzebne.
end

var=((1:Zmax)'.*0.005).^2;
figure(L); hold on; grid on; L=L+1;
plot(var,normaoffz2(1:Zmax)','b.');
xlabel(OX2); ylabel(OY1); title(TYTUL2);

%% 13. Estymator on-line w zależności od N; P=diag([10^3 10^3 10^3]');
bon=[0;0;0];
P=ones(3,1)*10^3; 
P0=diag(P); Pn=P0;
normaon2=zeros(Nmax,1);
for n=3:Nmax
    fin=Fi(n,:)';
    Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
    en=Y(n)-fin'*bon;
    bon=bon+Pn*fin*en;
    normaon2(n)=norm(bon-b);
end

figure(L); hold on; grid on; L=L+1;
plot([3:Nmax],normaon2(3:Nmax)','b.');
xlabel(OX1); ylabel(OY2); title(TYTUL1);

%% 14. Estymator on-line w zależności od wariancji zakłócenia; 
% P=diag([10^3 10^3 10^3]');
bon=[0;0;0];
P=ones(3,1)*10^3;
P0=diag(P); Pn=P0;
normaonz2=zeros(Zmax,1);
for z=1:Zmax
    Yz=Fi*b+z*0.005*Z(1:N);
    for n=3:Nmax
        fin=Fi(n,:)';
        Pn=Pn-Pn*fin*fin'*Pn./(1+fin'*Pn*fin);
        en=Y(n)-fin'*bon;
        bon=bon+Pn*fin*en;
    end
    normaonz2(z)=norm(bon-b);
end

var=((1:Zmax)'.*0.005).^2;
figure(L); hold on; grid on; L=L+1;
plot(var,normaonz2(1:Zmax)','b.');
xlabel(OX2); ylabel(OY2); title(TYTUL2);
