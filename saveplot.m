function saveplot(handles)
initial_axes=gca;
initial_figure=gcf;
filename=get(handles.Location_of_file,'string');
Yes_timetrace=get(handles.save_timetrace,'Value');
Yes_mesh=get(handles.save_mesh,'Value');
Yes_2D=get(handles.save_2D,'Value');
Yes_scplot=get(handles.save_scplot,'Value');
Yes_autofit=get(handles.save_autofit,'Value');
Yes_manualfitting=get(handles.save_manualfitting,'Value');
if Yes_timetrace==1
axes(handles.Time_trace)
    fig_tt=get(initial_figure.CurrentAxes,'Children');
    figure
    ftt=axes;
    copyobj(fig_tt,ftt);
savefig(fullfile(handles.data_folder, [filename 'Time trace.fig']));
end
if Yes_mesh==1
    axes(handles.Spectrum_all);
    fig_me=get(initial_figure.CurrentAxes,'Children');
    figure
    fme=axes;
    copyobj(fig_me,fme);
    savefig(fullfile(handles.data_folder, [filename 'Mesh.fig']));
end
if Yes_2D==1
    axes(handles.spectrum_single);
    fig_2D=get(initial_figure.CurrentAxes,'Children');
    figure
    f2d=axes;
    copyobj(fig_2D,f2d);
    savefig(fullfile(handles.data_folder, [filename '2D spectrum.fig']));
end
if Yes_scplot==1
    axes(handles.Scatter_plot)
    fig_sc=get(initial_figure.CurrentAxes,'Children');
    figure
    fsc=axes;
    copyobj(fig_sc,fsc);
    savefig(fullfile(handles.data_folder, [filename 'scplot.fig']));
end
if Yes_autofit==1
    %f = figure('Visible','off');
    axes(handles.fitting)
    auto1=get(initial_figure.CurrentAxes,'Children');
    axes(handles.Residue)
    auto2=get(initial_figure.CurrentAxes,'Children');
    figure
    s1=subplot(2,1,1);
    s2=subplot(2,1,2);
    copyobj(auto1,s1); %copy children to new parent axes i.e. the subplot axes
    copyobj(auto2,s2);
    savefig(fullfile(handles.data_folder, [filename 'Autofit.fig']));
end
if Yes_manualfitting==1
    axes(handles.fitting_manual);
    manual1=get(initial_figure.CurrentAxes,'Children');
    axes(handles.Manual_Residue);
    manual2=get(initial_figure.CurrentAxes,'Children');
    figure
    s3=subplot(2,1,1);
    s4=subplot(2,1,2);
    copyobj(manual1,s3); %copy children to new parent axes i.e. the subplot axes
    copyobj(manual2,s4);
    savefig(fullfile(handles.data_folder, [filename 'Manual.fig']));
end

axes(initial_axes);


end