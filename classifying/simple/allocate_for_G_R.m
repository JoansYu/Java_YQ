function [energy_cost_for_G_R,time_cost_for_G_R] = allocate_for_G_L(channel_MBS, channel_SBS, index_of_remote, p_M, p_S, channel_M, channel_S, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file, K )
%% 远程卸载
index_of_access = zeros(1,size(index_of_remote,2));
energy_remote = zeros(1,size(index_of_remote,2));
time_cost_for_G_R = zeros(1,size(index_of_remote,2));
energy = zeros(2,size(index_of_remote,2));
time = zeros(2,size(index_of_remote,2));
% device_cpu_require = sort(device_cpu_require);
% server_cpu = (sort(server_cpu));
for i=1:size(index_of_remote,2)
    if (index_of_remote(i) ~= 2)
        continue
    end
    %初始化用户i的选用信道集合
    %channel_number_set_of_ue_i = [];
    
    %在channel_M中，选择SINR最大的信道"并且是未分配的信道"
    %输入参数中，user_id(=i)为哪个用户去挑最大SINR信道
    %其返回值中channel_number为信道号
    channel_number_of_mbs = select_SINR_MBS_channel(channel_MBS, channel_SBS,i, p_M, p_S, channel_M, channel_S, sigma,K );
    if (channel_number_of_mbs == -1)
        ;%error('2');
    end
    %在channel_S中，选择SINR最大的信道"并且是未分配的信道"
    %输入参数中，user_id为哪个用户去挑最大SINR信道
    %其返回值中channel_number为信道号
    channel_number_of_sbs = select_SINR_SBS_channel(channel_MBS, channel_SBS,i, p_M, p_S, channel_M, channel_S, sigma,K );
    if (channel_number_of_sbs == -1)
        %error('3');
    end
    
    if ((channel_number_of_mbs == -1)&&(channel_number_of_sbs == -1))
        continue
    end
    
    %选择二者（channel_number_of_mbs，channel_number_of_sbs）中（在channel_M中在channel_S中）的最大，根据该信道归属，确定index_of_access
    comp_result = 0;     %用于比较的变量  0=尚未比较，1=MBS大，2=SBS大
    sinr_mbs = [];       %用于比较的变量
    sinr_sbs = [];       %用于比较的变量
    sinr_mbs(size(channel_MBS,2)) = 0;
    sinr_sbs(size(channel_SBS,2)) = 0;
    if (channel_number_of_mbs ~= -1)
        %无干扰
        if (( channel_MBS(channel_number_of_mbs) == 0 ) && ( channel_SBS(channel_number_of_mbs) == 0 ))
            %sinr_mbs(channel_number_of_mbs) = p^M_i g^M_i / delta2;% save sinr of subcarrier i in ith element in the set of sinr_result.
            sinr_mbs(channel_number_of_mbs) = p_M(1,i)*channel_M(1,i)/ sigma;
            %有干扰
        elseif (( channel_MBS(channel_number_of_mbs) == 0 ) && ( channel_SBS(channel_number_of_mbs) ~= 0 )) %device with id== 'channel_SBS(i)' can cause interference
            %sinr_mbs(channel_number_of_mbs) = p^M_i g^M_i / ( p^S_{channel_SBS(i)} g^S_{channel_SBS(i)} + delta2);
            sinr_mbs(channel_number_of_mbs) = p_M(1,i)*channel_M(1,i)/(  p_S(1,channel_SBS(1,channel_number_of_mbs))*channel_S(1,channel_SBS(1,channel_number_of_mbs)) + sigma);
        else
            sinr_mbs(channel_number_of_mbs) = -1;
        end
    end
    
    if (channel_number_of_sbs ~= -1)
        %无干扰
        if (( channel_SBS(channel_number_of_sbs) == 0 ) && ( channel_MBS(channel_number_of_sbs) == 0 ))
            %sinr_sbs(channel_number_of_sbs) = p^M_i g^M_i / delta2;% save sinr of subcarrier i in ith element in the set of sinr_result.
            sinr_sbs(channel_number_of_sbs) = p_S(1,i)*channel_S(1,i)/ sigma;
            %有干扰
        elseif (( channel_SBS(channel_number_of_sbs) == 0 ) && ( channel_MBS(channel_number_of_sbs) ~= 0 )) %device with id== 'channel_SBS(i)' can cause interference
            %sinr_sbs(channel_number_of_sbs) = p^M_i g^M_i / ( p^S_{channel_SBS(i)} g^S_{channel_SBS(i)} + delta2);
            sinr_sbs(channel_number_of_sbs) = p_S(1,i)*channel_S(1,i)/(  p_M(1,channel_MBS(1,channel_number_of_sbs))*channel_M(1,channel_MBS(1,channel_number_of_sbs)) + sigma);
        else
            sinr_sbs(channel_number_of_sbs) = -1;
        end
    end
    
