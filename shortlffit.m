%For shorlfft is more approximate than realdataset, because it will include
%FLuo datapoints in dead time. But I assume it won't influence
%much....influence 1s with 0.08 8% influence...

function fitting=shortlffit(tau,Fluo_dtime,IRFI_hisdtime,IRFI_resolution,handles,shift)
%Prepare

cd(handles.program_folder)
IRF_data_length=length(IRFI_hisdtime);
IRFI_bg=sum(IRFI_hisdtime(end-1100:end-100))/1000;
comparerange_CALC=tau*10/IRFI_resolution;
Fluo_max=max(Fluo_dtime);
if comparerange_CALC>=IRF_data_length
    if comparerange_CALC<Fluo_max
        comparerange_CALC=Fluo_max;
    end
    cpst_n=comparerange_CALC-IRF_data_length;
    cpst=ones(cpst_n,1)*IRFI_bg;
    IRFI_hisdtime=cat(1,IRFI_hisdtime,cpst);
else
        if Fluo_max<=IRF_data_length
    comparerange_CALC=IRF_data_length;
        else
        comparerange_CALC=Fluo_max;
        cpst_n=comparerange_CALC-IRF_data_length;
        cpst=ones(cpst_n,1)*IRFI_bg;
        IRFI_hisdtime=cat(1,IRFI_hisdtime,cpst);
        end
end
tau=tau/IRFI_resolution;%This part transfer to bin number
[CALC,TOTSIG]=GenCALC_M_PTU(tau,comparerange_CALC);
DISTORED=GenDISTORED_M_PTU(CALC,IRFI_hisdtime,TOTSIG,comparerange_CALC);
Fluo_edg=1:1:max(Fluo_dtime);
if length(Fluo_dtime)==0
     fitting=0;
   return
end
%all=histogram(Fluo,Fluo_edg);
[Fluo_N,Fluo_edge]=histcounts(Fluo_dtime,Fluo_edg);
%Fluo_N_fit=sgolayfilt(Fluo_N,3,111);
Fluo_N_fit=smoothdata(Fluo_N,'sgolay',40);
Fluo_N_fit_bg=sum(Fluo_N_fit(1,end-1100:end-100))/1000;
Fluo_N=Fluo_N-Fluo_N_fit_bg;

if length(find(Fluo_N>=5))==0
    fitting=0;
   return
end

if length(find(Fluo_N~=0))<=250
     fitting=0;
   return
end

Fluo_N_fit=smoothdata(Fluo_N,'sgolay',40);
[Fluo_N_fit_max,Fluo_N_fit_max_position]=max(Fluo_N_fit);
% [Fluo_N_max,Fluo_N_max_position]=max(Fluo_N);
% if Fluo_N_max>1.2*Fluo_N_fit_max || Fluo_N_max<1.2*Fluo_N_fit_max
% Fluo_max=Fluo_N_max;Fluo_max_position=Fluo_N_max_position;
% else
    Fluo_max=Fluo_N_fit_max;Fluo_max_position=Fluo_N_fit_max_position;
% end
[DISTORED_max,DISTORED_max_position]=max(DISTORED);
position_difference=Fluo_max_position-DISTORED_max_position-shift;
if position_difference>0
   Fluo_sub=cat(2,Fluo_N(1,position_difference:end),Fluo_N(1,1:position_difference-1));
else
    Fluo_sub=cat(2,Fluo_N(1,end+position_difference+1:end),Fluo_N(1,1:end+position_difference));
end
Fluo_sub_length=length(Fluo_sub);
if length(DISTORED)>=Fluo_sub_length;
   DISTORED=DISTORED(1:Fluo_sub_length,1); 
end
Fluo_sub=Fluo_sub./Fluo_max;


%get parameter
 
      fitting.s=sum((transpose(Fluo_sub)-DISTORED).^2)/Fluo_sub_length;
      fitting.ft=cat(2,transpose(Fluo_sub),DISTORED);
      fitting.residue=transpose(Fluo_sub)-DISTORED;
   
    if isempty(fitting);
     fitting=0;
    end
    
    cd(handles.program_folder);
end