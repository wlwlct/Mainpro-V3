function scplot(handles)
%No legend for two reason, first,it gonna make the plot slow, second, it
%keep changing, maybe non accurate.
axes(handles.Scatter_plot);
cla(handles.Scatter_plot);
select=get(handles.BG_A,'SelectedObject');
choice=get(select,'string');

datause=get(handles.BG_datause,'SelectedObject');
ComorGen=get(datause,'string');
    %Use Threshold to eliminate some data.
Threshold=str2num(get(handles.EB_threshold,'String'));
index=find(handles.dataset.scatterplot.intensity(1,:)>=Threshold);
    lf_S=handles.dataset.scatterplot.lifetime(index,1);
    lf=handles.dataset.scatterplot.lifetime(index,2);
    lf_pos=handles.dataset.scatterplot.lifetime(index,3);
    lf_neg=handles.dataset.scatterplot.lifetime(index,4);
    apdint=handles.dataset.scatterplot.intensity(1,index);
    ccdint=handles.dataset.scatterplot.intensity(2,index);
    
    if strcmp(ComorGen,'Combine')
            colormatrix=zeros(1,handles.xupper);
            colormatrix(handles.dataset.allsecs(1,:))=1;
            colormatrix=colormatrix(1,index);
            if length(unique(colormatrix))==1
                colormatrix='b';
            end
            weightwave=handles.dataset.scatterplot.newspectrum(index,1);

    else
        weightwave=handles.dataset.scatterplot.spectrum(index,1);
    end


if strcmp(choice,'A')==1
title('Lifetime/Intensity/Wavelength')
Life=get(handles.Lifetime,'Value');
Int=get(handles.Intensity,'Value');
wave=get(handles.Wavelength,'Value');
err=get(handles.Err,'Value');
total=Life+Int+wave;
if total >=2
    avelifetime=mean(lf);
    apdint=apdint/mean(apdint)*avelifetime;
    ccdint=ccdint/mean(ccdint)*avelifetime;
    weightwave=weightwave/mean(weightwave)*avelifetime;
end

x=[index]';
        
if Life==1
        xlabel('Exp time (s)');
        ylabel('Lifetime (ps)');

                if err==1
                errorbar(x,lf,lf_pos,lf_neg, 'o');
                else
                      if strcmp(ComorGen,'Combine')
                scatter(x,lf,[],colormatrix,'o') 
                      else
                          plot(x,lf,'o')
                      end
                end
%                 text(x,lf,lf_S-1,'\ast','HorizontalAlignment','center')
% zlim([-0.15 0.15]);
%                 title('lifetime and spectrum')
                hold on
        end
        if Int==1
        %yyaxis right
        plot(x,apdint,'x');
        hold on
        plot(x,ccdint,'p');
        hold on
        xlabel('Exp time (s)');
        ylabel('Intensity (counts/sec)');
        end

        if wave==1
              if strcmp(ComorGen,'Combine')
        scatter(x,weightwave,[],colormatrix,'d')
              else
        plot(x,weightwave,'d');
              end
        hold on
        xlabel('Exp time (s)')
        ylabel('Average Wavelength (A)')
        end
        
        if total >=2
        title('Compare')
        xlabel('Exp time (s)')
        ylabel('Lifetime (ps)')
        end        
        
else
    
    
lifetime_intensity=get(handles.Lifetime_Intensity,'Value');
lifetime_wavelength=get(handles.Lifetime_Wavelength,'Value');
wavelength_intensity=get(handles.Wavelength_Intensity,'Value');



if lifetime_intensity==1 || lifetime_wavelength==1 ||wavelength_intensity==1

if lifetime_intensity==1
set(handles.Lifetime_Wavelength,'enable','off');
set(handles.Wavelength_Intensity,'enable','off');
    plot(lf,apdint,'d');
title('Lifetime vs Intensity')
xlabel('Lifetime')
ylabel('Intensity')
end

if lifetime_wavelength==1
        set(handles.Lifetime_Intensity,'enable','off');
set(handles.Wavelength_Intensity,'enable','off');
% scatter(lf,weightwave,'p',[],colormatrix)
if strcmp(ComorGen,'Combine')
scatter(lf,weightwave,[],colormatrix,'p') 
else
scatter(lf,weightwave,'p') 
end
title('Lifetime vs Wavelength')
xlabel('Lifetime')
ylabel('Wavelength')
end

if wavelength_intensity==1
        set(handles.Lifetime_Intensity,'enable','off');
set(handles.Lifetime_Wavelength,'enable','off');
plot(weightwave,apdint,'h'); 
title('Wavelength vs Intensity')
xlabel('Wavelength')
ylabel('Intensity')
end






else
    set(handles.Lifetime_Intensity,'enable','on');
set(handles.Lifetime_Wavelength,'enable','on');
set(handles.Wavelength_Intensity,'enable','on');
title('')
xlabel('')
ylabel('')
end             
end
end