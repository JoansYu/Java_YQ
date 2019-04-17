function [energy_cost_for_G_L,time_G_L] = allocate_for_G_L(index_of_remote, device_cpu_require, device_per_energy,device_per_cpu)
%% ±æµÿº∆À„
energy_local = zeros(1,size(index_of_remote,2));
time_G_L = zeros(1,size(index_of_remote,2));
for i=1:size(index_of_remote,2)
    if (index_of_remote(i) ~= 1)
        continue
    end
    energy_local(i) = device_cpu_require(i).*device_per_energy(i);
    time_G_L(i) = device_cpu_require(i)./device_per_cpu(i);
end
energy_cost_for_G_L = sum(energy_local);
time_G_L = sum(time_G_L);


