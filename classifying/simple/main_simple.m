clc;
close all;
clear all;
warning off;

%% Parameter set

K = 10:10:100; %
Frame = 100;
time_sum = zeros(1,length(K));
time_ave = zeros(1,length(K));
energy_sum = zeros(1,length(K));
energy_ave = zeros(1,length(K));

for k = 1: length(K)
    for iframe = 1:Frame
        channel_MBS = zeros(1,K(k));
        channel_SBS = zeros(1,K(k));
        index_of_access = zeros(1,K(k));
        p_M = 0.1*rand(1,K(k));
        p_S = 0.05*rand(1,K(k));
        device_cpu_require = 0.01*randi([1,100],K(k),1)';
        %         device_cpu_require = [0.04,0.09,0.10,0.03,0.02,0.06,0.02,0.01,0.02,0.05];
        %         device_cpu_require = repmat(device_cpu_require,1,K(k)/10);
        device_time = 0.1*randi([1,10],K(k),1)'; %最大时延/s
        %         device_time = [0.90,0.20,0.80,1,1,0.30,0.20,0.60,0.20,0.40];
        %         device_time = repmat(device_time,1,K(k)/10);
        server_cpu = 1+4*rand(1,K(k),1); %单位GHZ/sec MEC计算能力
%         server_cpu = 4*ones(1,K(k));
        device_per_cpu = 0.5*randi([5,10],K(k),1)'; %设备CPU的频率
        %         device_per_cpu = [0.04,0.04,0.07,0.07,0.09,0.01,0.02,0.02,0.07,0.04]*30;
        %         device_per_cpu = repmat(device_per_cpu,1,K(k)/10);
        server_energy = 2 + 2*rand(1,K(k),1); % w/GHZ;
        device_per_energy = 2 + 5*rand(1,K(k),1);; %本地能耗  w/GHZ
        %         device_per_energy = [1.93,2.18,3.51,3.25,2.33,2.81,4.93,2.12,3.83,2.10]/10;
        %         device_per_energy = repmat(device_per_energy,1,K(k)/10);
        W = 5e6; %%信道带宽
        sigma = (10^(-17.4)/1000)*W;
        varphi = 1e-4;
        file = randi([300,800],K(k),1)';
        %         file = [360,726,739,717,706,501,381,479,536,332]; %KHz
        %         file = repmat(file,1,K(k)/10);
   
        %% -------随机撒点------------------ %
        %---1000*1000区域内随机撒点Number个移动设备
        i = 0;
        while (i < K(k))
            i = i+1;
            X_position(i) = 100*(i/K(k));
            X_position(i) = 100 + 200*(i/K(k));
            Y_position(i) = 80*(i/K(k));
            Y_position(i) = 80 + 100*(i/K(k));
            
            %计算到MBS(31,84)和SBS（18,35）的距离
            d_MBS(i) = sqrt((X_position(i)-31)^2+(Y_position(i)-84)^2);
            d_SBS(i) = sqrt((X_position(i)-18)^2+(Y_position(i)-35)^2);
            
            %计算channel_M，channel_S
            
            channel_M(i) = 10^(-(128.1+37.6*log(d_MBS(i)/1000))/10);  %Path loss
            channel_S(i) = 10^(-(128.1+37.6*log(d_SBS(i)/1000))/10);
            
        end
        
        %% main process
        % 算法1 classify device
        index_of_remote = classify_device(p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file, K(k), device_per_cpu, device_per_energy );
%         index_of_remote = ones(1,K(k));
        
        % 计算能耗
        % energy cost for G_L
        [energy_cost_for_G_L time_G_L] = allocate_for_G_L(index_of_remote, device_cpu_require, device_per_energy,device_per_cpu)
        [energy_cost_for_G_R time_G_R] = allocate_for_G_R(channel_MBS,channel_SBS, index_of_remote, p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file, K(k) )
        time_sum(k) = time_sum(k) + time_G_L + time_G_R;
        energy_sum(k) = energy_sum(k) + energy_cost_for_G_L + energy_cost_for_G_R;
    end
    time_ave(k) = time_sum(k)/Frame;
    energy_ave(k) = energy_sum(k)/Frame;
end

figure(1)
plot(K,time_ave,'bo-');
figure(2)
plot(K,energy_ave,'kv-');