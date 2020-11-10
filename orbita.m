load('dados.mat');
nt=size(t_w);
nt2= nt(1)-1;
theta_dis=zeros(nt);
a=7148.8650000000;  %semieje mayor [km]
b=7148.8606749355;  %semieje menor [km]
e=0.0011;           %excentricidad [-]
T=100.26*60;        %Período orbital[s]
Area_elipse=a*b*pi; %Area total de elipse [km^2]
A_t=Area_elipse/T;            %Area recorrida en un paso temporal[km^2]


for t=2:nt2
    theta_dis(t)=acos((1/e)*(1-((a*(1-e^2))/(A_t+(a*(1-e^2))/(1-e*cos(theta_dis(t-1)))))));
end

plot(t_w,theta_dis)
