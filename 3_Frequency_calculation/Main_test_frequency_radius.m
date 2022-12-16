clear all;
clc;
cur_p1 = mfilename('fullpath');%获得现在所打开的文件的路径
i=strfind(cur_p1,'\');%匹配 \
cur_p=cur_p1(1:i(end-1));   
buildingDir = fullfile([cur_p '3_Frequency_calculation\Test_radius_data.xlsx']);
savepath = fullfile([cur_p '3_Frequency_calculation\data_frequency_radius\']);


data=xlsread(buildingDir);

time=data(:,1); 

for i=1:(size(data,2)-1)
    amplitude=data(:,i+1);%同上

figure%我们需要画出第一个图像是关于time和amplitude的

plot(time,amplitude,'LineWidth',1)

grid on

xlabel('Time(s)','FontSize',12)

ylabel('Amplitude','FontSize',12)

legend('Time-domain','FontSize',12)
saveas(gca,[savepath,'Raw_data',num2str(i),'.tif']);
%我们接着做fft分析

response=amplitude;%我们让amplitude等于response代表输出值

%bring oscillation about 0这边可以不去管他，下面这个函数是让所有amplitude都减去平均值让整个amplitude的震动数据更围绕0

response=response-mean(response);

y=fft(response);%我们直接用fft函数对其转换。

%define sampling characterirstic定义这组样本的性质

sampleNumber=length(response);%样本数量等于response的长度也就是25000

sampleFrequency=1/1.08177;%样本频率指的是400个频率点

%take magnitude,normalize by number of samples

ytemp1=abs(y/sampleNumber);

ytemp2=ytemp1(1:sampleNumber/2+1);

%double lower half

FreqResponse=ytemp2;

FreqResponse(2:end)=2*FreqResponse(2:end);

%define frequency bins

fbins=sampleFrequency*(0:(sampleNumber/2))/sampleNumber;

%plot result

figure

plot(fbins,FreqResponse)

grid on

xlabel('Frequency(Hz)','Fontsize',12)

ylabel('Frequency-domain','Fontsize',12)

legend('Frequency distribution')

saveas(gca,[savepath,'frequency_domain',num2str(i),'.tif']);
output_frequency=[fbins' FreqResponse];
merge_frequency(:,i)=FreqResponse;
end
output_frequency=[fbins' merge_frequency];
xlswrite([savepath,'Total_data'],output_frequency);