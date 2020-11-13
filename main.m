clear all
close all
clc

load('dados.mat');
size_iluminado=size(iluminado);

%Estudio de estructura vector iluminado.
counts_size=40;
counts=zeros(counts_size,1);
count_i=1;
k=1;
for i= 2:size_iluminado(1)
    if eq(iluminado(i),iluminado(i-1))
        count_i=count_i+1;
    else
        counts(k,1)=counts(k,1)+count_i;
        count_i=1;
        k=k+1;
    end  
end
luz_1=zeros(10,1);
luz_2=zeros(10,1);
for j=1:10
    luz_1(j)=luz_1(j) + counts(3+4*(j-1));
    luz_2(j)=luz_2(j) + floor(counts(3+4*(j-1))*0.05)+1;
end
luz_1;              %valores donde le llega luz a satélite 1
luz_2;              % 5% de los valores de cada conjunto de luz_1
luz_3=luz_1-luz_2;  %valores que deben atenuarse en intervalos iluminados.
luz_4=luz_1/luz_2;  %cantidad de valores por cada dato de luz que deben atenuarse.
 
% Creación de iluminado modificado.
    %A, el 5% al principio del intervalo de los 1.
iluminado_A=zeros(size_iluminado);
ind=0;
luces=[3 7 11 15 19 23 27 31 35 39];
w1=1;
for x=1:counts_size
    if ismember(x,luces)
        for y=1:counts(x)
            if le(y,luz_2(w1))
                iluminado_A(ind+y)=iluminado(ind+y);
            else
                iluminado_A(ind+y)=0.0;
            end
        end
        w1=w1+1;
    else
        for y=1:counts(x)
            iluminado_A(ind+y)=iluminado(ind+y);
        end
    end
    for Correccion=1:size_iluminado(1)
        if eq(iluminado_A(Correccion),0.5)
            iluminado_A(Correccion)=0.0;
        end
    end
    ind=ind+counts(x);
end

% creación de iluminado modificado.
    %B, el 5% al final del intervalo de los 1.
iluminado_B=zeros(size_iluminado);
ind=0;
luces=[3 7 11 15 19 23 27 31 35 39];
w1=1;
for x=1:counts_size
    if ismember(x,luces)
        for y=1:counts(x)
            if ge(y,luz_3(w1)+1)
                iluminado_B(ind+y)=iluminado(ind+y);
            else
                iluminado_B(ind+y)=0.0;
            end
        end
        w1=w1+1;
    else
        for y=1:counts(x)
            iluminado_B(ind+y)=iluminado(ind+y);
        end
    end
    for Correccion=1:size_iluminado(1)
        if eq(iluminado_B(Correccion),0.5)
            iluminado_B(Correccion)=0.0;
        end
    end
    ind=ind+counts(x);
end

% creación de iluminado modificado.
%C, el 5% a la mitad del intervalo de los 1.
iluminado_C=zeros(size_iluminado);
ind=0;
luces=[3 7 11 15 19 23 27 31 35 39];
w1=1;
for x=1:counts_size
    if ismember(x,luces)
        for y=1:counts(x)
            c1=floor(luz_1(w1)/2-luz_2(w1)/2+1);
            c2=floor(luz_1(w1)/2+luz_2(w1)/2);
            if ismember(y,c1:c2)
                iluminado_C(ind+y)=iluminado(ind+y);
            else
                iluminado_C(ind+y)=0.0;
            end
        end
        w1=w1+1;
    else
        for y=1:counts(x)
            iluminado_C(ind+y)=iluminado(ind+y);
        end
    end
    for Correccion=1:size_iluminado(1)
        if eq(iluminado_C(Correccion),0.5)
            iluminado_C(Correccion)=0.0;
        end
    end
    ind=ind+counts(x);
end

%Comprobación de estructura de iluminado_X
%Estudio de estructura vector iluminado.
counts_size=40;

