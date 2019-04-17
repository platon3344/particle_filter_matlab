% 粒子群算法的核心在于自适应函数的选取和更新粒子的信息（速度和位置）

function [par par_best]=update_par(par,par_best)
    
    %Px=Px+Pv*t,这里t=1,Px为当前粒子的位置，Pv为当前粒子的速度
    par.x=par.x+par.vx;   
    par.y=par.x+par.vy;   
    %自适应度函数
    par.fit=compute_fit(par);    %计算当前粒子适应度
    
    %Pv=Pv+(c1*rand*(Gx-Px))+(c2*rand*(PBx-Px))
    %这里c1,c2为加速因子
    %Gx为具有最佳适应度粒子的位置
    %PBx为当前粒子的最佳位置
    c1=1;
    c2=1;
    par.vx=par.vx+c1*rand()*(par_best.x-par.x)+c2*rand()*(par.bestx-par.x);   
    par.vy=par.vy+c1*rand()*(par_best.y-par.y)+c2*rand()*(par.besty-par.y);
 
    if par.fit>par.bestfit      %如果当前粒子适应度要好于当前粒子最佳适应度
        par.bestfit=par.fit;    %则更新当前粒子最佳适应度
        par.bestx=par.x;        %更新当前粒子最佳位置
        par.besty=par.y;
        if par.bestfit>par_best.fit     %如果当前粒子最佳适应度好于最佳粒子适应度
            par_best.fit=par.bestfit;   %则更新最佳粒子适应度
            par_best.x=par.x;           %更新最佳粒子位置
            par_best.y=par.y;
        end
    end

end