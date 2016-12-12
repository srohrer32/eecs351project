% EECS351 Final Project
% rohrer, malinas
% December 10, 2016

function [dilutedSpeaker] = diluteSilence(silentVec, numSamples)
	lenSilentVec = numel(silentVec);
	diluted = [];
	for i=0:(lenSilentVec/numSamples)-1
		newVec = silentVec(i*numSamples + 1: (i+1)*numSamples);
		% count number of 0s and 1s 
		num0 = numel(find(newVec == 0)) / 441;
		num1 = numel(find(newVec == 1)) / 441;

		% determine if mostly 0s or 1s
		if num0 > 0.1
			diluted = [diluted 0];
		else
			diluted = [diluted 1];
		end

		dilutedSpeaker = diluted;
	end
end