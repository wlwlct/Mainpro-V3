function sec=x2sec(clickvalue,perfecttime)
AmiB=-(perfecttime./(1*10^9)-clickvalue);
AmiB(AmiB<0)=[];

if isempty(AmiB)
sec=0;
else
[~,sec]=min(AmiB);






end