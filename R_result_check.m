%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is prepared by Ze Wang. If you find any problem, please contact
% wangze19910407@gmail.com
%
% This code can only be used for research studies. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;
ID=[100 101];
ID=ID([1:2])
%
summary_correct_detec={};
summary_delay={};
summary_wrong_detec={};
summary_miss={};
%
% summary_correct_detec_PT_noise={};
% summary_delay_PT_noise={};
% summary_wrong_detec_PT_noise={};
% summary_miss_PT_noise={};
%
% summary_correct_detec_PT_noise_denoising={};
% summary_delay_PT_noise_denoising={};
% summary_wrong_detec_PT_noise_denoising={};
% summary_miss_PT_noise_denoising={};
%
collect_Se={};
collect_P={};
collect_RMSE={};
%
for ID_number=1:length(ID)
    disp(strcat(num2str(ID_number/length(ID)*100),'%'))
    disp(strcat('ECG_',num2str(ID(ID_number))))
    if exist(strcat('ECG_',num2str(ID(ID_number)),'_AFD_RL_noise.mat')) && exist(strcat('ECG_',num2str(ID(ID_number)),'_PT_RL.mat'))
        load(strcat('ECG_',num2str(ID(ID_number)),'_PT_RL.mat'))
        RL=R_PT;
%         load(strcat('ECG_',num2str(ID(ID_number)),'_AFD_RL.mat'))
        load(strcat('ECG_',num2str(ID(ID_number)),'_AFD_RL_noise.mat'))
%         load(strcat('ECG_',num2str(ID(ID_number)),'_PT_RL_noise.mat'))
%         load(strcat('ECG_',num2str(ID(ID_number)),'_PT_RL_noise_denoising.mat'))
        %
%         correct_detec=[];
%         delay=[];
%         wrong_detec=[];
%         miss=[];
%         for i=1:length(RL)
%             I1=find(R_AFD>=(RL(i)-5));
%             I2=find(R_AFD<=(RL(i)+5));
%             I=intersect(I1,I2);
%             if isempty(I)
%                 miss=[miss RL(i)];
%             else
%                 if length(I)>1
%                     temp_select=R_AFD(I);
%                     [~,temp_I]=min(abs(temp_select-RL(i)));
%                     correct_detec=[correct_detec temp_select(temp_I)];
%                     delay=[delay temp_select(temp_I)-RL(i)];
%                 else
%                     correct_detec=[correct_detec R_AFD(I)];
%                     delay=[delay R_AFD(I)-RL(i)];
%                 end
%             end
%         end
%         wrong_detec=setdiff(R_AFD,correct_detec);
%         save(strcat('ECG_',num2str(ID(ID_number)),'_AFD_RL_checkresult.mat'),'correct_detec','delay','wrong_detec','miss')
        %
        correct_detec_noise={};
        delay_noise={};
        wrong_detec_noise={};
        miss_noise={};
        for k=1:length(R_AFD_noise)
            R_AFD=R_AFD_noise{k};
            correct_detec=[];
            delay=[];
            wrong_detec=[];
            miss=[];
            for i=1:length(RL)
                I1=find(R_AFD>=(RL(i)-5));
                I2=find(R_AFD<=(RL(i)+5));
                I=intersect(I1,I2);
                if isempty(I)
                    miss=[miss RL(i)];
                else
                    if length(I)>1
                        temp_select=R_AFD(I);
                        [~,temp_I]=min(abs(temp_select-RL(i)));
                        correct_detec=[correct_detec temp_select(temp_I)];
                        delay=[delay temp_select(temp_I)-RL(i)];
                    else
                        correct_detec=[correct_detec R_AFD(I)];
                        delay=[delay R_AFD(I)-RL(i)];
                    end
                end
            end
            wrong_detec=setdiff(R_AFD,correct_detec);
            correct_detec_noise{1,k}=correct_detec;
            delay_noise{1,k}=delay;
            wrong_detec_noise{1,k}=wrong_detec;
            miss_noise{1,k}=miss;
            if length(summary_correct_detec)<k
                summary_correct_detec{1,k}=[];
            end
            if length(summary_delay)<k
                summary_delay{1,k}=[];
            end
            if length(summary_wrong_detec)<k
                summary_wrong_detec{1,k}=[];
            end
            if length(summary_miss)<k
                summary_miss{1,k}=[];
            end
            summary_correct_detec{1,k}=[summary_correct_detec{1,k} correct_detec];
            summary_delay{1,k}=[summary_delay{1,k} delay];
            summary_wrong_detec{1,k}=[summary_wrong_detec{1,k} wrong_detec];
            summary_miss{1,k}=[summary_miss{1,k} miss];
            collect_Se{1,k}(ID_number,1)=length(correct_detec)/(length(correct_detec)+length(wrong_detec));
            collect_P{1,k}(ID_number,1)=length(correct_detec)/(length(correct_detec)+length(miss));
            collect_RMSE{1,k}(ID_number,1)=sqrt(mean(delay.^2));
        end
        save(strcat('ECG_',num2str(ID(ID_number)),'_AFD_RL_noise_checkresult.mat'),'correct_detec_noise','delay_noise','wrong_detec_noise','miss_noise')
        %
