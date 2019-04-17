clc;
close all;
clear all;
warning off;

%-----提出的分类算法的结果------%
N1 = 10:10:100;  %% 全部远程计算卸载的能耗
Energy1 = [0.2800 0.4400 0.7200 0.8800 1.1600 1.3200 1.600 1.7600 2.040 2.2000];
line1 = plot(N1,Energy1,'ro-');
xlabel('Number of mobile devices')
ylabel('Energy consumption(J)')
legend()
hold on
grid on;


N2 = N1;  %% 全部本地计算的能耗
Energy2= [0.6943 1.3885 2.0828 2.7770 3.4713 4.1655 4.8598 5.5540 6.2482 6.9425];
line2 = plot(N2,Energy2,'b^-');

% N3 = N1;  %% 本地+远程
% Energy3 = [0.3905 0.7818 1.1726 1.5638 1.9547 2.3468 2.7363 3.1283 3.5178 3.9115];
% line3 = plot(N3,Energy3,'kv-');

N3 = N1;  %% 本地+远程+选择
Energy4 = [0.3905 0.7818 1.1726 1.5638 1.9547 2.3468 2.7363 3.1283 3.5178 3.9115];
line3 = plot(N3,Energy4,'kv-');
legend([line1,line2,line3],'The proposed algorithm','Computing without offloading','Offloading with classify devices','Location','northwest')


N4 = N1;
% Time3 =[0.8389 1.1075 1.6402 1.9089 2.4601 2.7867 3.3491 4.0266 4.8501 5.2875]
figure(2)
% plot(N4,Time3,'ko-')
hold on
Time2 = [0.5511 0.9967 1.5021 1.9477 2.4532 2.8988 3.4042 3.8498 4.3552 4.8008]
plot(N4,Time2,'bv-')
Time1 = [0.3788 0.7577 1.3365 1.7153 2.2942 2.7730 3.2019 3.7307 4.2095 4.6884]
plot(N4,Time1,'mp-')
grid on

