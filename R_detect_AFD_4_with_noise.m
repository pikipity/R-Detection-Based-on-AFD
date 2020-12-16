clear;clc;
ID=[100 101];
h=waitbar(0,'Start');
for ID_index=1:length(ID)
    R_AFD_noise=cell(1,5);
    for noise_level=[5 10 15 20 25]
        waitbar(0,h,['ECG_ ' num2str(ID(ID_index)) '_ noise ' num2str(noise_level) 'dB'])
        load(['ECG_' num2str(ID(ID_index)) '.mat']);
        ECG=M(:,1).';
        ECG=awgn(ECG,noise_level,'measured');
        
        win_start=1;
        win_len=360*2;
        win_end=win_start+win_len;
        R_AFD=[];
        %
        while win_end<=length(ECG)
            waitbar(win_end/length(ECG),h,[num2str(win_end/length(ECG)*100) '% ECG_ ' num2str(ID(ID_index)) '_ noise ' num2str(noise_level) 'dB'])
            f=detrend(ECG(win_start:win_end));
            [f_recovery_final,F,coef,a] =AFD_filter_final(f,noise_level,5);
            f=f_recovery_final;
            f=[rand(1,100)*0.001*std(f)-0.5*0.001+f(1) f+(rand(1,length(f))*0.001*std(f)-0.5*0.001) rand(1,100)*0.001*std(f)-0.5*0.001+f(end)];
            %[f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f),50);
            %f=f_recovery;
            df=diff(f);
            z=abs(f).*[0 abs(df)];
            [upper,lower] = envelope(z,3,'peak');
            xl=upper;
            window=zeros(1,length(xl));
            window(xl>=(mean(xl)+std(xl)))=1;
            win_up=find(diff(window)>0);
            win_down=find(diff(window)<0);
            win_up=win_up+1;
            win_edge=sort([win_up win_down]);
            win_final_edge=floor((1+win_edge(1))/2);
            for k=2:2:length(win_edge)-1
                win_final_edge=[win_final_edge floor((win_edge(k)+win_edge(k+1))/2)];
            end
            win_final_edge=[win_final_edge floor((win_edge(end)+length(z))/2)];
            for win_index=1:length(win_final_edge)-1
                [f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f(win_final_edge(win_index):win_final_edge(win_index+1))),5);
                [~,I]=max(real(base_store(2,:)));
                I=win_final_edge(win_index)+I-1-100;
                R_AFD=[R_AFD I+win_start-1];
            end

            win_start=win_end+1;
            win_end=win_start+win_len;
        end
        if win_end>length(ECG)
            win_end=length(ECG);
            waitbar(win_end/length(ECG),h,[num2str(win_end/length(ECG)*100) '% ECG_ ' num2str(ID(ID_index)) '_ noise ' num2str(noise_level) 'dB'])
            f=detrend(ECG(win_start:win_end));
            [f_recovery_final,F,coef,a] =AFD_filter_final(f,noise_level,5);
            f=f_recovery_final;
            f=[rand(1,100)*0.001*std(f)-0.5*0.001+f(1) f+(rand(1,length(f))*0.001*std(f)-0.5*0.001) rand(1,100)*0.001*std(f)-0.5*0.001+f(end)];
            %[f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f),50);
            %f=f_recovery;
            df=diff(f);
            z=abs(f).*[0 abs(df)];
            [upper,lower] = envelope(z,3,'peak');
            xl=upper;
            window=zeros(1,length(xl));
            window(xl>=(mean(xl)+std(xl)))=1;
            win_up=find(diff(window)>0);
            win_down=find(diff(window)<0);
            win_up=win_up+1;
            win_edge=sort([win_up win_down]);
            win_final_edge=floor((1+win_edge(1))/2);
            for k=2:2:length(win_edge)-1
                win_final_edge=[win_final_edge floor((win_edge(k)+win_edge(k+1))/2)];
            end
            win_final_edge=[win_final_edge floor((win_edge(end)+length(z))/2)];
            for win_index=1:length(win_final_edge)-1
                [f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f(win_final_edge(win_index):win_final_edge(win_index+1))),5);
                [~,I]=max(real(base_store(2,:)));
                I=win_final_edge(win_index)+I-1-100;
                R_AFD=[R_AFD I+win_start-1];
            end
        end
        R_AFD=sort(R_AFD);
        %
        RR_interval=diff(R_AFD);
        mean_RR_interval=mean(RR_interval);
        I_RR_larger_1dot5=find(RR_interval>(1.5*mean_RR_interval));
        old_I_RR_larger_1dot5=[];
        while ~isequal(I_RR_larger_1dot5,old_I_RR_larger_1dot5)
            old_I_RR_larger_1dot5=I_RR_larger_1dot5;

            RR_interval=diff(R_AFD);
            mean_RR_interval=mean(RR_interval);
            I_RR_larger_1dot5=find(RR_interval>(1.5*mean_RR_interval));
            unusual_period=zeros(length(I_RR_larger_1dot5),2);
            for i=1:length(I_RR_larger_1dot5)
                if I_RR_larger_1dot5(i)-1<1
                    unusual_period(i,1)=1;
                else
                    unusual_period(i,1)=floor((R_AFD(I_RR_larger_1dot5(i))+R_AFD(I_RR_larger_1dot5(i)-1))/2);
                end
                if I_RR_larger_1dot5(i)+2>length(R_AFD)
                    unusual_period(i,2)=length(ECG);
                else
                    unusual_period(i,2)=floor((R_AFD(I_RR_larger_1dot5(i)+1)+R_AFD(I_RR_larger_1dot5(i)+2))/2);
                end
            end
            for i=1:size(unusual_period,1)
                waitbar(i/size(unusual_period,1),h,['ECG_ ' num2str(ID(ID_index)) ' retrival (large)' ' noise ' num2str(noise_level) 'dB'])
                I1=find(R_AFD>=unusual_period(i,1));
                I2=find(R_AFD<=unusual_period(i,2));
                I=intersect(I1,I2);
                R_AFD=setdiff(R_AFD,R_AFD(I));
                win_start=unusual_period(i,1);
                win_end=unusual_period(i,2);
                f=detrend(ECG(win_start:win_end));
                [f_recovery_final,F,coef,a] =AFD_filter_final(f,noise_level,5);
                f=f_recovery_final;
                f=[rand(1,100)*0.001*std(f)-0.5*0.001+f(1) f+(rand(1,length(f))*0.001*std(f)-0.5*0.001) rand(1,100)*0.001*std(f)-0.5*0.001+f(end)];
                %[f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f),50);
                %f=f_recovery;
                df=diff(f);
                z=abs(f).*[0 abs(df)];
                [upper,lower] = envelope(z,3,'peak');
                xl=upper;
                window=zeros(1,length(xl));
                window(xl>=(mean(xl)+std(xl)))=1;
                win_up=find(diff(window)>0);
                win_down=find(diff(window)<0);
                win_up=win_up+1;
                win_edge=sort([win_up win_down]);
                win_final_edge=floor((1+win_edge(1))/2);
                for k=2:2:length(win_edge)-1
                    win_final_edge=[win_final_edge floor((win_edge(k)+win_edge(k+1))/2)];
                end
                win_final_edge=[win_final_edge floor((win_edge(end)+length(z))/2)];
                for win_index=1:length(win_final_edge)-1
                    [f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f(win_final_edge(win_index):win_final_edge(win_index+1))),5);
                    [~,I]=max(real(base_store(2,:)));
                    I=win_final_edge(win_index)+I-1-100;
                    R_AFD=[R_AFD I+win_start-1];
                end
                R_AFD=sort(R_AFD);
            end
            R_AFD=sort(R_AFD);
        end
        %
        RR_interval=diff(R_AFD);
        mean_RR_interval=mean(RR_interval);
        I_RR_smaller_0dot5=find(RR_interval<(0.5*mean_RR_interval));
        old_I_RR_smaller_0dot5=[];
        while ~isequal(I_RR_smaller_0dot5,old_I_RR_smaller_0dot5)
            old_I_RR_smaller_0dot5=I_RR_smaller_0dot5;

            RR_interval=diff(R_AFD);
            mean_RR_interval=mean(RR_interval);
            I_RR_smaller_0dot5=find(RR_interval<(0.5*mean_RR_interval));
            unusual_period=zeros(length(I_RR_smaller_0dot5),2);
            for i=1:length(I_RR_smaller_0dot5)
                if I_RR_smaller_0dot5(i)-1<1
                    unusual_period(i,1)=1;
                else
                    unusual_period(i,1)=floor((R_AFD(I_RR_smaller_0dot5(i))+R_AFD(I_RR_smaller_0dot5(i)-1))/2);
                end
                if I_RR_smaller_0dot5(i)+2>length(R_AFD)
                    unusual_period(i,2)=length(ECG);
                else
                    unusual_period(i,2)=floor((R_AFD(I_RR_smaller_0dot5(i)+1)+R_AFD(I_RR_smaller_0dot5(i)+2))/2);
                end
            end
            for i=1:size(unusual_period,1)
                waitbar(i/size(unusual_period,1),h,['ECG_ ' num2str(ID(ID_index)) ' retrival (small) ' ' noise ' num2str(noise_level) 'dB'])
                I1=find(R_AFD>=unusual_period(i,1));
                I2=find(R_AFD<=unusual_period(i,2));
                I=intersect(I1,I2);
                R_AFD=setdiff(R_AFD,R_AFD(I));
                win_start=unusual_period(i,1);
                win_end=unusual_period(i,2);
                f=detrend(ECG(win_start:win_end));
                [f_recovery_final,F,coef,a] =AFD_filter_final(f,noise_level,5);
                f=f_recovery_final;
                f=[rand(1,100)*0.001*std(f)-0.5*0.001+f(1) f+(rand(1,length(f))*0.001*std(f)-0.5*0.001) rand(1,100)*0.001*std(f)-0.5*0.001+f(end)];
                %[f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f),50);
                %f=f_recovery;
                df=diff(f);
                z=abs(f).*[0 abs(df)];
                [upper,lower] = envelope(z,3,'peak');
                xl=upper;
                window=zeros(1,length(xl));
                window(xl>=(mean(xl)+std(xl)))=1;
                win_up=find(diff(window)>0);
                win_down=find(diff(window)<0);
                win_up=win_up+1;
                win_edge=sort([win_up win_down]);
                win_final_edge=floor((1+win_edge(1))/2);
                for k=2:2:length(win_edge)-1
                    win_final_edge=[win_final_edge floor((win_edge(k)+win_edge(k+1))/2)];
                end
                win_final_edge=[win_final_edge floor((win_edge(end)+length(z))/2)];
                for win_index=1:length(win_final_edge)-1
                    [f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD(hilbert(f(win_final_edge(win_index):win_final_edge(win_index+1))),5);
                    [~,I]=max(real(base_store(2,:)));
                    I=win_final_edge(win_index)+I-1-100;
                    R_AFD=[R_AFD I+win_start-1];
                end
                R_AFD=sort(R_AFD);
            end
            R_AFD=sort(R_AFD);
        end
        R_AFD=sort(R_AFD);
        R_AFD_noise{noise_level/5}=R_AFD;
        %
    end
    save(['ECG_' num2str(ID(ID_index)) '_AFD_RL_noise.mat'],'R_AFD_noise');
end
waitbar(1,h,['Finish'])