%         correct_detec_noise={};
%         delay_noise={};
%         wrong_detec_noise={};
%         miss_noise={};
%         for k=1:length(R_AFD_noise)
%             R_AFD=R_PT_noise{k};
%             correct_detec=[];
%             delay=[];
%             wrong_detec=[];
%             miss=[];
%             for i=1:length(RL)
%                 I1=find(R_AFD>=(RL(i)-5));
%                 I2=find(R_AFD<=(RL(i)+5));
%                 I=intersect(I1,I2);
%                 if isempty(I)
%                     miss=[miss RL(i)];
%                 else
%                     if length(I)>1
%                         temp_select=R_AFD(I);
%                         [~,temp_I]=min(abs(temp_select-RL(i)));
%                         correct_detec=[correct_detec temp_select(temp_I)];
%                         delay=[delay temp_select(temp_I)-RL(i)];
%                     else
%                         correct_detec=[correct_detec R_AFD(I)];
%                         delay=[delay R_AFD(I)-RL(i)];
%                     end
%                 end
%             end
%             wrong_detec=setdiff(R_AFD,correct_detec);
%             correct_detec_noise{1,k}=correct_detec;
%             delay_noise{1,k}=delay;
%             wrong_detec_noise{1,k}=wrong_detec;
%             miss_noise{1,k}=miss;
%             if length(summary_correct_detec_PT_noise)<k
%                 summary_correct_detec_PT_noise{1,k}=[];
%             end
%             if length(summary_delay_PT_noise)<k
%                 summary_delay_PT_noise{1,k}=[];
%             end
%             if length(summary_wrong_detec_PT_noise)<k
%                 summary_wrong_detec_PT_noise{1,k}=[];
%             end
%             if length(summary_miss_PT_noise)<k
%                 summary_miss_PT_noise{1,k}=[];
%             end
%             summary_correct_detec_PT_noise{1,k}=[summary_correct_detec_PT_noise{1,k} correct_detec];
%             summary_delay_PT_noise{1,k}=[summary_delay_PT_noise{1,k} delay];
%             summary_wrong_detec_PT_noise{1,k}=[summary_wrong_detec_PT_noise{1,k} wrong_detec];
%             summary_miss_PT_noise{1,k}=[summary_miss_PT_noise{1,k} miss];
%             collect_Se{1,k}(ID_number,2)=length(correct_detec)/(length(correct_detec)+length(wrong_detec));
%             collect_P{1,k}(ID_number,2)=length(correct_detec)/(length(correct_detec)+length(miss));
%             collect_RMSE{1,k}(ID_number,2)=sqrt(mean(delay.^2));
%         end
%         save(strcat('ECG_',num2str(ID(ID_number)),'_PT_RL_noise_checkresult.mat'),'correct_detec_noise','delay_noise','wrong_detec_noise','miss_noise')
        %
