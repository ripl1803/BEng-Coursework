% audioread reads .wav files into MATLAB

%microphone
figure(3); 
[mic1,fs] = audioread('microphone.wav');
sound(mic1,fs);
time = (1:length(mic1))/fs;
subplot(2,2,1);
plot(time,mic1);
title('Microphone Recording')

%recording 1
figure(3);
[mic2,fs] = audioread('record1.wav');
sound(mic2,fs);
time = (1:length(mic2))/fs;
subplot(2,2,2)
plot(time,mic2);
title('Recording 1')

%recording 2
figure(3);
[mic3,fs] = audioread('record2.wav');
sound(mic3,fs);
time = (1:length(mic3))/fs;
subplot(2,2,3)
plot(time,mic3);
title('Recording 2')

%recording 3
figure(3);
[mic4,fs] = audioread('record3.wav');
sound(mic4,fs);
time = (1:length(mic4))/fs;
subplot(2,2,4);
plot(time,mic4);
title('Recording 3')

%frequency spectrum

%microphone
[mic1,Fs]=audioread('Microphone.wav');

N=0:length(mic1)-1;
t1=N.*Fs;

figure(1); 
subplot(2,2,1);
plot(t1,mic1);
title('Microphone');
xlabel('Time');
ylabel('Amplitude');

fY = fft(mic1);
figure(2);
subplot(2,2,1);
freqspec(abs(fY),Fs);
xlim([0 300]);
title('Microphone');

%Recording 1
[mic2,Fs]=audioread('Record1.wav');

N=0:length(mic2)-1;
t2=N.*Fs;

figure(1); 
subplot(2,2,2);
plot(t2,mic2);
title('Recording 1');
xlabel('Time');
ylabel('Amplitude');

fY = fft(mic2);
figure(2);
subplot(2,2,2);
freqspec(abs(fY),Fs);
xlim([0.5 300]);
title('Recording 1');

%recording 2
[mic3,Fs]=audioread('Record2.wav');

N=0:length(mic3)-1;
t3=N.*Fs;

figure(1);
subplot(2,2,3);
plot(t3,mic3);
title('Recording 2');
xlabel('Time');
ylabel('Amplitude');

fY = fft(mic3);
figure(2);
subplot(2,2,3);
freqspec(abs(fY),Fs);
xlim([0.5 300]);
title('Recording 2');

%recording 3
[mic4,Fs]=audioread('Record3.wav');

N=0:length(mic4)-1;
T=1/Fs;
t4=N.*Fs;

figure(1); 
subplot(2,2,4);
plot(t4,mic4);
title('Recording 3');
xlabel('Time');
ylabel('Amplitude');

fY = fft(mic4);
figure(2);
subplot(2,2,4);
freqspec(abs(fY),Fs);
xlim([0.5 300]);
title('Recording 3');

%Notch filter 50Hz
%Microphone Notch filter
w0 = Hztofnormalised(50,fs);
bw = w0/2;
[bn,an] = iirnotch(w0,bw);
fvtool(bn,an)
mic1_n = filtfilt(bn,an,mic1);
title('Magnitude response for microphone');

plot(t1,mic1);
hold on;
plot(t1,mic1_n);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Microphone after 50Hz Notch Filter');

%Recording 1 Notch filter
w0 = Hztofnormalised(50,fs);
bw = w0/2;
[bn,an] = iirnotch(w0,bw);
fvtool(bn,an)
mic2_n = filtfilt(bn,an,mic2);
title('Magnitude response for Recording 1');

plot(t2,mic2);
hold on;
plot(t2,mic2_n);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Recording 1 after 50Hz Notch Filter');

%Recording 2 Notch filter
w0 = Hztofnormalised(50,fs);
bw = w0/2;
[bn,an] = iirnotch(w0,bw);
fvtool(bn,an)
mic3_n = filtfilt(bn,an,mic3);
title('Magnitude response for Recording 2');

plot(t3,mic3);
hold on;
plot(t3,mic3_n);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Recording 2 after 50Hz Notch Filter');

%Recording 3 Notch filter
w0 = Hztofnormalised(50,fs);
bw = w0/2;
[bn,an] = iirnotch(w0,bw);
fvtool(bn,an)
mic4_n = filtfilt(bn,an,mic4);
title('Magnitude response for recording 3');

plot(t4,mic4);
hold on;
plot(t4,mic4_n);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Recording 3 after 50Hz Notch Filter');

%cross corrilation between orig and Notch filtered
max(xcorr(mic1,mic2)) % 17.0594
max(xcorr(mic1,mic3)) % 14.3351
max(xcorr(mic1,mic4)) % 8.6559

%butterworth filter
[b,a] = butter(3,[Hztofnormalised(75,fs),Hztofnormalised(200,fs)],'bandpass');
fvtool(b,a)

%microphone
mic1_f = filtfilt(b,a,mic1);

subplot(2,2,1);
plot(t1,mic1);
hold on;
plot(t1,mic1_f);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('mic after Butterworth Filter');

%recording 1
mic2_f = filtfilt(b,a,mic2);

subplot(2,2,2);
plot(t2,mic2);
hold on;
plot(t2,mic2_f);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('rec1 after Butterworth Filter');

%recording 2
mic3_f = filtfilt(b,a,mic3);

subplot(2,2,3);
plot(t3,mic3);
hold on;
plot(t3,mic3_f);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('rec2 after Butterworth Filter');

%recording 3
mic4_f = filtfilt(b,a,mic4);

subplot(2,2,4);
plot(t4,mic4);
hold on;
plot(t4,mic4_f);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('mic after Butterworth Filter');

max(xcorr(mic1_f,mic2_f)) % 14.2084
max(xcorr(mic1_f,mic3_f)) % 9.7232
max(xcorr(mic1_f,mic4_f)) % 6.9226
