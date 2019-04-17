function [channel_MBS, energy_cost_for_G_R,time_cost_for_G_R] = allocate_for_G_R(channel_MBS, index_of_remote, index_of_access, p_M, channel_M, device_cpu_require, device_time, server_cpu, server_energy, W, sigma, varphi, file, K )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%主算法，对应Algorithm 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%先给G_R的用户分信道
%在本函数中，首先顺序遍历各G_R用户，依次为各用户分配信道。
%1、在channel_M, channel_S中，选择"一个未分配出去的"SINR最大的信道
%2、根据该信道归属，确定index_of_access
%3、判断是否满足时延条件，若满足，停止本次循环，进入下一用户；若不满足，继续在接入选择的BS中继续选择次大SINR信道
%4、当所有G_R用户全部选择完毕，或信道资源耗尽，计算G_R用户消耗总能量，并返回更新后的channel_MBS和channel_SBS

%index_of_remote = zeros(1,user_number);
if (size(index_of_remote,2)<=0)
%初始化各用户的标志矩阵，其中标志1=Local，2=Optional， 3=Remote
    %index_of_remote has zero users
    error('1'); 
end

%首先顺序遍历各G_R(3=Remote)用户，i是用户的id
for i=1:size(index_of_remote,2)     
        if (index_of_remote(i) ~= 3)            
            continue
        end
        %初始化用户i的选用信道集合
