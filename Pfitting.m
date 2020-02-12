function Pfitting(firstlevel,seclevel,Value,handles)
%plot fitting curve
axes(handles.fitting);
title('')
cla(handles.fitting);
cla(handles.Residue);
[~,Fluo_max_position]=max(handles.dataset.fitting(firstlevel).fit(seclevel).ft.ft(Value).tau(:,1));
[~,Cal_max_position]=max(handles.dataset.fitting(firstlevel).fit(seclevel).ft.ft(Value).tau(:,2));

Fluo_change=findchangepts(handles.dataset.fitting(firstlevel).fit(seclevel).ft.ft(Value).tau(Fluo_max_position:end,1),'MaxNumChanges',1,'Statistic', 'linear');
Cal_change=findchangepts(handles.dataset.fitting(firstlevel).fit(seclevel).ft.ft(Value).tau(Cal_max_position:end,2),'MaxNumChanges',1,'Statistic', 'linear');



 plot(handles.dataset.fitting(firstlevel).fit(seclevel).ft.ft(Value).tau(:,1));
        hold on
        plot(handles.dataset.fitting(firstlevel).fit(seclevel).ft.ft(Value).tau(:,2));
        hold off 
        S=num2str(handles.dataset.fitting(firstlevel).fit(seclevel).ft.S(Value,1),'%0.4f');
        tau=num2str(handles.dataset.fitting(firstlevel).fit(seclevel).ft.S(Value,2));
        title(['S=' S '   ' 'tau=' tau])
if isempty(Fluo_change)~=1 && isempty(Cal_change)~=1
        if Fluo_change>Cal_change
        xlim([0 Fluo_change+500]);
        else
        xlim([0 Cal_change+500]);
        end
end
%plot residue curve:
axes(handles.Residue)

plot(handles.dataset.fitting(firstlevel).fit(seclevel).ft.residue(:,Value))
if isempty(Fluo_change)~=1 && isempty(Cal_change)~=1
        if Fluo_change>Cal_change
        xlim([0 Fluo_change+500]);
        else
        xlim([0 Cal_change+500]);
        end
axes(handles.spectrum_single);
end