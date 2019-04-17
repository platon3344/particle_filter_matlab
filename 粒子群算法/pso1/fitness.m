function result=fitness(x,D)
[a1,a2,a3,a4,a5,a6]=textread('a.txt','%d%d%d%d%d%d');
A=[a1,a2,a3,a4,a5,a6];
[b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14]=textread('c.txt','%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
C=[b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14];
sum=0;
L(1)=1;
for i=2:D
    L(i)=A(L(i-1),x(i));
end
   
for i=2:D
    sum=sum+C(L(i-1),L(i));
end
result=sum;
