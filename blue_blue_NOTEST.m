%02/22/2018This program is designed for generate proper struct data for my app to
%analyse.The struct should contain 1. time trace for generate the
%corresponding time trace and state seperation. 2. ccdt which include all
%spectrum data we get for each integration time. 3.scatter plot, which
%requires lifetime, intensity, average spectrum for each sec and
%corresponding to each other. 4.fitting for each fitting part, for the r
%value larger than 80%, we will store our data in a struct with all the
%fitting we have done....

clear all
%%
%This part is for chose the direction of apd file, then automatically run
%files
cd('C:\Users\Livi\Documents\Results')
srcDir=uigetdir('Choose source ccd source folder directory.');
cd(srcDir);
allnames=struct2cell(dir('*.mat'));
[k,len]=size(allnames);
date='01032018'
inttime=1;%This is time in sec
deadtime=0.08;%This is time in sec
clearvars -except len_i date k len allnames inttime deadtime
%%
%name=char(allnames(1,len_i));
%name=name(1:length(name)-4);
name='1.1.1';
cd('C:\Users\Livi\Desktop\spectrum with lifetime？')
ccd_file = ['C:\Users\Livi\Documents\Results\' date '\ccd\' name '.asc']
ccdt=importdata(['C:\Users\Livi\Documents\Results\' date '\ccd\' 'ccdt' name '.mat']);
expwl=importdata(['C:\Users\Livi\Documents\Results\' date '\ccd\' 'ccdt_wavelength' name '.mat']);
%This part import time trace.
timetrace_filename=['C:\Users\Livi\Documents\Results\' date '\apd\' name '.dat']; %获得选择的文件夹
timetrace=importdata(timetrace_filename);
time=timetrace.data(:,1);
countsrate=timetrace.data(:,2)*10;%Time rates is in 10ms
[eff,eff_fit,MDL,numst,current_state]=Traceson(countsrate);%this for seperate into different states
 
%Generate the place the change occur,the last element of former segment;
n=1;
for i=2:length(eff_fit(numst,:))
   if eff_fit(numst,i-1)~=eff_fit(numst,i) 
    stage_changepts(n,1)=i-1;%This should be the last element of one segment
   n=n+1;
   end
end

stage_start=zeros(length(stage_changepts),1);
for i=1:length(stage_changepts)
    stage_start(i,1)=time(stage_changepts(i,1),1);%Generate time corresponding to stage change
end
stage_start=cat(1,0,stage_start.*(1*10^9));%make the unit from sec to nanosec,and start with time zero

%compare with perfectime, find another loop or something...
%change rowrange to rowrange.rr(i), in this case, we are able to seperate each
%rr as different state and easier to work on.

apd_file=['C:\Users\Livi\Documents\Results\' date '\apd\' name '.mat']
Fluodata=importdata(apd_file);

%This need to be full set, which means it need to be at 7th column is
%lifetime. If you want to choose a range or anything, you still need to put in same size matrix 

%
%This for find the shutter open point of fluorescene.
for i = 1:length(Fluodata)
    if Fluodata(i,6) == 15 
        count1 = 0;
    elseif Fluodata(i,6) == 1 && count1 <4%This mean when "1" contimuously shows up 3 times, we choose as the start point.
        count1 = count1+1;
    elseif Fluodata(i,6) == 1 && count1 == 4
       Fluodata_startrow = i-4;
       break
    end
end

%
%This is for dissect data to 1 sec time range, or several time range when
%points are not enough.
ttstart=Fluodata(Fluodata_startrow,2);
ttend=Fluodata(end,2);
exptime = ttend;
perstartt = ttstart;
perfecttime =[];%matrix for the desired timeline
con1=1;
while (perstartt<=exptime-inttime*10^9)%要是endtime满足starttime不满足呢，startime应该会超过去
    perfecttime(1,con1) = perstartt;
    perstartt = perstartt+inttime*10^9+deadtime*10^9;
    con1=con1+1;
end

%%This part to seperate the perfectime in different state, so we can use
%%seperate different row range in different state,then based on the state,
%%if unique 2 states, then calculate fist 1/2, and last 1/3,if more than
%%unique 2 states, then just alculate based on each second first, if you
%%couldn't get any lifetime based on one second, then just add up following
%%rowrange, untill we can get a proper lifetime. If we couln't
%%(unlikely),just let it go.

%
s=Fluodata_startrow;
rowrange = [];
stagestart_n=2;
strow=0;

for n = 1:length(perfecttime)%加1是为了保证剩下的数据也全部的加上，要不然由于限制条件的存在，最后不到1s的数据不会有    
    while (Fluodata(s-1,2)<perfecttime(1,n))%using s-1 could avoid the fist start data lager then first perfect time, it could change to start from the first num in the column if wanted
        s=s+1;%所取的格子，大于实际的格子
    end
        srn = s;%start row number
    while (Fluodata(s,2)<(Fluodata(srn,2)+inttime*10^9))
        s=s+1;%所取的格子大于实际的格子,有利的的是就算最后一个不足1s的积分直接被扔掉，因为前面perfectime限制条件的原因
    end
        ern = s;%end row number
%This part use two 'if' to put data into different state...
    if stagestart_n<=length(stage_start)
        if stage_start(stagestart_n-1,1)<=perfecttime(1,n) && perfecttime(1,n)<=stage_start(stagestart_n,1)
    strow = strow+1;
    rowrange(stagestart_n-1).rr(1,strow)=srn;
    rowrange(stagestart_n-1).rr(2,strow)=ern;
    
        elseif perfecttime(1,n)>stage_start(stagestart_n,1)
    strow=1;
    stagestart_n=stagestart_n+1;
    rowrange(stagestart_n-1).rr(1,strow)=srn;
    rowrange(stagestart_n-1).rr(2,strow)=ern;
        end        
    else
    strow = strow+1;
    rowrange(stagestart_n-1).rr(1,strow)=srn;
    rowrange(stagestart_n-1).rr(2,strow)=ern;    
        
        end
end
if length(rowrange(1).rr)==0;
    rowrange(1)=[];
end

%
%This is the part for generate lifetime for each part
IRFI_sub_file=strcat('C:\Users\Livi\Documents\Results\01182018-for deconvolution\IRFI_sub_linear.mat');
IRFI_sub=importdata(IRFI_sub_file);
comparerange=900;
sortlf=[];
lf=[];
cd('C:\Users\Livi\Desktop\spectrum with lifetime？')

%For generating picture purpose, I will introduce variable 'js' to check
%what is the second number.
%%%for name
%js=0;
%%%
for n=1:length(rowrange)
    [~,rowrange_heng]=size(rowrange(n).rr);
    zeroplace(n).zp(1,1)=0;
    ii=0;
for i=1:rowrange_heng
    %%%For name
    %js=js+1;
    %%%
Fluodata_sub=Fluodata(rowrange(n).rr(1,i):rowrange(n).rr(2,i),1:7);
[Live(n).lifetime(i).ll, ~]=lifetimefitson_CHM232(Fluodata_sub,comparerange,IRFI_sub);%By using this, need to find your own range....
if Live(n).lifetime(i).ll == 0
    %find the place equal to zero in each state.
        ii=ii+1;
    zeroplace(n).zp(ii,1)=i;
end
end

%
%Also you need to check which part is continuous zero. I check by minus
%former value. I also put different set of continuous part in 'matrix
%conti',column direction is different set

%If zero place is inside, one of the problem is that zero won't produce
%unless the next value shows up, I think...
if length(zeroplace(n).zp)>=2;j=1;k=1;q=1;
for i=1:length(zeroplace(n).zp)-1
        if zeroplace(n).zp(i,1)==zeroplace(n).zp(i+1,1)-1
        q=0;
        conti(n).co(j,k)=zeroplace(n).zp(i,1);
        k=k+1;
            if i==length(zeroplace(n).zp)-1
                conti(n).co(j,k)=zeroplace(n).zp(i+1,1);
            end
        
        else
            if q~=1
            conti(n).co(j,k)=zeroplace(n).zp(i,1);
            j=j+1;% j for each continuous 1 put in one row,change different row for different set of       
            q=1;k=1;
            end
        end
        
end        
end
end
%%
%This part is another for loop for calculate rearranged data.
%If the zero is continuous, add up nearby two set of data, recalculate lifetime again;if the zero is not
    %continuous,give up there might be some extra problem that we need to
    %solve. Similar to Lifetime calculation
    
    
    %Avoid the confucion and easier the cauculation, if the 0 more than 
    %js_n=0;
for n=1:length(rowrange)
    [conti_zong,~]=size(conti(n).co);
  
    
    if numel(conti(n).co)~=0
    for iii=1:conti_zong
      zerolength=length(find(conti(n).co(iii,:)>0));
                if zerolength<30;
                    Fluodata_sub=Fluodata(rowrange(n).rr(1,conti(n).co(iii,1)):rowrange(n).rr(2,conti(n).co(iii,1)),1:7);
                    for k=1:zerolength-1;
                    Fluodata_sub=cat(1,Fluodata_sub,Fluodata(rowrange(n).rr(1,conti(n).co(iii,1+k)):rowrange(n).rr(2,conti(n).co(iii,1+k)),1:7));                  
                    end
                    %%%For name
                    %js=js_n+conti(n).co(iii,1);               
                   %%%
                    [Live(n).lifetime(conti(n).co(iii,1)).ll, ~]=lifetimefitson_CHM232(Fluodata_sub,comparerange,IRFI_sub);
                    for k=1:zerolength-1
                    Live(n).lifetime(conti(n).co(iii,1+k)).ll=Live(n).lifetime(conti(n).co(iii,1)).ll;
                    end
                    
                elseif zerolength>=30
      %Then we need to calculate from both side, then compare with each
      %other, basically we need to seperate the zeros into 3 parts, with
      %intersection of 10s, then we will calculate from both side, then
      %lets see what's the proble lifetime for both side.
                    callength=floor((zerolength-10)/2)-1;%with minus one to eliminate the chance of over exceed the length
                    %for claculate and write in the first half
                    Fluodata_sub=Fluodata(rowrange(n).rr(1,conti(n).co(iii,1)):rowrange(n).rr(2,conti(n).co(iii,1)),1:7);
                    for k=1:callength-1
                    Fluodata_sub=cat(1,Fluodata_sub,Fluodata(rowrange(n).rr(1,conti(n).co(iii,1+k)):rowrange(n).rr(2,conti(n).co(iii,1+k)),1:7));                  
                    end
                    %%%For name
                     %js=js_n+conti(n).co(iii,1); 
                     %%%
                    [Live(n).lifetime(conti(n).co(iii,1)).ll, ~]=lifetimefitson_CHM232(Fluodata_sub,comparerange,IRFI_sub);
                    for k=1:callength-1
                        Live(n).lifetime(conti(n).co(iii,1+k)).ll=Live(n).lifetime(conti(n).co(iii,1)).ll;
                    end
                    
                    %for calculate and write in the second half 
                    k=callength+10;
                    kk=callength+10;
                    Fluodata_sub=Fluodata(rowrange(n).rr(1,conti(n).co(iii,k)):rowrange(n).rr(2,conti(n).co(iii,k)),1:7);
                    for k=callength+10:zerolength-1
                    Fluodata_sub=cat(1,Fluodata_sub,Fluodata(rowrange(n).rr(1,conti(n).co(iii,1+k)):rowrange(n).rr(2,conti(n).co(iii,1+k)),1:7));
                    end
                    %%%For name
                     %js=js_n+conti(n).co(iii,k);
                     %%%
                    [Live(n).lifetime(conti(n).co(iii,kk)).ll, ~]=lifetimefitson_CHM232(Fluodata_sub,comparerange,IRFI_sub);
                    
                    for k=callength+10:zerolength-1
                        Live(n).lifetime(conti(n).co(iii,k+1)).ll=Live(n).lifetime(conti(n).co(iii,kk)).ll;
                    end
                end      
        %also later would add on how to deal with different stage, two stage or
    %two more, we will treat them differently.
    end
    end   
    
    %%%For name
     %   [~,rowrange_heng]=size(rowrange(n).rr);
    %js_n=js_n+rowrange_heng;
    %%%
    
end


%%
% this part could transfer the ensemble data from different segments to one
% matrix with lifetime for each second.
i=0;
for n=1:length(Live)
    [~,lifetime_heng]=size(Live(n).lifetime);
    for ii=1:lifetime_heng
        [lf_max,lf_max_position]=max(Live(n).lifetime(ii).ll(:,1));
    if lf_max~=0
    lf(i+ii,1)=lf_max;%for If the first column is the max r value, second is corresponsing lifetime,third is lowest r, forth is highest r, fifth is lowest lifetime, sixth is highest lifetime.
    lf(i+ii,2)=Live(n).lifetime(ii).ll(lf_max_position,2);
    %then put the lifetime into the matrix, before reorder the r squre value.
    lf(i+ii,5)=Live(n).lifetime(ii).ll(1,2);
    lf(i+ii,6)=Live(n).lifetime(ii).ll(end,2);
    
    sortlf=sort(Live(n).lifetime(ii).ll(:,1));% by using sort, it from lowest number to highest number.
    lf(i+ii,3)=Live(n).lifetime(ii).ll(1,1);
    lf(i+ii,4)=Live(n).lifetime(ii).ll(end,1);
% they do not have corresponding relationship.
    end
    end
    i=lifetime_heng+i;
end


%
%plot the graph
if length(lf)~=0

[lf_v,~]=size(lf);
[wl_v,~]=size(expwl);
%plot
    if lf_v>=wl_v
    %lf_max=max(lf(1:wl_v-1,2));%max value is for normalization, may bring some
    %erro, not use here for now
    %expwl_max=max(expwl(2:end,1));
    lfneg=lf(1:wl_v-1,5)-lf(1:wl_v-1,2);
    lfpos=lf(1:wl_v-1,6)-lf(1:wl_v-1,2);
    lfwl=cat(2,lf(1:(wl_v-1),2),expwl(2:end,1).*8);%minus one is due to first element of expwl is 0. in order to make the dimension match each other.
    else
    %lf_max=max(lf(:,2));
    %expwl_max=max(expwl(2:lf_v,1));
    lf=cat(1,lf,zeros(wl_v-lf_v-1,6));
    lfneg=lf(:,5)-lf(:,2);
    lfpos=lf(:,6)-lf(:,2);
    lfwl=cat(2,lf(:,2),expwl(2:end,1).*8);% same as minus one
    end
%%
figure
hold off
subplot(3,4,[7 8 11 12]);
title('lifetime and spectrum')
x=1:length(lfwl(:,1));
%scatter3(x,lfwl(:,1),lf(x,1),'o');
errorbar(x,lfwl(:,1),lfneg,lfpos, 'o');
text(x,lfwl(:,1),lf(x,1)-1,'\ast','HorizontalAlignment','center')
zlim([-0.15 0.15]);


hold on 
plot(lfwl(:,2),'o');
legend('lifetime','wavelength (pixel*8)')%using normalized picture will miss some important points, such as in raster scan, the dark position seems to be blue emission.

else
    subplot(3,4,[7 8 11 12]);
    title('spectrum')
    plot(expwl.*8,'o');
    xlabel('Lifetime not work for this file...sad...')
    %print=['Not working for this file....sad....']
end

%%
%This part plot time trace in the subplot of (3,4,[1 2])(3,4,3)(3,4,4)
    
    numst = min(numst, numel(MDL));
    current_state = numst;
    subplot(3,4,3);
    %state plot is for histogram
    cd('C:\Users\Livi\Desktop\seperating state')
    state_plot(numst,eff,eff_fit,MDL);
    title('Intensity horizontal histogram')
    
    subplot(3,4,[1 2]);
    slider_plot(eff,eff_fit,current_state);
    title(strcat('Time Trace ', ' Choosing ',num2str(numst),' states'))
    
    subplot(3,4,4);
    spider_plot(MDL,numst);
    title('MDL vs. States')

%%
%This part for generate ccd spectrum
subplot(3,4,[5 6 9 10]);
hold
mesh(ccdt);title('spectrum');
%%
%This is the part for saving graph
try
cd (['C:\Users\Livi\Documents\Results\' date '\Figure intermediates'])
catch
    cd(['C:\Users\Livi\Documents\Results\' date ''])
    mkdir Figure intermediates
    cd (['C:\Users\Livi\Documents\Results\' date '\Figure intermediates'])
end
savefig([name '.fig'])
close all