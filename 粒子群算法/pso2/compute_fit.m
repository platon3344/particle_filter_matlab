function re=compute_fit(par)
    x=par.x;
    y=par.y;
    sigma=50;
    if x<-100 || x>100 || y<-100 || y>100
        re=0;        %������Χ��Ӧ��Ϊ0
    else            %������Ӧ�Ȱ�Ŀ�꺯�����
        re= (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); 
    end
end