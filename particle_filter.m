% �����˲��㷨Դ�����ؿ���˼�룬����ĳ�¼����ֵ�Ƶ����ָ�����¼��ĸ��ʡ�
% �������˲������У�X(t)ʵ������ͨ���Դ������ӵ�״̬���д���õ��ġ�
% �����˲���5�����裺
% 1����ʼ״̬���ô�������ģ��X(t)�������ڿռ��ھ��ȷֲ���
% 2��Ԥ��׶Σ�����״̬ת�Ʒ��̣�ÿһ�����ӵõ�һ��Ԥ�����ӣ�
% 3��У���׶Σ���Ԥ�����ӽ������ۣ�Խ�ӽ�����ʵ״̬�����ӣ���Ȩ��Խ��
% 4���ز�������������Ȩ�ض����ӽ���ɸѡ��ɸѡ�����У���Ҫ��������Ȩ�ش�����ӣ���Ҫ��һС����Ȩ��С�����ӣ�
% 5���˲������ز���������Ӵ���״̬ת�Ʒ��̵õ��µ�Ԥ�����ӣ�������2��

%�ڶ�ά�ռ�,�����˶������һ��(������)�˶�λ�á��ٶȡ����ٶ�����,�������˲��������д���
%ʵ���ҵĲ���
 clc;clear;close all;
% ��������
N = 100;   %��������
Q = 5;      %��������
R = 5;      %��������
T = 50;     %����ʱ��
theta = pi/T;       %��ת�Ƕ�
distance = 80/T;    %ÿ���ߵľ���
WorldSize = 100;    %�����С
X = zeros(2, T);    %�洢ϵͳ״̬
Z = zeros(2, T);    %�洢ϵͳ�Ĺ۲�״̬
P = zeros(2, N);    %��������Ⱥ
PCenter = zeros(2, T);  %�������ӵ�����λ��
w = zeros(N, 1);         %ÿ�����ӵ�Ȩ��
err = zeros(1,T);     %���
X(:, 1) = [50; 20];     %��ʼϵͳ״̬
Z(:, 1) = [50; 20] + wgn(2, 1, 10*log10(R));    %��ʼϵͳ�Ĺ۲�״̬
 
%��ʼ������Ⱥ
for i = 1 : N
    P(:, i) = [WorldSize*rand; WorldSize*rand];
    dist = norm(P(:, i)-Z(:, 1));     %�����λ�����ľ���
    w(i) = (1 / sqrt(R) / sqrt(2 * pi)) * exp(-(dist)^2 / 2 / R);   %��Ȩ��
end
PCenter(:, 1) = sum(P, 2) / N;      %�������ӵļ�������λ��
 
%%
err(1) = norm(X(:, 1) - PCenter(:, 1));     %���Ӽ���������ϵͳ��ʵ״̬�����
figure(1);
set(gca,'FontSize',12);
hold on
plot(X(1, 1), X(2, 1), 'r.', 'markersize',30)   %ϵͳ״̬λ��
axis([0 100 0 100]);
plot(P(1, :), P(2, :), 'k.', 'markersize',5);   %��������λ��
plot(PCenter(1, 1), PCenter(2, 1), 'b.', 'markersize',25); %�������ӵ�����λ��
legend('True State', 'Particles', 'The Center of Particles');
title('Initial State');
hold off

%%
%��ʼ�˶�
for k = 2 : T
       
    %ģ��һ�������˶���״̬
    X(:, k) = X(:, k-1) + distance * [(-cos(k * theta)); sin(k * theta)] + wgn(2, 1, 10*log10(Q));     %״̬����
    Z(:, k) = X(:, k) + wgn(2, 1, 10*log10(R));     %�۲ⷽ�� 
   
    %�����˲�
    %Ԥ��:��ÿ�����ӽ���Ԥ�⡣
    for i = 1 : N
        P(:, i) = P(:, i) + distance * [-cos(k * theta); sin(k * theta)] + wgn(2, 1, 10*log10(Q));
        dist = norm(P(:, i)-Z(:, k));     %�����λ�����ľ���
        w(i) = (1 / sqrt(R) / sqrt(2 * pi)) * exp(-(dist)^2 / 2 / R);   %��Ȩ��
    end
%��һ��Ȩ��
    wsum = sum(w);
    for i = 1 : N
        w(i) = w(i) / wsum;
    end
   
    %�ز��������£�
    for i = 1 : N
        wmax = 2 * max(w) * rand;  %��һ���ز�������
        index = randi(N, 1);
        while(w(index) < wmax ) %���С�ڸ���ֵ����ô�鿴��һ�����ӵ�Ȩ��w��������ǰ������
%             wmax = wmax - w(index);
            index = index + 1;
            if index > N
                index = 1;
            end          
        end
        P(:, i) = P(:, index);     %�õ�������
    end
   
    PCenter(:, k) = sum(P, 2) / N;      %�������ӵ�����λ��
   
    %�������
    err(k) = norm(X(:, k) - PCenter(:, k));     %���Ӽ���������ϵͳ��ʵ״̬�����
   
    figure(2);
    set(gca,'FontSize',12);
    clf;
    hold on
    plot(X(1, k), X(2, k), 'r.', 'markersize',50);  %ϵͳ״̬λ��
    axis([0 100 0 100]);
    plot(P(1, :), P(2, :), 'k.', 'markersize',5);   %��������λ��
    plot(PCenter(1, k), PCenter(2, k), 'b.', 'markersize',25); %�������ӵ�����λ��
    legend('True State', 'Particle', 'The Center of Particles');
    hold off
    pause(0.1);
end
 
%%
figure(3);
set(gca,'FontSize',12);
plot(X(1,:), X(2,:), 'r', Z(1,:), Z(2,:), 'g', PCenter(1,:), PCenter(2,:), 'b-');
axis([0 100 0 100]);
legend('True State', 'Measurement', 'Particle Filter');
xlabel('x', 'FontSize', 20); ylabel('y', 'FontSize', 20);
% 
% %%
% figure(4);
% set(gca,'FontSize',12);
% plot(err,'.-');
% xlabel('t', 'FontSize', 20);
% title('The err');