%         channel_number_set_of_ue_i = [];  
        
        %在channel_M中，选择SINR最大的信道"并且是未分配的信道"
        %输入参数中，user_id(=i)为哪个用户去挑最大SINR信道
        %其返回值中channel_number为信道号
        channel_number_of_mbs = select_SINR_MBS_channel(channel_MBS, i, p_M, channel_M, sigma,K );
        if (channel_number_of_mbs == -1)
            ;%error('2'); 
        end                       
        %在channel_S中，选择SINR最大的信道"并且是未分配的信道"
        %输入参数中，user_id为哪个用户去挑最大SINR信道
        %其返回值中channel_number为信道号

        
        if ((channel_number_of_mbs == -1))
            continue
        end
        
        %选择二者（channel_number_of_mbs，channel_number_of_sbs）中（在channel_M中在channel_S中）的最大，根据该信道归属，确定index_of_access      
        comp_result = 0;     %用于比较的变量  0=尚未比较，1=MBS大，2=SBS大        
        sinr_mbs = [];       %用于比较的变量
        sinr_mbs(size(channel_MBS,2)) = 0;

        if (channel_number_of_mbs ~= -1)
        %无干扰  
        if (( channel_MBS(channel_number_of_mbs) == 0 ) ) 
            %sinr_mbs(channel_number_of_mbs) = p^M_i g^M_i / delta2;% save sinr of subcarrier i in ith element in the set of sinr_result.
            sinr_mbs(channel_number_of_mbs) = p_M(1,i)*channel_M(1,i)/ sigma; 
        else
            sinr_mbs(channel_number_of_mbs) = -1;
        end
        end

        

        %% add a random value to sinr of MBS
        if ((channel_number_of_mbs ~= -1))
            sinr_mbs(channel_number_of_mbs) = sinr_mbs(channel_number_of_mbs) + 80*rand(1);
        end
     
        if ((channel_number_of_mbs ~= -1))
        %比较

                comp_result = 1;
                %进行信道分配标记 
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                channel_MBS(channel_number_of_mbs) = i;
            
           
        
        end         
        comp_result = 1
        
        if (comp_result == 1)
            index_of_access(i) = 1; %各用户接入归属，其中0=尚未选择接入BS，1=接入MBS，2=接入SBS
        else
            index_of_access(i) = -1;%各用户接入归属，其中0=尚未选择接入BS，1=接入MBS，2=接入SBS
            continue %error('5'); 
        end
        
        %3、判断是否满足时延条件，若满足，停止本次循环，进入下一用户；若不满足，继续在接入选择的BS中继续选择次大SINR信道    
        if (index_of_access(i) == 1)        % if device i attach to mbs
            R_mi = 0 ;               
            if ((size(find(channel_MBS == i),2) == 1)) 
                                 
                    R_mi = R_mi + W*log2(1+p_M(1,i)*channel_M(1,i)/sigma);
               
            else
                error('6'); 
            end
            time(1) =  file(1,i)/R_mi+device_cpu_require(1,i)/server_cpu;                   
        end

        while( time(index_of_access(i)) >= device_time(1,i) )%3、判断是否满足时延条件，若满足'<='，停止本次循环，进入下一用户   %???????????是否应该改为>=
            %若不满足，继续在接入选择的BS中继续选择次大SINR信道
            if (index_of_access(i) == 1)    %若不满足，继续在MBS中继续选择"一个未分配的最大"次大SINR信道
                %在channel_M中，选择SINR最大的信道"并且是未分配的信道"
                channel_number = select_SINR_MBS_channel(channel_MBS, channel_SBS,i, p_M, p_S, channel_M, channel_S, sigma,K );                
                if (channel_number == -1)
                    break; %error('8'); 
                end
                %进行信道分配标记 
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                channel_MBS(channel_number) = i;                
                   
            else
                error('10'); 
            end                 
            
            %3、判断是否满足时延条件，若满足，停止本次循环，进入下一用户；若不满足，继续在接入选择的BS中继续选择次大SINR信道    
            if (index_of_access(i) == 1)        % if device i attach to mbs
                %time(1) = %t^M_i=d_i/r^M_i+c_i/f^R_0            
                R_mi = 0 ;               
                %初始化MBS和SBS的信道资源，0为该信道空闲，非0为被占用且对应数值分配的用户id，
                if ((size(find(channel_MBS == i),2) > 1)) 
                    % at least two subcarriers (subcarrier id = tmp(i) allocated to device i
                    tmp = find(channel_MBS == i);
                    for j = 1:size(find(channel_MBS == i),2)
                        %tmp(i) %subcarrier id
                        if (channel_SBS(1,tmp(j)) == 0) % no device on the same subcarrier of sbs
                            R_mi = R_mi + W*log2(1+p_M(1,i)*channel_M(1,i)/sigma);
                        elseif (channel_SBS(1,tmp(j)) >0) % one device(id=channel_S(1,find(channel_MBS == i,1))) on the same subcarrier of sbs
                            R_mi = R_mi + W*log2(1+p_M(1,i)*channel_M(1,i)/( p_S(1,channel_SBS(1,tmp(j)))*channel_S(1,channel_SBS(1,tmp(j))) + sigma));
                        else
                            error('11'); 
                        end
                    end
                    time(1) =  file(1,i)/R_mi+device_cpu_require(1,i)/server_cpu;  
                    
                end
            end
        end
end


%4、当所有G_R用户全部选择完毕，或信道资源耗尽，计算G_R用户消耗总能量，并返回更新后的channel_MBS和channel_SBS
        energy=[];
        energy(2,size(index_of_remote,2)) = 0; % total users: size(index_of_remote,2) 
        time(2,size(index_of_remote,2)) = 0; % total users: size(index_of_remote,2) 

        %首先顺序遍历各G_R(3=Remote)用户，i是用户的id
        for uid = 1:size(index_of_remote,2)     
            if (index_of_remote(uid) ~= 3)            
                continue
            end
            tmp = [];
            %3、判断是否满足时延条件，若满足，停止本次循环，进入下一用户；若不满足，继续在接入选择的BS中继续选择次大SINR信道    
            if (index_of_access(uid) == 1)        % if device uid attach to mbs
                R_mi = 0 ; 
                if ((size(find(channel_MBS == uid),2) > 0)) 
                    % at least one subcarriers (subcarrier id = tmp(i) allocated to device i
                    tmp = find(channel_MBS == uid);
                    for i = 1:size(find(channel_MBS == uid),2)
                       
                            R_mi = R_mi + W*log2(1+p_M(1,uid)*channel_M(1,uid)/sigma);
                        
                    end
                    energy(1,uid) = size(find(channel_MBS == uid),2)*p_M(1,uid)*file(1,uid)/R_mi + device_cpu_require(1,uid)*server_energy;
                    time(1,uid) =  file(1,i)/R_mi+device_cpu_require(1,i)/server_cpu;
                else 
                    error('14'); 
                end
                
            else
                % no subcarrier allocated to device i
                energy(1,uid) = 0;
                energy(2,uid) = 0;
            end
        end
       energy_cost_for_G_R = sum(energy(1,:)) + sum(energy(2,:));
       time_cost_for_G_R = sum(time(1,:)) + sum(time(2,:));
%  disp('$$$$$$$$ channel')
%  disp(channel_MBS)
%  disp(channel_SBS)