%     disp('**** sinr *********************before')
%     disp(sinr_mbs(channel_number_of_mbs))
%     disp(sinr_sbs(channel_number_of_sbs))
    if ((channel_number_of_mbs ~= -1)&&(channel_number_of_sbs ~= -1))
        %比较
        if ( (sinr_mbs(channel_number_of_sbs) ~= -1) && (sinr_mbs(channel_number_of_sbs) ~= -1) )
            if ( sinr_mbs(channel_number_of_mbs) >= sinr_sbs(channel_number_of_sbs))       %1=MBS大
                comp_result = 1;
                %进行信道分配标记
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                channel_MBS(channel_number_of_mbs) = i;
            elseif ( sinr_mbs(channel_number_of_mbs) < sinr_sbs(channel_number_of_sbs))    %2=SBS大
                comp_result = 2;
                %进行信道分配标记
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                channel_SBS(channel_number_of_sbs) = i;
            else
                comp_result = 0;
                error('4');
            end
        end
    else
        if (channel_number_of_mbs == -1)
            comp_result == 2
        elseif (channel_number_of_sbs == -1)
            comp_result == 1
        end
    end
    
    
    
    if (comp_result == 1)
        index_of_access(i) = 1; %各用户接入归属，其中0=尚未选择接入BS，1=接入MBS，2=接入SBS
    elseif (comp_result == 2)
        index_of_access(i) = 2; %各用户接入归属，其中0=尚未选择接入BS，1=接入MBS，2=接入SBS
    else
        index_of_access(i) = -1;%各用户接入归属，其中0=尚未选择接入BS，1=接入MBS，2=接入SBS
        continue %error('5');
    end
    
