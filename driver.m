% EECS351 Final Project
% rohrer, malinas
% December 12, 2016

% clear the environment
clc; close all; clear all;

Tw = 25;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 100 3000 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter def 22
       
% hamming window (see Eq. (5.2) on p.73 of [1]
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
fs = 44100; 

% sample of both
% Read speech samples, sampling rate and precision from file
[speech] = audioread( 'data/bobtravisbothtest.wav' );
timevec = speech(:,1);
% Feature extraction (feature vectors as columns)
[MFCCboth, FBEs, frames ] = ...
mfcconline( speech(:,1), fs, Tw, Ts, alpha, hamming, R, M, C, L );
% add in envelopes
%MFCCboth = [MFCCboth; envelopeCalc(frames)];

% sample A
[speech] = audioread( 'data/bobcontroltestwtravis.wav' );       
% Feature extraction (feature vectors as columns)
[MFCCa, FBEs, frames ] = ...
mfcconline( speech(:,1), fs, Tw, Ts, alpha, hamming, R, M, C, L );
% add in envelopes
%MFCCa = [MFCCa; envelopeCalc(frames)];

% sample B
[speech] = audioread( 'data/travistest.wav' );    
% Feature extraction (feature vectors as columns)
[ MFCCb, FBEs, frames ] = ...
mfcconline( speech(:,1), fs, Tw, Ts, alpha, hamming, R, M, C, L );
% add in envelopes
%MFCCb = [MFCCb; envelopeCalc(frames)];


[rows, cols] = size(MFCCboth);
speaker = [];

% figure out who is speaking
cova = cov(MFCCa.');
covb = cov(MFCCb.');

meana = mean(MFCCa.');
meanb = mean(MFCCb.');


for i = 1:cols
	  % find speaker by calculating mahalanobis distance
      [speaking] = determineSpeaker(cova,covb, meana, meanb,MFCCboth(:,i).');
      speaker = [speaker speaking];
       
      %KTH FOR CONFUSION PURPOSES ONLY. UNCOMMENT ABOVE 2 LINES BEFORE USE
      %speaker = [speaker ...
      % determineSpeakerkth(MFCCa.', MFCCb.', MFCCboth(:,i).')];
end

speaker_pre_error = speaker;

% call find Silence on timevec
silentVec = findSilence(timevec);
dilutedSilentVec = diluteSilence(silentVec, 441);

% based on silentVec 0 out some of the parts of the speaker
filterparam = 220;
speaker(~dilutedSilentVec) = 1.5;
nobreath_speaker = speaker;
numSpeakers = 2;
% averaging filter to remove effects of silence
filterout = speakerAvg(nobreath_speaker, numSpeakers, filterparam);

% set speakers to 1 or 2 based on filter
speaker(filterout>1.5) = 2;
speaker(filterout<=1.5) = 1;

% call dilute 
diluteParam = 100;
[dilutedSpeaker] = dilute(speaker, diluteParam, cols);

% -------- actually diarize the signal ---------------
samples10ms = fs / 100;
onlySpeaker1 = 0 * timevec;
onlySpeaker2 = 0 * timevec;
for i=1:numel(timevec)/samples10ms
	if speaker(i) == 1
		onlySpeaker1((i-1)*samples10ms + 1 : i*samples10ms) = timevec((i-1)*samples10ms + 1 : i*samples10ms);
	elseif speaker(i) == 2
		onlySpeaker2((i-1)*samples10ms + 1 : i*samples10ms) = timevec((i-1)*samples10ms + 1 : i*samples10ms);
	end
end
% write to files
audiowrite('data/speaker1.wav', onlySpeaker1, fs);
audiowrite('data/speaker2.wav', onlySpeaker2, fs);

% -------- plot a few figures -----------------
figure;
subplot(4,1,1);
plot(timevec); axis tight; grid on; xlabel('Time Samples @ 44100 Hz');
ylabel('Magnitude'); title('Input Signal versus Time');

subplot(4,1,2);
plot(speaker, '.', 'MarkerSize', 2); axis tight; grid on; xlabel('10 ms Interval');
ylabel('Speaker Classification'); title('Speaker Classification after Error Correction')

subplot(4,1,3);
plot(onlySpeaker1); axis tight; grid on; xlabel('Time Samples @ 44100 Hz');
ylabel('Magnitude'); title('Only Speaker 1 after Diarization');

subplot(4,1,4);
plot(onlySpeaker2); axis tight; grid on; xlabel('Time Samples @ 44100 Hz');
ylabel('Magnitude'); title('Only Speaker 2 after Diarization');


%---- error analysis ----------------
correct = [ones(1,134)*1 ones(1,1038)*2 ones(1,1688)*1];
%orig = double([correct==2; correct==1]);
%test_pre_error = double([speaker_pre_error==2; speaker_pre_error==1]);
%test_post_error = double([speaker==2; speaker==1]);
%plotconfusion(orig, test_post_error, 'MFCC Feautres, Mahalanobis Distance, Post-Error')
%figure(); 
%orig = orig(:, 2: size(orig, 2) - 1);
%plotconfusion(orig, test_pre_error, 'MFCC Features, Mahalanobis Distance, Pre-Error')
