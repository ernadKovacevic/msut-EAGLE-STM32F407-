clear all
close all
clc

%wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
% Generate bandpass fir filter coefficients 
%wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
Nfc = 32;                                             % number of filter coefficents
Nf = 1;
fs = 25000;                                             % sampling frequency set to 100 kHz
f1 =500; 
f2 =10000;
Niter = 1;

alpha = 72;                                           % attenuation in [dB]
%lpcoeff = fir1(Nfc-1,f1/(fs/2) ,'low',kaiser(Nfc,0.1102*(alpha-8.7)));
%save('filter_coeff','lpcoeff','Nfc','Nf');

fid = fopen('fir.h','w');

fprintf(fid,'#ifndef __FIRCOEFFS_H_\n');
fprintf(fid,'#define __FIRCOEFFS_H_\n\n');
fprintf(fid,'#include "stm32f4xx.h"\n');
fprintf(fid,'#define FIR_N\t\t %d\n\n',uint16(Nfc));
fprintf(fid,'extern const float lpcoeff[%d][%d];\n\n',20,uint16(Nfc));
fprintf(fid,'#endif\n\n');

fid = fopen('fir.c','w');
fprintf(fid,'#include "fir.h"\n');

fprintf(fid,'///wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\n');
fprintf(fid,'/// %s\n/// Name: %s\n/// Surname: %s\n',date,'Ernad','Kovacevic');
fprintf(fid,'/// Number of coefficients: %d\n/// Sampling frequency: %d Hz\n',Nfc,fs);
fprintf(fid,'/// Low pass FIR Symmetrical Filter, All coefficients \n');
fprintf(fid,'///---------------------------------------------------------------------\n');
fprintf(fid,'\nconst float lpcoeff[%d][%d] = {\n',20,uint16(Nfc));
for i=500:500:f2
    fprintf(fid,'{');
    lpcoeff = fir1(Nfc-1,i/(fs/2) ,'low',kaiser(Nfc,0.1102*(alpha-8.7)));
    save('filter_coeff','lpcoeff','Nfc','Nf');
    nmax = 8;
    for k=1:Nfc
       if(k ~= Nfc)
           if(lpcoeff(k) >= 0)
             fprintf(fid,' %.4f,',lpcoeff(k));
           else
             fprintf(fid,'%.4f,',lpcoeff(k));
           end
        
           if(mod(k,nmax) == 0)
               fprintf(fid,'\n');
           end
       else
          if(lpcoeff(k) >= 0)
               fprintf(fid,' %.4f',lpcoeff(k));
          else
               fprintf(fid,'%.4f',lpcoeff(k));
          end
       end
      if(k==Nfc)
        fprintf(fid,'\n},\n');
      end
    end
end
fprintf(fid,'\n};\n');


fclose(fid);
% 
% Ns = 2048;
% Ts = 1/fs;
% t = 0:Ts:(Ns-1)*Ts;
% f1 = 200;
% % fs = 2.1e4
% f2 = 0;
% f3 = 2000
% 
% x1 = sin(2*pi*f1*t);
% x2 = sin(2*pi*f2*t);
% x3 = sin(2*pi*f3*t);
% x = x1 + x2 + x3;
% 
%                                         % spectrum of interest after shifting is in the range 
%                                         % (0,20) kHz
% M = Ns;
% %wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
% % Filtering the input signal x with low pass fir filter 
% %wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
% lp1 = lpcoeff;
% y = bpfilter(x,lpcoeff,Ns,Nfc);
% 
% 
% subplot(3,1,1)
% plot(linspace(0,fs,size(x,2))/1000,abs(fft(x))/size(x,2))
% ylabel('X(f)');
% xlabel('f[kHz]');
% 
% 
% subplot(3,1,2)
% H = 20*log10(abs(fft(lpcoeff)));
% plot(linspace(0,fs,size(H,2))/1000,H,'r')
% ylabel('H_{lp}(f)');
% xlabel('f[kHz]');
% 
% subplot(3,1,3)
% plot(linspace(0,fs,size(y,2))/1000,abs(fft(y))/size(y,2),'k');
% ylabel('Y_{lp}(f)');
% xlabel('f[kHz]');
% hold on


