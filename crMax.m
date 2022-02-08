function [cxnum,rynum] = crMax(colsum,rowsum)
    cx = max(colsum);
    ry = max(rowsum);
    for i = 1:length(colsum)                                %  i in range(len(colsum))
        if colsum(i)==cx
            cxnum=i;
        end
    end
    for i = 1:length(rowsum)                                %i in range(len(rowsum))
        if rowsum(i)==ry
            rynum=i;
        end
    end
end

