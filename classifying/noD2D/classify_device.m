function [index_of_remote] = classify_device(p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file, K, device_per_cpu, device_per_energy )
%% 算法1 设备分类算法

for i = 1:K
    time(i) = device_cpu_require(i)./device_per_cpu(i);
    energy(i) = device_cpu_require(i).*device_per_energy(i);
    if (time(i)>device_time(i))
        index_of_remote(i) = 3;
    else if (time(i)<=device_time(i))
            %计算所需的信道数
            n_mbs(i)=ceil(file(i)/((device_time(i)-device_cpu_require(i)/server_cpu)*W*log2(1+p_M(i)*channel_M(i)/sigma)));
            n_sbs(i)=ceil(file(i)/((device_time(i)-device_cpu_require(i)/server_cpu-file(i)*varphi)*W*log2(1+p_S(i)*channel_S(i)/sigma)));
            ems(i) = p_M(i)*n_mbs(i)+server_energy*W/1e9;
            ess(i) = p_S(i)*n_sbs(i)+server_energy*W/1e9;
            e_s(i) = min(ems(i),ess(i));
            if energy(i)<=e_s(i)
                index_of_remote(i) = 1;
            else
                index_of_remote(i) = 2;
            end
        end
    end
end
end