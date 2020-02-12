%This program is an intermediate between the app and the 'fig file', which
%gives you some insights about the data. Beacause the initial plane based
%on the output file 'dataset'. This program will read the dataset and show
%you the results.
%
clear all
tau=400;
%% Choose proper datapoint for generate the graph,input
spectrum_start=5;
spectrum_end=5;
lifetime_start=5;
lifetime_end=5;
tau=400;
manual='no'
data='yes'


%%
%read the dataset file
file_path='C:\Users\Livi\Documents\Results\02072018\dataset intermediates\dataset1.1.1.mat'
dataset=importdata(file_path);

%%
%get the spectrum for desired sec
%If it's only for one sec
ccdt_2D=dataset.ccdt(:,spectrum_start:spectrum_end);
figure;
subplot(1,2,1);
if spectrum_start==spectrum_end
    plot(ccdt_2D);
else
    mesh(ccdt_2D);
end
%%
%get desired fitting curve based on the time range you choose, compare
%manually or compare based on the best fitting result?
% if you want to use the generated data to see, I would say you may see
% some empty matrix




%Use saved data
[~,rowrange_zong]=size(dataset.rowrange)
%read from already calculated lifetime. This only works for one sec...
if strcmp(data,'yes')==1
ad=0;
if lifetime_start~=lifetime_end
disp('this part only works for one sec')
else
    for i=1:rowrange_zong
   [zong,heng]=size(dataset.rowrange(i).rr) 
    
   for ii=1:heng
       ad=ad+1;
       if ad==lifetime_start
           start_i=i;
           start_ii=ii;
           break
       end        
   end
   if ad==lifetime_start
       break
   end
    end    
    
    Fluo_sub=dataset.fitting(start_i).fit.ft(start_ii).ft(:,1);
    DISTORED=dataset.fitting(start_ii).fit.ft(start_ii).ft(:,2);
    r=dataset.fitting(start_ii).fit.ft(start_ii).r;
    tau=dataset.fitting(start_ii).fit.ft(start_ii).tau;
    
    subplot(1,2,2)
    plot(Fluo_sub);
    hold on
    plot(DISTORED);
    title(['tau=' num2str(tau) ' r=' num2str(r)]);
end
end







%Manually calculate the lifetime


if strcmp(manual,'yes')==1
%If you want to mannually calculate to see

%Choose the range

%Code for select desired rowrange corresponding to input sec.
[rowrange_heng,rowrange_zong]=size(dataset.rowrange);
rowsec=[];
for i=1:rowrange_zong
    rowsec=cat(2,rowsec,dataset.rowrange(i).rr);
end


%[filename,pathname]=uigetfile('*.mat','Fluorescence data',0,0);
%location=strcat(pathname,'/',filename);
location='C:\Users\Livi\Documents\Results\02072018\apd\1.1.1.mat'
Flu=importdata(location);
start=rowsec(1,lifetime_start);
final=rowsec(2,lifetime_end);
Fluofile=Flu(start:final,1:7);

IRFI_sub_file=strcat('C:\Users\Livi\Documents\Results\01182018-for deconvolution\IRFI_sub_linear.mat');
IRFI_sub=importdata(IRFI_sub_file);
comparerange=900;
DISTORED=[];
[CALC,TOTSIG]=GenCALC(tau,comparerange);
DISTORED=GenDISTORED_M(CALC,IRFI_sub,comparerange,TOTSIG);

for iii=1:1
Fluo=Fluofilename(:,7);
Fluo(isnan(Fluo))=[];
Fluo_edg=[1:1:max(Fluo)];
if length(Fluo)==0
   disp('Not enough points to calculate the result')
   break
end

[Fluo_N,Fluo_edge]=histcounts(Fluo,Fluo_edg);
[Fluo_max,Fluo_max_position]=max(Fluo_N);
Fluo_dect_range=Fluo_N(1,1:Fluo_max_position);

try
Fluo_startpoint=findchangepts(Fluo_dect_range,'MaxNumChanges',1,'Statistic','linear');
catch 
disp('Not be able to find the change point(May caused by low S/N)')
break
end


%Part IV.1: The Fluo_N has limited data which is useless for cauculating
if length(Fluo_N)<=250
disp('Not enough points to calculate the result')
break
end

if Fluo_startpoint==[] 
disp('Not be able to find the change point(May caused by low S/N)')
break
end

if length(find(Fluo_N>=5))==0
disp('Not be able to find the change point(May caused by low S/N)')
break
end

if length(find(Fluo_N~=0))<=250
disp('Not be able to find the change point(May caused by low S/N)')
break
end

if  length(Fluo_edge)<(Fluo_startpoint+comparerange)
    compensate=zeros(1,(Fluo_startpoint+comparerange-length(Fluo_edge)+1));%For compensate of compare range with 0%The end plus one is due to Fluo_N=Fluo_edg-1
    Fluo_N=cat(2,Fluo_N,compensate);
end

Fluo_sub=GenFluo_sub(Fluo_N,Fluo_startpoint,Fluo_max,comparerange,DISTORED);
up=comparerange*(sum(DISTORED.*Fluo_sub))-(sum(Fluo_sub)*sum(DISTORED));
 down_1=comparerange*sum(DISTORED.^2)-(sum(DISTORED)^2);
 down_2=comparerange*sum(Fluo_sub.^2)-(sum(Fluo_sub))^2;
 r=up/(down_1*down_2)^0.5;
 subplot(1,2,2)
 plot(Fluo_sub);
 hold on
 plot(DISTORED);
 title(['tau=' num2str(tau) ' r=' num2str(r)]);
end
end

close all