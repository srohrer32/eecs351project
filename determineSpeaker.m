% EECS351 Final Project
% rohrer, malinas
% December 10, 2016
% determineSpeaker: given 1 vector of MFCC coefficients for a 30 ms time
% window, determine which speaker most likely spoke using Mahalanobis
% distances and the covariance matrix of each speaker's database vectors

%S1, S2 are covariance matrices of speaker 1 and 2 respectively
%mean1 and mean2 are vector means of database vectors of speaker 1 and speaker 2,
%respectively

function [speaker] = determineSpeaker(S1, S2,mean1, mean2,melVec)
    %cholesky decomposition of covariance matrix of speaker 1's
    %database
    L1 = chol(S1, 'lower');
    
    %this solves L^-1 * x, where x is the mel vector with
    %speaker 1's mean subtracted from it
    y1 = L1\(melVec.' - mean1.');
    
    %this is the square root of the two norm of L^-1 * x
    %i.e. the Mahalanobis distance
    d1 = sqrt(sum(y1.^2));
    
    %same as above for speaker 2
    L2 = chol(S2, 'lower');
    y2 = L2\(melVec.' - mean2.');
    d2 = sqrt(sum(y2.^2));
   
    %determines which distance is smaller
   
        [minDist, I] = min([d1 d2]);
    
    
    %return estimated speaker
    speaker = I;
end