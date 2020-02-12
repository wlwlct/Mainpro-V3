function [ccdt_combination_sum,Fluo_dtime_sub,leng_unique]=GenFluodtimesub(handles,fitting_second_cell,rowrange,Fluo_dtime)
datacell_length=length(fitting_second_cell(:,1));
Fluo_dtime_sub=[];
propermatrix=[];
ccdt_combination=[];
for i=1:1:datacell_length 
propermatrix=cat(1,propermatrix,[fitting_second_cell{i,1}:1:fitting_second_cell{i,2}]');
end
propermatrix(isnan(propermatrix))=[];
unique_propermatrix=unique(propermatrix);
leng_unique=length(unique_propermatrix);
leng_matrix=length(propermatrix);
if leng_unique~=leng_matrix
    msgbox('Time overlaps, will continue calculation');
end

if isempty(Fluo_dtime)~=1
    for ii=1:1:leng_unique
        [fitting_start_i,fitting_start_ii]=tran_statenum2sec(unique_propermatrix(ii,1),rowrange);
        fitting_row_start=rowrange(fitting_start_i).rr(1,fitting_start_ii);
        fitting_row_end=rowrange(fitting_start_i).rr(2,fitting_start_ii);
        Fluo_dtime_sub=cat(1,Fluo_dtime_sub,Fluo_dtime(fitting_row_start:fitting_row_end,1));
        ccdt_combination=cat(2,ccdt_combination,handles.dataset.ccdt(:,unique_propermatrix(ii,1)+2));
    end
    ccdt_combination_sum=sum(ccdt_combination(:,:),2);
else
        for ii=1:1:leng_unique
            ccdt_combination=cat(2,ccdt_combination,handles.dataset.ccdt(:,unique_propermatrix(ii,1)+2));
        end
        ccdt_combination_sum=sum(ccdt_combination(:,:),2);
end