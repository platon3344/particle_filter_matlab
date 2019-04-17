% 粒子群算法的核心在于自适应函数的选取和更新粒子的信息（速度和位置）

clear all;close all;clc;
[x y]=meshgrid(-100:100,-100:100);
sigma=50;
img = (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); %目标函数，高斯函数
mesh(img);
hold on;
n=10;   %粒子群粒子个数

%初始化粒子群，定义结构体
%结构体中八个元素，分别是粒子坐标，粒子速度，粒子适应度，粒子最佳适应度，粒子最佳坐标
par=struct([]);
for i=1:n
    par(i).x=-100+200*rand();   %[-100 100]对x位置随机初始化
    par(i).y=-100+200*rand();   %[-100 100]对y位置随机初始化
    par(i).vx=-1+2*rand();      %[-1 1]对vx速度随机初始化
    par(i).vy=-1+2*rand();      %[-1 1]对vy速度随机初始化
    par(i).fit=0;               %粒子适应度为0初始化
    par(i).bestfit=0;           %粒子最佳适应度为0初始化
    par(i).bestx=par(i).x;      %粒子x最佳位置初始化
    par(i).besty=par(i).y;      %粒子y最佳位置初始化
end
par_best=par(1);    %初始化粒子群中最佳粒子

for k=1:10    
    plot3(par_best.x+100,par_best.y+100,par_best.fit,'g*'); %画出最佳粒子的位置，+100为相对偏移
    for p=1:n
        [par(p) par_best]=update_par(par(p),par_best);  %更新每个粒子信息         
    end  
end