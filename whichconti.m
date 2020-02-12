function [i,ii]=whichconti(sec,conti)
conti_length=length(conti(:,1));
for i=1:1:conti_length
    contico_length=length(conti(i).co);
    for ii=1:1:contico_length
        if any(sec==conti(i).co(ii).subco(1,:))
            return
        end
    end
    
end
i=[];
ii=[];
end