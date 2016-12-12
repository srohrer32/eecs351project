function [speaker] = determineSpeakerkth(db1, db2, melVec)
%tic
    size1 = size(db1);
    size2 = size(db2);
    k = 5;
    melmat = diag(melVec);
    onesmat = ones(size1(2), size1(1));
    mat1 = melmat*onesmat;
    onesmat = ones(size2(2), size2(1));
    mat2 = melmat*onesmat;
    
    dist1 = mat1.'-db1;
    dist2 = mat2.'-db2;
    
    maxdist1 = [];
    for(i = 1:size1(1))
        maxdist1 = [maxdist1 norm(dist1(i,:))];
        if(numel(maxdist1) == k+1)
            [M,I] = max(maxdist1);
            maxdist1(I) = [];
        end
    end
    
    maxdist2 = [];
    for(i = 1:size2(1))
        maxdist2 = [maxdist2 norm(dist2(i,:))];
        if(numel(maxdist2) == k+1)
            [M,I] = max(maxdist2);
            maxdist2(I) = [];
        end
    end
    
    maxconcat = [maxdist1 maxdist2];
    [~,indsort] = sort(maxconcat);
    
    if(numel(find(indsort(1:k)<=k)) > numel(find(indsort(1:k)>k)))
        speaker = 1;
    else 
        speaker = 2;
    end
    %toc
end