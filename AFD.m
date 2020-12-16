function [f_recovery,err,a,k,F,coef,energy_error,reminder,C,tem_B_store,G,base_store] =AFD( f,n,t,tol)
%This is the original Adaptive Fourier Decomposition Algorithm;
% input: 'f' is real or analytic signal;
%        'n' is the maximal steps of the decomposition and the default n is 50;
%        't' is the interval [0,2*pi] which has the same size as f;
%        'tol' is the tolerance and the default tol is 1e-3;
%       
% output: 'f_recovery' is the signal recovered by AFD;    
%         'err' is the relative error in 2_Norm;
%         'a' is an array in the unit disk of complex plane;
%         'k' is the iterative times;
%%
if nargin==1
    n=50;
    t=linspace(0,2*pi,length(f));
    tol=1e-3;
end
if nargin==2
    t=linspace(0,2*pi,length(f));
    tol=1e-3;
end
if nargin==3
    tol=1e-3;
end
if nargin>4
    error('too many arguments')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[l,m]=size(f);
G=zeros(n,m);
a=zeros(n,1);
G(1,:)=f;
C=Unit_Disk;
[N,M1]=size(C);
Weight=weight(length(f),6);
f2=abs(intg(f,f,Weight));
Base=zeros(length(C),m);
coef=zeros(n,1);
S1=zeros(size(C));
err=10;
tem_B=1;
%%
%tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute e_a of the unit disk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:N
      Base(k,:)=e_a(C(k),exp(t.*1i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The process of AFD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    j=1;
    fn=0;
    coef(j)=intg(f,ones(size(t)),Weight);
    a(j)=0;
    tem_B=(sqrt(1-abs(a(j))^2)./(1-conj(a(j))*exp(t.*1i))).*tem_B;
    F(j,:)=coef(j).*tem_B;
    fn=fn+F(j,:);
    tem_B_store(j,:)=tem_B;
    base_store(j,:)=tem_B;
while err>=tol&&j<=n-1
    j=j+1;
    G(j,:)=((G(j-1,:)-coef(j-1).*e_a(a(j-1),exp(t.*1i))).*(1-conj(a(j-1)).*exp(t.*1i)))./(exp(t.*1i)-a(j-1));%Decompose the signal f;
    I=0;
%     for k=1:N
%         Base(k,:)=(sqrt(1-abs(C(k))^2)./(1-conj(C(k))*exp(t.*1i))).*((exp(1i*t)-a(j-1))./(sqrt(1-abs(a(j-1))^2))).*tem_B;
%     end
    S1=conj(Base*(G(j,:)'.*Weight));%Using the maximal selection principle to find a;
    [M,I]=max(abs(S1));
    coef(j)=S1(I);a(j)=C(I);
    tem_B=(sqrt(1-abs(a(j))^2)./(1-conj(a(j))*exp(t.*1i))).*((exp(1i*t)-a(j-1))./(sqrt(1-abs(a(j-1))^2))).*tem_B;%Using the relationship between the m-th
    F(j,:)=coef(j).*tem_B;                                                                                          %and the (m-1)-th Blaschke product to compute the product;
    tem_B_store(j,:)=tem_B;
    base_store(j,:)=Base(I,:);
    fn=fn+F(j,:);
    if(isreal(f))
        energy_error(j)=abs(intg(2*real(fn)-coef(1)-f,2*real(fn)-coef(1)-f,Weight))/f2;
        err=abs(intg(2*real(fn)-coef(1)-f,2*real(fn)-coef(1)-f,Weight))/f2;
    else
        energy_error(j)=abs(intg(fn-f,fn-f,Weight))/f2;
        err=abs(intg(fn-f,fn-f,Weight))/f2;
    end
end
k=j;
a=a(1:k);
if(isreal(f))
    f_recovery=2*real(fn)-coef(1);
else
    f_recovery=fn;
end
reminder=G(j,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%time=toc;
% figure;plot(t,f,'r')
% hold on
% plot(t,f_recovery,'b')
% title(['relative error=',num2str(err),' run time=',num2str(time),' iterative times=',num2str(k)])
% legend('f','f_recovery');
end