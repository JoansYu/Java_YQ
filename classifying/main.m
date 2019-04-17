clc;
close all;
clear all;
warning off;

%% ��������
Number = 50; %�豸����
K = 50; % ÿ����վ��50�������ŵ�
W = 5e6; %���ŵ�����5MHz
CR = 4; %��λGHZ/sec MEC��������
Delta_R = 1; %��λW/GHZ MEC���ܺ�
Fai = 0.0001; %��λ sec/KB �ش�ϵ��
C = 0.1*randi([1,10],Number,1)'*1e9; %�豸�������������CPU����������ֲ���0.1 ~ 1ghz֮��
FR = 4e9; %MEC��CPUƵ��HZ
FL = 0.1*randi([1,10],Number,1)'*1e9; %�豸CPU��Ƶ��
T_max = 0.1*randi([1,10],Number,1)'; %���ʱ��/s
deltaL = 1./randi([900*1e6,1050*1e6],Number,1)'; %�����ܺ�  w/HZ
deltaR = 1*1E-9; % MEC�ܺ� w/HZ
ER = C.*deltaR; % MEC������������
FileSize = randi([300,800],Number,1)*1e3; %�ļ��Ĵ�С��bit
Tao = 0.1*randi([5,10],Number,1); %���ʱ�ӣ�sec

PM = 4E-8; %MBS����
PD = 0.5E-8; %??????w
N0 = 1E-17; %����������w

%% �������
%---1000*1000�������������Number���ƶ��豸
i = 0;
while (i < Number)
    i = i+1;
    x(i) = 1000*rand;
    y(i) = 1000*rand;
    hold on
    plot(x,y,'r.');
end
hold off

%% �豸����
i = 1;
j = 1;
m = 1;
n = 1;
T_sum = 0; % G0�е��ܵ�ʱ��
E_sum = 0; % G0���ܵ��ܺ�
while(i < Number+1)
    TL(i) = C(i)./FL(i);
    EL(i) = C(i).*deltaL(i);
    if (TL(i)>T_max(i))
        omega_R(j) = i;
        j=j+1;
    else if (TL(i)<=T_max(i))
            %����������ŵ���
            N(i)=ceil(FileSize(i)/((T_max(i)-C(i)/FR)*W*log2(1+PM*1/N0)));
            if EL(i)<(PM*N(i)+ER(i))&&EL(i)<(PD*N(i)+ER(i))
                omega_L(m) = i;
                m=m+1;
            else
                omega_O(n) = i;
                n=n+1;
                T_sum = T_sum + Tao(i);
                E_sum = E_sum + EL(i) - C(i)*deltaR; %%????????????????????
                
            end
        end
    end
    i = i+1;
end

%% �������ȼ�
Length = size(omega_O,2);
i = 1;
while(Length>0)
   P(i)= 0.4*(Tao(omega_O(i))/T_sum)+0.6*(E_sum/(EL(omega_O(i))-C(omega_O(i))*deltaR));
   i = i+1;
   Length = Length-1;
end





%% ��Դ����




%% EECO�㷨





