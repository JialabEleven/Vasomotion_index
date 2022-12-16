clear all;
clc;
cur_p1 = mfilename('fullpath');%获得现在所打开的文件的路径
i=strfind(cur_p1,'\');%匹配 \
cur_p=cur_p1(1:i(end-1));   
filename = fullfile([cur_p '5_3Dmodel_Synchronization\WT_MCAO.xlsx']);
a=xlsread(filename);
filename1=fullfile([cur_p '5_3Dmodel_Synchronization\WT_Before.xlsx']);
a1=xlsread(filename1);
filename2=fullfile([cur_p '5_3Dmodel_Synchronization\WT_RP22h.xlsx']);
a2=xlsread(filename2);


z=a(33:100,8:36);
x=-35:2.5:35;
y=1:1.6:108.8;%统一时间
y1=1.08:1.08:108;
[xx,yy]=meshgrid(x,y);

for i=1:size(z,2)
    b=z(:,i);
    average(i)=mean(b);
    for ii=1:length(b)
        zz(ii,i)=(b(ii)-average(i))/average(i);
    end
end

figure(),surf(xx,yy,zz);

windowSize = 15; 
c = (1/windowSize)*ones(1,windowSize);
d=1;
for j=1:size(zz,2)
    t(:,j)=filter(c,d,zz(:,j));
end


figure(),surf(xx,yy,t);


z1=a1(51:150,3:31);
[xx1,yy1]=meshgrid(x,y1);
for k=1:size(z1,2)
    b1=z1(:,k);
    average(k)=mean(b1);
    for kk=1:length(b1)
        zz1(kk,k)=(b1(kk)-average(k))/average(k);
    end
end

figure(),surf(xx1,yy1,zz1);

for jj=1:size(zz1,2)
    t1(:,jj)=filter(c,d,zz1(:,jj));
end
figure(),surf(xx1,yy1,t1);



z2=a2(37:136,9:37);
[xx2,yy2]=meshgrid(x,y1);
for q=1:size(z2,2)
    b2=z2(:,q);
    average(q)=mean(b2);
    for qq=1:length(b2)
        zz2(qq,q)=(b2(qq)-average(q))/average(q);
    end
end

figure(),surf(xx2,yy2,zz2);

for p=1:size(zz2,2)
    t2(:,p)=filter(c,d,zz2(:,p));
end
figure(),surf(xx2,yy2,t2);