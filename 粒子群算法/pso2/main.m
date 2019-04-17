% ����Ⱥ�㷨�ĺ�����������Ӧ������ѡȡ�͸������ӵ���Ϣ���ٶȺ�λ�ã�

clear all;close all;clc;
[x y]=meshgrid(-100:100,-100:100);
sigma=50;
img = (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); %Ŀ�꺯������˹����
mesh(img);
hold on;
n=10;   %����Ⱥ���Ӹ���

%��ʼ������Ⱥ������ṹ��
%�ṹ���а˸�Ԫ�أ��ֱ����������꣬�����ٶȣ�������Ӧ�ȣ����������Ӧ�ȣ������������
par=struct([]);
for i=1:n
    par(i).x=-100+200*rand();   %[-100 100]��xλ�������ʼ��
    par(i).y=-100+200*rand();   %[-100 100]��yλ�������ʼ��
    par(i).vx=-1+2*rand();      %[-1 1]��vx�ٶ������ʼ��
    par(i).vy=-1+2*rand();      %[-1 1]��vy�ٶ������ʼ��
    par(i).fit=0;               %������Ӧ��Ϊ0��ʼ��
    par(i).bestfit=0;           %���������Ӧ��Ϊ0��ʼ��
    par(i).bestx=par(i).x;      %����x���λ�ó�ʼ��
    par(i).besty=par(i).y;      %����y���λ�ó�ʼ��
end
par_best=par(1);    %��ʼ������Ⱥ���������

for k=1:10    
    plot3(par_best.x+100,par_best.y+100,par_best.fit,'g*'); %����������ӵ�λ�ã�+100Ϊ���ƫ��
    for p=1:n
        [par(p) par_best]=update_par(par(p),par_best);  %����ÿ��������Ϣ         
    end  
end