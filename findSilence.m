function [out] = findSilence(timevec)
    correctvec = timevec;
    correctvec(find(abs(timevec) < mean(timevec) + 0.2*std(timevec))) = 0;
    diluteparam = 44100/100;
    B = 1/diluteparam*ones(diluteparam,1);
    out = filter(B,1,correctvec);
    thresh = 0.02*std(timevec);
    out(out~=0) = 1;
end