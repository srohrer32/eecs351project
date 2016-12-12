% EECS351 Final Project
% rohrer, malinas
% December 10, 2016

function [dilutedSpeaker] = dilute(speaker, diluteparam, cols)
shift = diluteparam;
dilute = [];
for i = 1:floor(cols/diluteparam)
    if(i == floor(cols/diluteparam))
        segment = speaker((i-1)*diluteparam+1:end);
    else
        segment = speaker((i-1)*shift+1: (diluteparam + (i-1)*shift));
    end
    
    if(numel(find(segment == 1)) > numel(find(segment == 2)) & numel(find(segment ==1)) > numel(find(segment==3)))
        dilute = [dilute 1];
    elseif(numel(find(segment == 2)) > numel(find(segment == 1)) & numel(find(segment == 2)) > numel(find(segment == 3)))
        dilute = [dilute 2];
    else
        dilute = [dilute 3];
    end
    
end
dilutedSpeaker = dilute;
end