function plots(c,figure1,figure2,i,name)

taskname={"open and close left or right fist";"imagine opening and closing left or right fist";"open and close both fists or both feet";"imagine opening and closing both fists or both feet"};

    eeg=c;
    N=9;
    fs=160;
    time=0:1/fs:(length(eeg)-1)*1/fs;
    
    % Mu rhythms (8-18hz)
    W1=2*8/fs;
    W2=2*18/fs;
    Wn_m=[W1 W2];
    [c,d]=butter(N,Wn_m);
    mu=filter(c,d,eeg);

    [freq,amp,phaz]=fftFun(mu,fs);
    figure(figure1);
    subplot(2,2,i), plot(freq,amp);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    title([sprintf("'%s'",name)," mu waves of task:\n ",sprintf("'%s'",taskname{i})]);
    axis([-100 100 0 500]);
    
    figure(figure2);
    subplot(4,1,i), plot(time,mu);
    xlabel('Time(s)');
    ylabel('Amplitude');
    title([sprintf("'%s'",name)," mu waves time pattern of task:\n ",sprintf("'%s'",taskname{i})]);
    axis([0 140 -100 100]);

endfunction