%     % 计算能耗和时间
%     if (index_of_access(i) == 1)        % if device i attach to mbs        
%         R_mi = 0 ;
%         %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，        
%         if ((size(find(channel_MBS == i),2) == 1))            
%             if (channel_SBS(1,find(channel_MBS == i,1)) == 0) % no device on the same subcarrier of sbs                
%                 R_mi = R_mi + W*log2(1+p_M(1,i)*channel_M(1,i)/sigma);
%             elseif (channel_SBS(1,find(channel_MBS == i,1)) >0) % one device(id=channel_S(1,find(channel_MBS == i,1))) on the same subcarrier of sbs               
%                 channel_SBS(1,find(channel_MBS == i,1));
%                 R_mi = R_mi + W*log2(1+p_M(1,i)*channel_M(1,i)/( p_S(1,channel_SBS(1,find(channel_MBS == i,1)))*channel_S(1,channel_SBS(1,find(channel_MBS == i,1))) + sigma));
%             end
%         else
%             error('6');
%         end
%         time(1) =  file(1,i)/R_mi+device_cpu_require(1,i)/server_cpu(1,i);  
%     elseif (index_of_access(i) == 2)    % if device i attach to sbs      
%         R_si = 0 ;
%         %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
%         if ((size(find(channel_SBS == i),2) == 1))
%             % if only one subcarrier (=find(channel_SBS == i,1)) allocated to device i
%             if (channel_M(1,find(channel_SBS == i,1)) == 0) % no device on the same subcarrier of msb
%                 %R_mi = R_mi + find(channel_MBS == i,1)
%                 R_si = R_si + W*log2(1+p_S(1,i)*channel_S(1,i)/sigma);
%             elseif (channel_S(1,find(channel_MBS == i,1)) >0) % one device(id=channel_S(1,find(channel_MBS == i,1))) on the same subcarrier of sbs
%                 %R_mi = R_mi + find(channel_MBS == i,1)
%                 R_si = R_si + W*log2(1+p_S(1,i)*channel_S(1,i)/( p_M(1,channel_MBS(1,find(channel_SBS == i,1)))*channel_M(1,channel_MBS(1,find(channel_SBS == i,1))) + sigma));
%             end
%         else
%                     error('7');
%         end
%         time(2) = file(1,i)/R_si+file(1,i)/varphi+device_cpu_require(1,i)/server_cpu(1,i);       
%     end 
    
    %4、当所有G_R用户全部选择完毕，或信道资源耗尽，计算G_R用户消耗总能量，并返回更新后的channel_MBS和channel_SBS
        % save each user's energy  
        % energy(1,:) mbs energy for all users
        % energy(2,:) sbs energy for all users
        energy=[];
        energy(2,size(index_of_remote,2)) = 0; % total users: size(index_of_remote,2) 
        time(2,size(index_of_remote,2)) = 0; % total users: size(index_of_remote,2) 

        %首先顺序遍历各G_R(3=Remote)用户，i是用户的id
        for uid = 1:size(index_of_remote,2)     
            if (index_of_remote(uid) ~= 2)            
                continue
            end
            tmp = [];
            %3、判断是否满足时延条件，若满足，停止本次循环，进入下一用户；若不满足，继续在接入选择的BS中继续选择次大SINR信道    
            if (index_of_access(uid) == 1)        % if device uid attach to mbs
                %time(1) = %t^M_i=d_i/r^M_i+c_i/f^R_0            
                R_mi = 0 ; 
                %disp('****');   
                %disp(uid)
                %disp(find(channel_MBS == uid))
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                if ((size(find(channel_MBS == uid),2) > 0)) 
                %disp('energy here ****');                    
                    % at least one subcarriers (subcarrier id = tmp(i) allocated to device i
                    tmp = find(channel_MBS == uid);
                    for i = 1:size(find(channel_MBS == uid),2)
                        %tmp(i) %subcarrier id
                        if (channel_SBS(1,tmp(i)) == 0) % no device on the same subcarrier of sbs
                            %R_mi = R_mi + find(channel_MBS == i,1)
                            R_mi = R_mi + W*log2(1+p_M(1,uid)*channel_M(1,uid)/sigma);
                        elseif (channel_SBS(1,tmp(i)) >0) % one device(id=channel_S(1,find(channel_MBS == i,1))) on the same subcarrier of sbs
                            %R_mi = R_mi + find(channel_MBS == i,1)
                            R_mi = R_mi + W*log2(1+p_M(1,uid)*channel_M(1,uid)/( p_S(1,channel_SBS(1,tmp(i)))*channel_S(1,channel_SBS(1,tmp(i))) + sigma));
                        else
                            error('13'); 
                        end
                    end
                    % energy(1,:) mbs energy for  user i
                    % e_mi=b_i p_i d_i/r_mi +c_ideltaR
                    energy(1,uid) = size(find(channel_MBS == uid),2)*p_M(1,uid)*file(1,uid)/R_mi + device_cpu_require(1,uid)*server_energy(1,uid);
                    time(1,uid) =  file(1,i)/R_mi+device_cpu_require(1,i)/server_cpu(i);
                else 
                    error('14'); 
                end
                
            elseif (index_of_access(uid) == 2)    % if device i attach to sbs
                %time(2) = %t^S_i=d_i/r^S_i+d_i\phi+c_i/f^R_0                
                R_si = 0 ;               
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                if ((size(find(channel_SBS == uid),2) > 0))
                    % at least one subcarriers (subcarrier id = tmp(i) allocated to device i
                    tmp = find(channel_SBS == uid);
                    for i = 1:size(find(channel_SBS == uid),2)
                        %tmp(i) %subcarrier id
                        if (channel_MBS(1,tmp(i)) == 0) % no device on the same subcarrier of mbs
                            %R_mi = R_mi + find(channel_MBS == i,1)
                            R_si = R_si + W*log2(1+p_S(1,uid)*channel_S(1,uid)/sigma);
                        elseif (channel_MBS(1,tmp(i)) >0) % one device on the same subcarrier of mbs
                            %R_mi = R_mi + find(channel_MBS == i,1)                            
                            R_si = R_si + W*log2(1+p_S(1,uid)*channel_S(1,uid)/( p_M(1,channel_MBS(1,tmp(i)))*channel_M(1,channel_MBS(1,tmp(i))) + sigma));
                        else
                            error('15'); 
                        end
                    end   
                    % energy(2,:) sbs energy for  user i
                    % e_mi=b_i p_i d_i/r_mi +c_ideltaR
                    energy(2,uid) = size(find(channel_SBS == uid),2)*p_S(1,uid)*file(1,uid)/R_si + device_cpu_require(1,uid)*server_energy(1,uid);
                    time(2,uid) = file(1,i)/R_si+file(1,i)*varphi+device_cpu_require(1,i)/server_cpu(i); 
                else
                    error('16');                                   
                end
            else
                % no subcarrier allocated to device i
                energy(1,uid) = 0;
                energy(2,uid) = 0;
            end
        end
end


energy_cost_for_G_R = sum(energy(1,:)) + sum(energy(2,:));
time_cost_for_G_R = sum(time(1,:)) + sum(time(2,:));


