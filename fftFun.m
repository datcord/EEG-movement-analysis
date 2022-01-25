function [frequency,magnitude,phase] = fftFun (x, fs)

  y=fft(x);
  m=length(y);
  frequencyAxis= (1:m)*fs/m;
  fftMagnitude = abs(y);
  fftPhase = angle(y);


  frequency = [-(frequencyAxis(m) - frequencyAxis(m/2:m)) frequencyAxis(1:((m/2)-1))];
  magnitude = [fftMagnitude(m/2:m) fftMagnitude(1:((m/2)-1))];
  phase = [fftPhase(m/2:m) fftPhase(1:((m/2)-1))];

endfunction