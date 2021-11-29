function XD=DenoisingWavelet(Signal,PPG_ECG,Notview)

 [C,L] = wavedec(Signal,10,'db8');
 Start_End=cumsum(L);
 C(Start_End(end-2):Start_End(end-1))=0;  %% 250-500Hz
 C(Start_End(1):Start_End(2))=0;  %% 0-1Hz
 X= waverec(C,L,'db8');
 if PPG_ECG==1 % ECG
 XD = wden(X,'rigrsure','s','mln',10,'db8');
 else %PPG
 XD = wden(X,'rigrsure','s','sln',10,'db8');   
 end
 XD=detrend(XD);  %% Better Method than Wavelet for DC-Denoising
 if Notview~=1
     figure(9)
     clf
     plot(Signal)
     hold on
     plot(XD)
     pause(.001)
 end
end