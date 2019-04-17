
%------基本粒子群优化算法（Particle Swarm Optimization）-----------
%------名称：基本粒子群优化算法（PSO）
%------作用：求解优化问题
%------说明：全局性，并行性，高效的群体智能算法
%------------------------------------------------------------------
%------初始格式化--------------------------------------------------
clear all;
clc;
%format long;
%------给定初始化条件----------------------------------------------
c1=2;             %学习因子1
c2=2;             %学习因子2
w=0;              %惯性权重
wMax=0.9;
wMin=0.1;
iterMax=10;            %最大迭代次数
D=14;                  %搜索空间维数（未知数个数）
N=50;                  %初始化群体个体数目
[a1,a2,a3,a4,a5,a6]=textread('a.txt','%d%d%d%d%d%d');
A=[a1,a2,a3,a4,a5,a6];
%------初始化种群的个体(可以在这里限定位置和速度的范围)------------

for i=1:N
    x(i,1)=1;
    v(i,1)=1;
    for j=2:D
        e=randperm(6);
        x(i,j)=e(1);  %随机初始化位置
        ee=randperm(11);
        v(i,j)=ee(1)-6;  %随机初始化速度
    end
end

%------先计算各个粒子的适应度，并初始化Pi和Pg----------------------
for i=1:N
   
    p(i)=fitness(x(i,:),D);
    y(i,:)=x(i,:);
end
pg=x(1,:);             %Pg为全局最优
for i=2:N
    if fitness(x(i,:),D)<fitness(pg,D)
        pg=x(i,:);
    end
end
%------进入主要循环，按照公式依次迭代，直到满足精度要求------------
for t=1:iterMax
    for i=1:N
        w=wMax-(t*(wMax-wMin))/iterMax;
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:));
      for j=1:14
        if v(i,j)>5
            v(i,j)=5;
        end
        if v(i,j)<-5
            v(i,j)=-5;
        end
      end
        x(i,:)=x(i,:)+v(i,:);
      for j=1:14
        if x(i,j)>6
            x(i,j)=6;
        end
        if x(i,j)<1
            x(i,j)=1;
        end
     end
        x(i,:)=floor(x(i,:));
        if fitness(x(i,:),D)<p(i)
            p(i)=fitness(x(i,:),D);
            y(i,:)=x(i,:);
        end
        if p(i)<fitness(pg,D)
            pg=y(i,:);
        end
    end
    Pbest(t)=fitness(pg,D);
end
%------最后给出计算结果
disp('*************************************************************')
disp('函数的全局最优位置为(最短路径)：')
L(1)=1;
for i=2:D
    L(i)=A(L(i-1),pg(i));
end
L=unique(L);
Solution=L'
disp('最后得到的优化极值为（最短路径长度）：')
Result=fitness(pg,D)
disp('*************************************************************')
%------算法结束---DreamSun GL & HF-----------------------------------

