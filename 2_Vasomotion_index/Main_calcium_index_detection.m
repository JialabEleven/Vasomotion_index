clear all;
clc;
cur_p1 = mfilename('fullpath');
i=strfind(cur_p1,'\');
cur_p=cur_p1(1:i(end-1));   
buildingDir = fullfile([cur_p '2_Vasomotion_index\Raw_data\Test_calcium_data.xlsx']);
savepath = fullfile([cur_p '2_Vasomotion_index\data_deal_calcium\']);
data=xlsread(buildingDir);
peak_amount=ones(size(data,1),size(data,2))*nan;
peak_bright_value=ones(size(data,1),size(data,2))*nan;
peak_select_enddata=ones(size(data,1),size(data,2))*nan;
%% Whether the data is fit the normal distribution
for iii=1:size(data,2)
    a=data(:,iii);
    number=size(a,1);
    a_number_random=randperm(number,number);
 for rr=1:size(a,1)
     a_random=a(a_number_random);
 end
 h0(iii)=lillietest(a_random);    
 h1(iii)=kstest(a_random);
 h2(iii)=jbtest(a_random);
 h3(iii)=chi2gof(a_random);

 aa=a_random(1:round(number*0.75));
 h00(iii)=lillietest(aa);    
 h11(iii)=kstest(aa);
 h22(iii)=jbtest(aa);
 h33(iii)=chi2gof(aa);

  aaa=a_random(1:round(number*0.5));
  h000(iii)=lillietest(aaa);   
  h111(iii)=kstest(aaa);
  h222(iii)=jbtest(aaa);
  h333(iii)=chi2gof(aaa);

  aaaa=a_random(1:round(number*0.25));
  h0000(iii)=lillietest(aaaa);   
  h1111(iii)=kstest(aaaa);
  h2222(iii)=jbtest(aaaa);
  h3333(iii)=chi2gof(aaaa);

    cell_data = a';
    proc_data = rolling_percentile_filter(cell_data,20,30);

 pro_data=cell_data-proc_data;
 sig=std(proc_data);
    pro_data(pro_data < 0) = 0;
    final_data=pro_data./(proc_data);
    [pks2,locs2]=findpeaks(pro_data);
    [d_pks,d_locs]=findpeaks(final_data);
  u=1:1:length(pro_data);    
     for m=1:size(locs2,2)
         text(locs2(m),pks2(m),['',num2str(m),''],'FontSize',10,'Color','b'); 
     end
end_F(:,iii)=cell_data';
end_F0(:,iii)=proc_data';
end_data(:,iii)=final_data';



m=zeros(1,length(a));
num = [];
num1= [];
n = [];
i=1;
q=1;
p=1;
e=1;
amount=[];
amount1=[];
select_enddata1=[];
for t=1:length(d_locs)
    m(t)=cell_data(d_locs(t))-proc_data(d_locs(t));
	if m(t)>2*sig
  		bright_value1(p)=m(t);
        num1(i)=a(d_locs(t));
        amount1(q)=d_locs(t);
        select_enddata1(e)=final_data(d_locs(t));
  		i=i+1;
        q=q+1;
        p=p+1;
        e=e+1;
  	end
end

select_enddata=[];
jj=1;
for tt=1:length(select_enddata1)
    if select_enddata1(tt)>0.06
        select_enddata(jj)=select_enddata1(tt);
        amount(jj)=amount1(tt);
        num(jj)=a(amount1(tt));
        bright_value(jj)=bright_value1(tt);
        jj=jj+1;
    end
end

if isempty(select_enddata)
    bright_value=0;
end

b=1:1:length(cell_data);
figure(), plot(b,cell_data);
hold on
plot(proc_data);
hold on 
plot(amount,num,'.','color','R');  
 for j=1:size(num,2)
     text(amount(j),num(j),['',num2str(j),''],'FontSize',10,'Color','b');
 end
title('Calcium events')
xlabel('Frame');
ylabel('bright value')
hold off
saveas(gca,[savepath,'raw_data_line',num2str(iii),'.tif']);

figure(), plot(b,final_data)
hold on
plot(amount,select_enddata,'.','color','R')
for jj=1:size(num,2)
     text(amount(jj),select_enddata(jj),['',num2str(jj),''],'FontSize',10,'Color','b');
 end
title('Calcium events')
xlabel('Frame');
ylabel('detaF/F0')
hold off
saveas(gca,[savepath,'deltaF_F0_line',num2str(iii),'.tif']);
peak_amount(1:length(amount),iii)=amount';
peak_bright_value(1:length(bright_value),iii)=bright_value';
peak_select_enddata(1:length(select_enddata),iii)=select_enddata';
output_raw_data=[end_F(:,iii),end_F0(:,iii),end_data(:,iii)];
output_peak=[peak_amount(1:length(amount),iii),peak_bright_value(1:length(bright_value),iii),peak_select_enddata(1:length(select_enddata),iii)];
if output_peak==0
    frequency(iii)=0;
    average_amplitude(iii)=0;
    output_peak=zeros(length(a),3);
else
frequency(iii)=size(output_peak,1)/(size(data,1)*1.08);
average_amplitude(iii)=mean(output_peak(:,3));
end
output_add=padarray(output_peak,length(a)-size(output_peak,1),'post');
output=[output_raw_data,output_add];


if size(output_peak,1)>=2
    if size(output_peak,1)==2
        interval=(output_peak(2,1)-output_peak(1,1))*1.08;
    else
        for kk=1:length(output_peak)-1
            interval(kk)=(output_peak(kk+1,1)-output_peak(kk,1))*1.08;
        end
    end
end

if size(output_peak,1)==1
    interval=0;
end
      
interval_SD(iii)=std(interval);
interval_mean(iii)=mean(interval);
mean_calcium(iii)=mean(a);
mean_deltaF(iii)=mean(bright_value);
interval=[];
amount=[];
bright_value=[];
bright_value1=[];
select_enddata=[];
select_enddata1=[];
num=[];
A = [{'F','F0','deltaF/F0','peak_position','delta_bright_value','peak_deltaF/F0'}; num2cell(output)];
xlswrite([savepath,'single_data'],A,['cell_',num2str(iii),'']);
end
total_data=[frequency' average_amplitude' interval_mean' interval_SD' mean_deltaF' mean_calcium'];
B = [{'Frequency(Hz)','Average_deltaF/F0','interval_mean(s)','interval_SD','mean_deltaF','mean_calcium'}; num2cell(total_data)];
xlswrite([savepath,'Total_data'],B);

normal_data=[h0' h00' h000' h0000' h1' h11' h111' h1111' h2' h22' h222' h2222' h3' h33' h333' h3333'];
C = [{'lillietest_total','lillietest_3/4','lillietest1/2','lillietest1/4','kstest_total','kstest3/4','kstest1/2','kstest1/4'...
    'jbtest_total','jbtest3/4','jbtest1/2','jbtest1/4','chi2gof_total','chi2gof3/4','chi2gof1/2','chi2gof1/4'}; num2cell(normal_data)];
xlswrite([savepath,'normal_distribution'],C);