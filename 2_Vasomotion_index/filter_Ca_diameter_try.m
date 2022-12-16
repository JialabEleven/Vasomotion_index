clc
clear all
cur_p1 = mfilename('fullpath');%获得现在所打开的文件的路径
i=strfind(cur_p1,'\');%匹配 \
cur_p=cur_p1(1:i(end-1));   
buildingDir = fullfile([cur_p '2_Vasomotion_index\Test_calcium_radius_compare.xlsx']);
savepath = fullfile([cur_p '2_Vasomotion_index\deal_R_value_calcium_radius\']);

a=xlsread(buildingDir);
m=1;
for k=1:(size(a,2)/2)
    b=a(:,2*k-1);
    c=a(:,2*k);
    correl_raw1=corrcoef(b,c);
    b1=smoothdata(b,'gaussian',5);
    figure(),plot(b1);
    c1=smoothdata(c,'gaussian',5);
    figure(),plot(c1);
    correl_raw2=corrcoef(b1,c1);
    raw_data_calcium(:,m)=b;
    raw_data_radius(:,m)=c;
    filter_data_calcium(:,m)=b1;
    filter_data_radius(:,m)=c1;
    
    %make picture of raw_data
    for i=1:(length(b)-99)
        bb1=b((0+i):(99+i)); %100帧负相关最大的位置
        cc1=c((0+i):(99+i));
        correlbc1=corrcoef(bb1,cc1);
        select_correlbc1(i)=min(min(correlbc1));
    end
    min_correlbc_raw=min(select_correlbc1);
    [rowbc1,columnbc_raw]=find(select_correlbc1==min_correlbc_raw);
    output_calcium_raw=b(columnbc_raw:columnbc_raw+99);
    output_calcium_raw1=(output_calcium_raw-mean(output_calcium_raw))/mean(output_calcium_raw);
    output_radius_raw=c(columnbc_raw:columnbc_raw+99);
    output_radius_raw1=(output_radius_raw-mean(output_radius_raw))/mean(output_radius_raw);
    t=1:1:length(output_calcium_raw);
    figure(),[hAx,hLine1,hLine2]=plotyy(t,output_calcium_raw1,t,output_radius_raw1)
    title('R value between calcium and radius (vasomotion)') 
    xlabel('Time/frame') 
    ylabel(hAx(1),'Calcium fluctuation') % left y-axisylabel(hAx(2),'Fast Decay') % right y-axis
    ylabel(hAx(2),'Radius fluctuation')
    hold on
    text(80,0.02,['R= ',num2str(min_correlbc_raw),''],'FontSize',10,'Color','b');
    saveas(gca,[savepath,'raw_calcium_radius_R_line',num2str(k),'.tif']);
    label_min_raw(:,m)=min_correlbc_raw;
    label_min_raw_coordinate(:,m)=columnbc_raw;
    label_output_raw_calcium(:,m)=output_calcium_raw;
    label_output_raw_radius(:,m)=output_radius_raw;

    %make picture of filter_data
    for ii=1:(length(b1)-99)
    bb=b1((0+ii):(99+ii)); %100帧负相关最大的位置
    cc=c1((0+ii):(99+ii));
    correlbc=corrcoef(bb,cc);
    select_correlbc(ii)=min(min(correlbc));
    end
    min_correlbc=min(select_correlbc);
    [rowbc,columnbc]=find(select_correlbc==min_correlbc);
    mean_select_correlbc=mean(select_correlbc);
    output_calcium=b1(columnbc:columnbc+99);
    output_calcium1=(output_calcium-mean(output_calcium))/mean(output_calcium);
    output_radius=c1(columnbc:columnbc+99);
    output_radius1=(output_radius-mean(output_radius))/mean(output_radius);
    tt=1:1:length(output_calcium);
   figure(),[hAx,hLine1,hLine2]=plotyy(t,output_calcium1,t,output_radius1)
   title('R value between calcium and radius gaussian filter 5 (vasomotion)') 
   xlabel('Time/frame') 
   ylabel(hAx(1),'Calcium fluctuation') 
   ylabel(hAx(2),'Radius fluctuation')
   hold on
   text(80,0.02,['R= ',num2str(min_correlbc),''],'FontSize',10,'Color','b');
   saveas(gca,[savepath,'filter_calcium_radius_R_line',num2str(k),'.tif']);
   label_min(:,m)=min_correlbc;
   label_min_coordinate(:,m)=columnbc;
   label_output_filter_calcium(:,m)=output_calcium;
   label_output_filter_radius(:,m)=output_radius;
   m=m+1;
end

output=[label_min_raw' label_min_raw_coordinate' label_min' label_min_coordinate' ];
A = [{'min_raw','min_coordinate_raw','min_gaussian5','min_coordinate_gaussian5'}; num2cell(output)];
xlswrite([savepath,'information_R_value'],A);
xlswrite([savepath,'information_raw_calcium'],label_output_raw_calcium);
xlswrite([savepath,'information_raw_radius'],label_output_raw_radius);
xlswrite([savepath,'information_gaussian5_calcium'],label_output_filter_calcium);
xlswrite([savepath,'information_gaussian5_radius'],label_output_filter_radius);


