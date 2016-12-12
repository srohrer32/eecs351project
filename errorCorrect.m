% EECS351 Final Project
% rohrer, malinas
% November 10, 2016

function [errorlessSpeaker] = errorCorrect(dilutedSpeaker, timevec)
    correctvec = timevec;
    correctvec(find(abs(timevec) < mean(timevec) + 0.2*std(timevec))) = 0;
    cols = numel(correctvec);
    diluteparam = 44100/10;
    shift = 1;
    dilute = [];
    
    for i = 1:cols-diluteparam
        
            segment = correctvec((i-1)*shift+1: (diluteparam + (i-1)*shift));
      
       
        if(segment == zeros(diluteparam,1))
            dilute = [dilute 0];
        else
            dilute = [dilute 1];
    end
    end
    
end