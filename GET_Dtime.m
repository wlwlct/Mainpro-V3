function data=GET_Dtime(PTU_raw,channel,marker)
if nargin==3
if strcmp(marker,'M')
    try
    PTU_raw=PTU_raw(find(PTU_raw(:,2)==3,1):end,:);
    catch
    error('This file do not have a marker.')    
    end
end
end
photon=PTU_raw(PTU_raw(:,2)==9,:);
data=photon(photon(:,3)==channel,6);

end