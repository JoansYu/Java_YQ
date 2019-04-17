function [channel_number_of_mbs] = select_SINR_MBS_channel(channel_MBS, channel_SBS,i, p_M, p_S, channel_M, channel_S, sigma,K )
%% ѡ����������MBS�ŵ�
% channel_number_of_mbs ����������ŵ���


%����SINR
% 1 �鿴�ŵ��Ƿ�ռ�ã�ռ����ѡ����һ���ŵ�
% 2 ����SINR
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



