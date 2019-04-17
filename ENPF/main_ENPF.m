clear all
clc

Np = 100;
Nenpf = 10;
tf = 100;
Q = 0.01;
R = 0.01;
nx = 1;
ny = 1;
x0 = 0;
P0 = 5;

% ********* Simulate the system ********* %
xTrue = zeros(tf+1,nx);
y = zeros(tf+1,ny);
xTrue(1) = x0+sqrtm(Q)*randn(1);
for k = 1:tf 
    xTrue(k+1,:) = statefun(xTrue(k,:),k)+ sqrtm(Q)*randn(1);
    y(k+1,:) = obsfun(xTrue(k+1,:)) + sqrtm(R)*randn(1);
end
xTrue = xTrue(2:end,:);
y = y(2:end,:);

% ********* ENPF ********** %

[xhat] = ENPF(x0,P0,Q,R,tf,Np,Nenpf,y,@statefun,@obsfun);

rms = sum((xTrue - xhat).^2);
rms = sqrt(rms/tf)

figure(2)
plot(1:tf,xhat','b--',1:tf,xTrue','r');
xlabel('Time');
legend('×´Ì¬¹ÀÖµ','×´Ì¬ÕæÖµ');
grid on