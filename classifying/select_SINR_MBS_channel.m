function [channel_number_of_mbs] = select_SINR_MBS_channel(channel_MBS, channel_SBS,i, p_M, p_S, channel_M, channel_S, sigma,K )
%% 选择信噪比最大MBS信道
% channel_number_of_mbs 信噪比最大的信道号


%计算SINR
% 1 查看信道是否被占用，占用则选择下一个信道
% 2 计算SINR
for i = 1:K
    if(channel_MBS(i)>0)
        sinr_mbs(i) = -1;
    elseif (channel_MBS(i)==0 && channel_SBS(i)==0)
        sinr_mbs(i) = p_M(1,i)*channel_M(i)/sigma;
    elseif(channel_MBS(i)==0 && channel_SBS(i)>0)
        sinr_mbs(i) = p_M(1,i)*channel_M(i)/(p_S(1,i)*channel_S(i)+sigma);
    else
        sinr_mbs(i) = -1;
    end
end
if(max(sinr_mbs)==-1)
    channel_number_of_mbs = -1;
else
    channel_number_of_mbs = find(sinr_mbs==max(sinr_mbs));
end



