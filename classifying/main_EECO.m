close all;
clear all;
clc;
warning off;

%% 参数设置
Frame = 50;
K = 100:10:200;
time_sum = zeros(1,length(K));
time_ave = zeros(1,length(K));
energy_sum = zeros(1,length(K));
energy_ave = zeros(1,length(K));
time_sum1 = zeros(1,length(K));
time_ave1 = zeros(1,length(K));
energy_sum1 = zeros(1,length(K));
energy_ave1 = zeros(1,length(K));
for k =1 :length(K)
    for j = 1:Frame
        % -------随机撒点------------------ %
        %---1000*1000区域内随机撒点Number个移动设备
        i = 0;
        while (i < K(k))
            i = i+1;
            X_position(i) = 100*(i/K(k));
            X_position(i) = 100 + 200*(i/K(k));
            Y_position(i) = 80*(i/K(k));
            Y_position(i) = 80 + 100*(i/K(k));
            %计算到MBS(31,84)和SBS（18,35）的距离
            d_MBS(i) = sqrt((X_position(i)-0)^2+(Y_position(i)-0)^2);
            d_SBS(i) = sqrt((X_position(i)-55)^2+(Y_position(i)-140.8)^2);
            
            %计算channel_M，channel_S
            W = 5e6; %%信道带宽
            channel_M(i) = 10^(-(128.1+37.6*log(d_MBS(i)/1000))/10);  %Path loss
            channel_S(i) = 10^(-(160+37.6*log(d_SBS(i)/1000))/10);
%             channel_S(i) = 10^(-(0+40*log(d_SBS(i)/1000)+30*log(W))/10);
        end
        
        
        index_of_remote = 1*ones(1,K(k));
        channel_MBS = zeros(1,K(k));
        channel_SBS = zeros(1,K(k));
        index_of_access = zeros(1,K(k));
        p_M = 0.01*ones(1,K(k));
        p_S = 0.05*ones(1,K(k));
        device_cpu_require = 0.01*randi([1,10],K(k),1)';
        
        device_time = 0.1*randi([1,10],K(k),1)'; %最大时延/s
        server_cpu = 4; %单位GHZ/sec MEC计算能力
        device_per_cpu = 0.1*randi([1,10],K(k),1)'; %设备CPU的频率
        server_energy = 1.3;
        device_per_energy = 350*(1./randi([250 350],K(k),1)'); %本地能耗  w/GHZ
        %         device_per_energy = 20*rand(K(k),1);
        sigma = (10^(-17.4)/1000)*W;
        varphi = 1e-5;
        file = randi([300,800],K(k),1)';
        file = 300*ones(K(k),1)';
        
        %%
        % 算法1 classify device
        index_of_remote = classify_device(p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file, K(k), device_per_cpu, device_per_energy );
        % 计算能耗
        % energy cost for G_L
        [energy_cost_for_G_L(k) time_G_L(k)] = allocate_for_G_L(index_of_remote, device_cpu_require, device_per_energy,device_per_cpu);
        [channel_MBS, channel_SBS, energy_cost_for_G_R(k),time_G_R(k)] = allocate_for_G_R(channel_MBS, channel_SBS, index_of_remote, index_of_access, p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file,K(k));
        [channel_MBS, channel_SBS, energy_cost_for_G_O(k),time_G_O(k)] = allocate_for_G_O(channel_MBS, channel_SBS, index_of_remote, index_of_access, p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file,K(k),device_per_energy,device_per_cpu)
        
        time_sum(k) = time_sum(k) + time_G_L(k) + time_G_R(k) + time_G_O(k);
        %         time_sum(k) = time_sum(k) + time_G_L(k) + time_G_R(k);
        energy_sum(k) = energy_sum(k) + energy_cost_for_G_L(k) + energy_cost_for_G_R(k) + energy_cost_for_G_O(k);
        %         energy_sum(k) = energy_sum(k) + energy_cost_for_G_L(k) + energy_cost_for_G_R(k) ;
        disp(['Frame:',num2str(j),'  K:',num2str(K(k))]);
        disp('$$$$$$$$ channel')
        disp(channel_MBS)
        disp(channel_SBS)
       
    end
    time_ave(k) = time_sum(k)/Frame;
    energy_ave(k) = energy_sum(k)/Frame;

end

figure(1)
line_time = plot(K,time_ave,'-o','Color',[0 0.9 0.3],'linewidth',2);
legend('fai = 1e-4');
title('系统计算卸载所用时间')
xlabel('移动智能设备/个')
ylabel('系统总时延/秒')
grid on;
hold on;
figure(2)
line_energy = plot(K,energy_ave,'-v','Color',[0.35 0.6 0.96],'linewidth',2);
title('系统计算卸载消耗的能耗')
grid on;
legend('server-energy=1.3J/GHz')
hold on;
xlabel('移动智能设备/个')
ylabel('系统总能耗/焦耳')