%comprobación de A.
countsA=zeros(counts_size,1);
countA_i=1;
k=1;
for i= 2:size_iluminado(1)
    if eq(iluminado_A(i),iluminado_A(i-1))
        countA_i=countA_i+1;
    else
        countsA(k,1)=countsA(k,1)+countA_i;
        countA_i=1;
        k=k+1;
    end  
end

%comprobación de B.
countsB=zeros(counts_size,1);
countB_i=1;
k=1;
for i= 2:size_iluminado(1)
    if eq(iluminado_B(i),iluminado_B(i-1))
        countB_i=countB_i+1;
    else
        countsB(k,1)=countsB(k,1)+countB_i;
        countB_i=1;
        k=k+1;
    end  
end

%comprobación de C.
countsC=zeros(counts_size,1);
countC_i=1;
k=1;

for i= 2:size_iluminado(1)
    if eq(iluminado_C(i),iluminado_C(i-1))
        countC_i=countC_i+1;
    else
        countsC(k,1)=countsC(k,1)+countC_i;
        countC_i=1;
        k=k+1;
    end  
end

luz_1A=zeros(10,1);
luz_1B=zeros(10,1);
luz_1C=zeros(10,1);
for j=1:10
    luz_1A(j)=luz_1A(j) + countsA(3+4*(j-1));
    luz_1B(j)=luz_1B(j) + countsB(3+4*(j-1));
    luz_1C(j)=luz_1C(j) + countsB(3+4*(j-1));
end
luz_1A; %debe ser igual a luz2
luz_1B; %debe ser igual a luz2
luz_1C; %debe ser igual a luz2

%Cálculo de Potencias:
Pot_OBC=  0.4;       %W
Pot_ADCS= 3*0.85;    %W
Pot_Payload= 0.8;    %W
Pot_TTEC_W=6;        %W
Pot_TTEC_N=0.48;     %W

Pot_Worst=ones(size_iluminado(1),size_iluminado(2))*(Pot_OBC+Pot_ADCS+Pot_Payload+Pot_TTEC_W);
Pot_Nominal_A=ones(size_iluminado(1),size_iluminado(2))*(Pot_OBC+Pot_ADCS+Pot_Payload+Pot_TTEC_N)+iluminado_A*(Pot_TTEC_W-Pot_TTEC_N);
Pot_Nominal_B=ones(size_iluminado(1),size_iluminado(2))*(Pot_OBC+Pot_ADCS+Pot_Payload+Pot_TTEC_N)+iluminado_B*(Pot_TTEC_W-Pot_TTEC_N);
Pot_Nominal_C=ones(size_iluminado(1),size_iluminado(2))*(Pot_OBC+Pot_ADCS+Pot_Payload+Pot_TTEC_N)+iluminado_C*(Pot_TTEC_W-Pot_TTEC_N);

G_T=1367; %W/m^2
Potencia_Solar_area = G_T*iluminado;

%----FALTA ENTENDER----%
PBus=0;           % Potencia del Bus                     modificar
painel=0;         % Potencia de cada panel               modificar
painel=0;         % Potencia de cada panel               modificar
painel=0;         % Potencia de cada panel               modificar
PGenerated=0;     % Potencia generada por los paneles    modificar

Factor_de_descarga =1.0;
Factor_de_carga =1.1;
Profundidad_de_descarga_maxima=0.3;  %    30%
%----FALTA ENTENDER----%

%Gráficos

subplot(5,1,1),plot(t_w,Pot_Nominal_A),title('POT NOM A');
subplot(5,1,2),plot(t_w,Pot_Nominal_B),title('POT NOM B');
subplot(5,1,3),plot(t_w,Pot_Nominal_C),title('POT NOM C');
subplot(5,1,4),plot(t_w,Pot_Worst),title('POT WORST');
subplot(5,1,5),plot(t_w,Potencia_Solar_area),title('POT RAD Sol');
% plot(t_w,iluminado)
% plot(t_w,iluminado_A)
% plot(t_w,Pot_Nominal_B);
% plot(t_w,Pot_Worst)
% plot(t_w,Potencia_Solar)