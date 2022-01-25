% Copyright (C) 2020 Theodore Zisimopoulos
% 
% Octave example of EEG signal proccessing to detect movement
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load signal package in octave
if(exist ('OCTAVE_VERSION', 'builtin'))
  pkg load signal;
end

% skip 'clear all' and re-initialization if files are already loaded
if(exist("eeg","var")~=1) 
  clear all;
  hdr={};
  EEG={};
  eeg=zeros(65,20000);
  task={zeros(65,20000);zeros(65,20000);zeros(65,20000);zeros(65,20000)};
  c3={zeros(1,20000);zeros(1,20000);zeros(1,20000);zeros(1,20000)};
  cz={zeros(1,20000);zeros(1,20000);zeros(1,20000);zeros(1,20000)};
  c4={zeros(1,20000);zeros(1,20000);zeros(1,20000);zeros(1,20000)};
  for i=1:12
    if(i<8)
      [hdr{i},EEG{i}] = edfread(['edfs/S001R0',sprintf('%d',i+2),'.edf']);
    else
      [hdr{i},EEG{i}] = edfread(['edfs/S001R',sprintf('%d',i+2),'.edf']);
    end  
    if(mod((i+2),4)==3)
      task{1}=task{1} + EEG{1,i};
    elseif(mod((i+2),4)==0)
      task{2}=task{2} + EEG{1,i};
    elseif(mod((i+2),4)==1)
      task{3}=task{3} + EEG{1,i};
    elseif(mod((i+2),4)==2)
      task{4}=task{4} + EEG{1,i};
    end
    
  end
  [hdrbeo,EEGbeo] = edfread(['edfs/S001R01.edf']);%baseline eyes open
  [hdrbec,EEGbec] = edfread(['edfs/S001R02.edf']);%baseline eyes closed
  taskname={"open and close left or right fist";"imagine opening and closing left or right fist";"open and close both fists or both feet";"imagine opening and closing both fists or both feet"};
  
  for i=1:4
    task{i}=task{i}./3;
    c3{i}=task{i,1}(9, 1:20000);
    cz{i}=task{i,1}(11, 1:20000);
    c4{i}=task{i,1}(13, 1:20000);    
  end  
end

close all;
% EEG identification
msgbox(["Transducer: ",hdr{1,1}.transducer{1,1},"\nStartDate: ",hdr{1,1}.startdate,"\nStartTime: ",hdr{1,1}.starttime,"\nNo prefilter or noise has been added  "],"EEG signal info");
% figure initialization
figures;
% EEGbeo and EEGbec plots
N=9;
fs=160;
time=0:1/fs:(length(EEGbeo)-1)*1/fs;
% Create plots for baseline signals (if statement appears just so one can see the code clearly 

% Mu rhythms (8-12hz) or (8-18hz) as used in this particular example
W1=2*8/fs;
W2=2*18/fs;
Wn_m=[W1 W2];
[c,d]=butter(N,Wn_m);
mueo=filter(c,d,EEGbeo);
muec=filter(c,d,EEGbec);
[freqeo,ampeo,phazeo]=fftFun(mueo,fs);
[freqec,ampec,phazec]=fftFun(muec,fs);

figure(1);
subplot(2,2,1), plot(freqeo,ampeo);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title("mu waves of:\nBaseline eeg with eyes open");
  axis([-100 100 0 500]);
subplot(2,2,2), plot(freqec,ampec);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title("mu waves of:\nBaseline eeg with eyes closed");
  axis([-100 100 0 500]);
[freqeo,ampeo,phazeo]=fftFun(EEGbeo,fs);
[freqec,ampec,phazec]=fftFun(EEGbec,fs);
subplot(2,2,3), plot(freqeo,ampeo);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title('raw EEGbeo signal');
  axis([-100 100 0 25000]);
subplot(2,2,4), plot(freqec,ampec);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title('raw EEGbec signal');
  axis([-100 100 0 25000]);
figure(2);
subplot(4,1,1), plot(time,EEGbeo);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("Raw EEGbeo signal wave patterns");
subplot(4,1,2), plot(time,EEGbec);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("Raw EEGbec signal wave patterns");
subplot(4,1,3), plot(time,mueo);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("mu waves time pattern of:\nBaseline eeg with eyes open");
  %axis([0 80 -100 100]);
subplot(4,1,4), plot(time,muec);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("mu waves time pattern of:\nBaseline eeg with eyes closed");
  %axis([0 80 -100 100]);
  
 % gamma rhythms (30-80hz)
W1=2*30/fs;
W2=2*80/fs;
Wn_g=[W1 W2];
[c,d]=butter(N,Wn_g);
gammaeo=filter(c,d,EEGbeo);
gammaec=filter(c,d,EEGbec);
[freqeo,ampeo,phazeo]=fftFun(gammaeo,fs);
[freqec,ampec,phazec]=fftFun(gammaec,fs);

figure(5);
subplot(2,2,1), plot(freqeo,ampeo);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title("gamma waves of:\nBaseline eeg with eyes open");
  axis([-100 100 0 500]);
subplot(2,2,2), plot(freqec,ampec);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title("gamma waves of:\nBaseline eeg with eyes closed");
  axis([-100 100 0 500]);
[freqeo,ampeo,phazeo]=fftFun(EEGbeo,fs);
[freqec,ampec,phazec]=fftFun(EEGbec,fs);
subplot(2,2,3), plot(freqeo,ampeo);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title('raw EEGbeo signal');
  axis([-100 100 0 25000]);
subplot(2,2,4), plot(freqec,ampec);
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  title('raw EEGbec signal');
  axis([-100 100 0 25000]);
figure(6);
subplot(4,1,1), plot(time,EEGbeo);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("Raw EEGbeo signal wave patterns");
  %axis([0 80 -100 100]);
subplot(4,1,2), plot(time,EEGbec);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("Raw EEGbec signal wave patterns");
  %axis([0 80 -100 100]);
subplot(4,1,3), plot(time,gammaeo);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("gamma waves time pattern of:\nBaseline eeg with eyes open");
  axis([0 80 -100 100]);
subplot(4,1,4), plot(time,gammaec);
  xlabel('Time(s)');
  ylabel('Amplitude');
  title("gamma waves time pattern of:\nBaseline eeg with eyes closed");
  axis([0 80 -100 100]);

% Movement tasks plots
for i=1:4
    eeg=c3{i};
    plots(c3{i},3,4,i,"c3");
end    
for i=1:4
    eeg=cz{i};
    plots(cz{i},9,10,i,"cz");
end
for i=1:4
    eeg=c4{i};
    plots(c4{i},11,12,i,"c4");
end    

for i=1:4
    % Gamma rhythms (30-80hz)
    eeg=task{i};
    N=9;
    fs=160;
    time=0:1/fs:(length(eeg)-1)*1/fs;
    W3=2*30/fs;
    W4=2*80/fs;
    Wn_g=[W3 W4];
    [e,f]=butter(N,Wn_g);
    gamma=filter(e,f,eeg);

    [freq,amp,phaz]=fftFun(gamma,fs);
    figure(7);
    subplot(2,2,i), plot(freq,amp);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    title(["gamma waves of task:\n ",sprintf("'%s'",taskname{i})]);
    
    
    figure(8);
    subplot(4,1,i), plot(time,gamma);
    xlabel('Time(s)');
    ylabel('Amplitude');
    title(["gamma waves time pattern of task:\n ",sprintf("'%s'",taskname{i})]);
    axis([0 140 -100 100]);
end
