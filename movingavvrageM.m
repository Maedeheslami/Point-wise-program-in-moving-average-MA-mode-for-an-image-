clc
clear all
close all

data=xlsread('points.xlsx');
controlid=xlsread('control.xlsx');
checkid=xlsread('check.xlsx');

y=-data(:,2);
x=data(:,3); 
X=data(:,4);
Y=data(:,5);

xc=controlid(:,1);
yc=controlid(:,2);
Xc=controlid(:,3);
Yc=controlid(:,4);


xch=checkid(:,1);
ych=checkid(:,2);
Xch=checkid(:,3);
Ych=checkid(:,4);

subplot(1,3,1)
plot(data(:,2),data(:,3),'*')
title('points');
text(data(:,2),data(:,3),int2str(data(:,1)));


for i=1:length(xc)
    A((2*i-1),:)=[1,xc(i),yc(i),xc(i)*yc(i),xc(i)^2,yc(i)^2,0,0,0,0,0,0];
    A(2*i,:)=[0,0,0,0,0,0,1,xc(i),yc(i),xc(i)*yc(i),xc(i)^2,yc(i)^2];
    l((2*i-1),:)=Xc(i);
    l(2*i,:)=Yc(i);
end

Xcap=inv(A'*A)*A'*l;
lc=A*Xcap;

for i=1:length(xc)
    xco(i)=lc(2*i-1);
    yco(i)=lc(i*2);

end

for i=1:length(xc)
    dxco(i)=xco(i)-Xc(i);
    dyco(i)=yco(i)-Yc(i);
end


for i=1:length(xch)
    Ach((2*i-1),:)=[1,xch(i),ych(i),xch(i)*ych(i),xch(i)^2,ych(i)^2,0,0,0,0,0,0];
    Ach(2*i,:)=[0,0,0,0,0,0,1,xch(i),ych(i),xch(i)*ych(i),xch(i)^2,ych(i)^2];
end

lch=Ach*Xcap;

for i=1:length(xch)
    xcho(i)=lch(2*i-1);
    ycho(i)=lch(i*2);
    dxch(i)=xcho(i)-Xch(i);
    dych(i)=ycho(i)-Ych(i);
end

m=length(xch);

for i=1:length(xch)
    rmsex=sqrt((sum(dxch(i)))/(m-1));
    rmsey=sqrt((sum(dych(i)))/(m-1));
end

rmse=sqrt((rmsex).^2+(rmsey.^2));
 subplot(1,3,2)
 quiver(Xch,Ych,dxch',dych')
 text(Xch,Ych,int2str(checkid(:,1)));
 title('quiver1')

n=length(xc);
x1=[xch];
x2=[xc];
y1=[ych];
y2=[yc];


for i=1:m
    for j=1:n
        f(i,j)=sqrt((x1(i)-x2(j))^2+(y1(i)-y2(j))^2);
    end
end


for i=1:size(xch)
    a=f(i,:)
    b=sort(a)
    
    c=a<b(5)
    
    effPoints=[(a(c)) dxco(c) dyco(c)];
    
    A2(1:4,1:6)=[ones(4,1) xc(c) yc(c) zeros(4,3)];
    L2(1:4,1)=dxco(c);

    A2(5:8,1:6)=[zeros(4,3) ones(4,1) xc(c) yc(c)];
    L2(5:8,1)=dyco(c);

    PAR2=inv(A2'*A2)*A2'*L2;
  
    
    cXMA(i,1)=[1 dxch(i) dych(i) 0 0 0]*PAR2;
    cYMA(i,1)=[0 0 0 1 dxch(i) dych(i)]*PAR2;
end

cXMA(i,1)=cXMA(i,1)';
cYMA(i,1)=cYMA(i,1)';


for i=1:n
    Xmd(i)=X(i)+cXMA(i);
    Ymd(i)=Y(i)+cYMA(i);
end

for i=1:n
    dXmd(i)=X(i)-Xmd(i);
    dYmd(i)=Y(i)-Ymd(i);
    rmsedXmd(i)=sqrt((sum(dXmd(i)^2))/m-1);
    rmsedYmd(i)=sqrt((sum(dYmd(i)^2))/m-1);
end

rmsefinal=sqrt((rmsedXmd).^2+(rmsedYmd.^2));

subplot(1,3,3)
quiver(Xch',Ych',dXmd,dYmd)
text(Xch',Ych',int2str(checkid(:,1)));
title('final quiver')