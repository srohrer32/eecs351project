% EECS351 Final Project
% rohrer, malinas
% December 7, 2016

function [movingAvg] = speakerAvg(silentVec, numSpeakers, filterparam)
	movingAvg = [];
	for i=1:numel(silentVec)
		% check if its not far enough in the signal
		divisor = 0;
		if i < filterparam + 1
			sumVec = silentVec(1:i);
			divisor = i;
		else
			sumVec = silentVec(i-filterparam: i);
			divisor = filterparam;
		end
		% compute the sum of the silent Vector
		sumPrev = sum(sumVec);
		numZeros = sum(sumVec == 0);
		divisor = divisor - numZeros;
		currAvg = sumPrev / divisor;
		movingAvg = [movingAvg currAvg];
	end
end