%         correct_detec_noise={};
%         delay_noise={};
%         wrong_detec_noise={};
%         miss_noise={};
%         for k=1:length(R_AFD_noise)
%             R_AFD=R_PT_noise_denoising{k};
%             correct_detec=[];
%             delay=[];
%             wrong_detec=[];
%             miss=[];
%             for i=1:length(RL)
%                 I1=find(R_AFD>=(RL(i)-5));
%                 I2=find(R_AFD<=(RL(i)+5));
%                 I=intersect(I1,I2);
%                 if isempty(I)
%                     miss=[miss RL(i)];
%                 else
%                     if length(I)>1
%                         temp_select=R_AFD(I);
%                         [~,temp_I]=min(abs(temp_select-RL(i)));
%                         correct_detec=[correct_detec temp_select(temp_I)];
%                         delay=[delay temp_select(temp_I)-RL(i)];
%                     else
%                         correct_detec=[correct_detec R_AFD(I)];
%                         delay=[delay R_AFD(I)-RL(i)];
%                     end
%                 end
%             end
%             wrong_detec=setdiff(R_AFD,correct_detec);
%             correct_detec_noise{1,k}=correct_detec;
%             delay_noise{1,k}=delay;
%             wrong_detec_noise{1,k}=wrong_detec;
%             miss_noise{1,k}=miss;
%             if length(summary_correct_detec_PT_noise_denoising)<k
%                 summary_correct_detec_PT_noise_denoising{1,k}=[];
%             end
%             if length(summary_delay_PT_noise_denoising)<k
%                 summary_delay_PT_noise_denoising{1,k}=[];
%             end
%             if length(summary_wrong_detec_PT_noise_denoising)<k
%                 summary_wrong_detec_PT_noise_denoising{1,k}=[];
%             end
%             if length(summary_miss_PT_noise_denoising)<k
%                 summary_miss_PT_noise_denoising{1,k}=[];
%             end
%             summary_correct_detec_PT_noise_denoising{1,k}=[summary_correct_detec_PT_noise_denoising{1,k} correct_detec];
%             summary_delay_PT_noise_denoising{1,k}=[summary_delay_PT_noise_denoising{1,k} delay];
%             summary_wrong_detec_PT_noise_denoising{1,k}=[summary_wrong_detec_PT_noise_denoising{1,k} wrong_detec];
%             summary_miss_PT_noise_denoising{1,k}=[summary_miss_PT_noise_denoising{1,k} miss];
%             collect_Se{1,k}(ID_number,3)=length(correct_detec)/(length(correct_detec)+length(wrong_detec));
%             collect_P{1,k}(ID_number,3)=length(correct_detec)/(length(correct_detec)+length(miss));
%             collect_RMSE{1,k}(ID_number,3)=sqrt(mean(delay.^2));
%         end
%         save(strcat('ECG_',num2str(ID(ID_number)),'_PT_RL_noise_denoising_checkresult.mat'),'correct_detec_noise','delay_noise','wrong_detec_noise','miss_noise')
    else
        disp('None')
    end
end
%
Se_summary=[];
P_summary=[];
for k=1:5
    disp('AFD')
    Se=length(summary_correct_detec{k})/(length(summary_correct_detec{k})+length(summary_wrong_detec{k}));
    P=length(summary_correct_detec{k})/(length(summary_correct_detec{k})+length(summary_miss{k}));
    disp(['Se: ' num2str(Se)])
    disp(['+P: ' num2str(P)])
    Se_summary(k,1)=Se;
    P_summary(k,1)=P;
    
%     disp('PT_noise')
%     Se=length(summary_correct_detec_PT_noise{k})/(length(summary_correct_detec_PT_noise{k})+length(summary_wrong_detec_PT_noise{k}));
%     P=length(summary_correct_detec_PT_noise{k})/(length(summary_correct_detec_PT_noise{k})+length(summary_miss_PT_noise{k}));
%     disp(['Se: ' num2str(Se)])
%     disp(['+P: ' num2str(P)])
%     Se_summary(k,2)=Se;
%     P_summary(k,2)=P;
%     
%     disp('PT_noise_denoising')
%     Se=length(summary_correct_detec_PT_noise_denoising{k})/(length(summary_correct_detec_PT_noise_denoising{k})+length(summary_wrong_detec_PT_noise_denoising{k}));
%     P=length(summary_correct_detec_PT_noise_denoising{k})/(length(summary_correct_detec_PT_noise_denoising{k})+length(summary_miss_PT_noise_denoising{k}));
%     disp(['Se: ' num2str(Se)])
%     disp(['+P: ' num2str(P)])
%     Se_summary(k,3)=Se;
%     P_summary(k,3)=P;
end
%
for k=1:5
    collect_P{k}(end+1,:)=mean(collect_P{k});
    collect_Se{k}(end+1,:)=mean(collect_Se{k});
    collect_RMSE{k}(end+1,:)=mean(collect_RMSE{k});
end