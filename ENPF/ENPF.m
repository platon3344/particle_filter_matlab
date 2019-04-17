function [xhat] = ENPF(x0,P0,Q,R,tf,Np,Nenpf,y,statefun,obsfun)

% [xhat] = ENPF(x0,P0,Q,tf,Np,Nenpf,y,statefun,obsfun)
% where, input:
%        x0 -- initial state using row vector
%        P0 -- the covariance matrix of initial state
%        Q  -- process noise
%        R  -- observation noise
%        tf -- filter time
%        Np -- the number of particles
%        y  -- observed value from 1 to k, and the ith row represents the
%              ith observed value 
%        Nenpf    -- the number of ensemble samples
%        statefun -- state equation x(k+1) = f(x(k))+w
%                    w ~ N(0,Q)
%        obsfun   -- observation function y(k) = h(x(k))+v 
%                    v ~ N(0,R)
%
%        output:
%        xhat -- filter state (output)

% ********* Initialization ********* %

nx = length(x0);            
ny = size(y,2);             
xbarp_t = zeros(Nenpf,nx);  
ybarp_t = zeros(Nenpf,ny);  
xbarp = zeros(Nenpf,nx,Np);
xhatp = zeros(Np,nx);
wp = zeros(Np,1);
xhat = zeros(tf,nx);
for i = 1:Np
    xbarp(:,:,i) = repmat(x0,Nenpf,1)+(sqrtm(P0).*randn(Nenpf,nx));
end

for k = 1:tf
    
% ********* Prediction of every particle ********* %
    for i = 1:Np
        for j = 1:Nenpf
            xbarp_t(j,:) = statefun(xbarp(j,:,i),k);
%             ybarp_t(j,:) = obsfun(xbarp(j,:,i));
            ybarp_t(j,:) = obsfun(xbarp_t(j,:));
        end
        xhatp_t = sum(xbarp_t,1)/Nenpf;
        yhatp_t = obsfun(xhatp_t,1);
        Pxh = zeros(nx,ny);
        Phh = zeros(ny,ny);
        for j = 1:Nenpf
            Pxh = (xbarp_t(j,:)-xhatp_t)*(ybarp_t(j,:)-yhatp_t)'+Pxh;
            Phh = (ybarp_t(j,:)-yhatp_t)*(ybarp_t(j,:)-yhatp_t)'+Phh;
        end
        Pxh = Pxh/(Nenpf-1);
        Phh = Phh/(Nenpf-1);
        Kp = Pxh*(Phh+Q*eye(ny))^(-1);
        for j = 1:Nenpf
            xbarp(j,:,i) = xbarp_t(j,:)+Kp*(y(k,:)-ybarp_t(j,:));
        end
        xhatp(i,:) = sum(xbarp(:,:,i),1)/Nenpf;
        vbarp = y(k,:)-obsfun(xhatp(i,:));
        wp(i) = 1/sqrt(det(R))/(2*pi)^(ny/2)*exp(-0.5*vbarp'*R^(-1)*vbarp);
        if wp(i) < eps
            wp(i) = 1e-8;
        end
    end
 
% ********* State update ********* %

    wp = wp/sum(wp,1);
    xhat(k,:) = sum(repmat(wp,1,nx).*xhatp,1);
    ind = resampling(wp);
    xbarp = xbarp(:,:,ind);
end

end

function ind = resampling(wt)               % Resampling

% function ind = resampling(wt)
% where, input:
%        wt -- weights of all the partilces
%
%        output:
%        ind -- the index of resampling

wc = cumsum(wt);
n = length(wt);
u = ([0:n-1]+rand(1))/n;
ind = zeros(1,n);
k = 1;
for i = 1:n
    while(wc(k)<u(i))
        k = k+1;
    end
    ind(i) = k;
end
end