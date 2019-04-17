function [channel_number_of_sbs] = select_SINR_SBS_channel(channel_MBS, channel_SBS,i, p_M, p_S, channel_M, channel_S, sigma,K)
%% ѡ����������MBS�ŵ�
% channel_number_of_mbs ����������ŵ���



%����SINR
% 1 �鿴�ŵ��Ƿ�ռ�ã�ռ����ѡ����һ���ŵ�
% 2 ����SINR
for i = 1:K
    if(channel_SBS(i)>0)
        sinr_sbs(i) = -1;
%         continue;
    elseif (channel_SBS(i)==0 && channel_MBS(i)==0)
        sinr_sbs(i) = p_S(1,i)*channel_S(i)/sigma;
    elseif(channel_SBS(i)==0 && channel_MBS(i)>0)
        sinr_sbs(i) = p_S(1,i)*channel_S(i)/(p_M(1,i)*channel_M(i)+sigma);
    else
        sinr_sbs(i) = -1;
    end 
end
if(max(sinr_sbs)==-1)
    channel_number_of_sbs = -1;
else
    channel_number_of_sbs = find(sinr_sbs==max(sinr_sbs));
end



