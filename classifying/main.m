clc;
close all;
clear all;
warning off;

%% 参数设置
Number = 50; %设备数量
K = 50; % 每个基站有50个正交信道
W = 5e6; %子信道带宽5MHz
CR = 4; %单位GHZ/sec MEC计算能力
Delta_R = 1; %单位W/GHZ MEC的能耗
Fai = 0.0001; %单位 sec/KB 回传系数
C = 0.1*randi([1,10],Number,1)'*1e9; %设备计算任务所需的CPU周期数随机分布在0.1 ~ 1ghz之间
FR = 4e9; %MEC的CPU频率HZ
FL = 0.1*randi([1,10],Number,1)'*1e9; %设备CPU的频率
T_max = 0.1*randi([1,10],Number,1)'; %最大时延/s
deltaL = 1./randi([900*1e6,1050*1e6],Number,1)'; %本地能耗  w/HZ
deltaR = 1*1E-9; % MEC能耗 w/HZ
ER = C.*deltaR; % MEC计算任务消耗
FileSize = randi([300,800],Number,1)*1e3; %文件的大小，bit
Tao = 0.1*randi([5,10],Number,1); %最大时延，sec

PM = 4E-8; %MBS功率
PD = 0.5E-8; %??????w
N0 = 1E-17; %白噪声功率w

%% 随机撒点
%---1000*1000区域内随机撒点Number个移动设备
i = 0;
while (i < Number)
    i = i+1;
    x(i) = 1000*rand;
    y(i) = 1000*rand;
    hold on
    plot(x,y,'r.');
end
hold off

%% 设备分类
i = 1;
j = 1;
m = 1;
n = 1;
T_sum = 0; % G0中的总的时延
E_sum = 0; % G0中总的能耗
while(i < Number+1)
    TL(i) = C(i)./FL(i);
    EL(i) = C(i).*deltaL(i);
    if (TL(i)>T_max(i))
        omega_R(j) = i;
        j=j+1;
    else if (TL(i)<=T_max(i))
            %计算所需的信道数
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

%% 设置优先级
Length = size(omega_O,2);
i = 1;
while(Length>0)
   P(i)= 0.4*(Tao(omega_O(i))/T_sum)+0.6*(E_sum/(EL(omega_O(i))-C(omega_O(i))*deltaR));
   i = i+1;
   Length = Length-1;
end





%% 资源分配




%% EECO算法





