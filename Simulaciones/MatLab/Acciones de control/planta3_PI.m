clc
clear all
close all

%% planta a controlar

display ('-------------------planta a acontrolar-----------------------')
num_planta=[1];
den_planta=[5.04,5,1];
Planta=tf(num_planta,den_planta)

display ('------------polos planta ----------------')
[z,polos,k]=tf2zp(num_planta,den_planta);
polos

figure
pzmap(Planta);title('polos y ceros planta')

%----------- respuesta ante un escalon---------------
figure();
step(Planta, (0:0.1:35)');
grid on


%%********* calculos realimentacion la planta con controlador *******
syms('Kp');
syms('Ki');
syms('Kd');
syms('Td');
syms('S')

display ('---------bloque PI-----------')
num_controlador=Kp*S+Ki;
den_controlador=S;
controlador=num_controlador/den_controlador;
pretty(controlador) 


display ('----------planta3------------')
num_planta_s=1;
den_planta_s=5.04*S^2+5*S+1;
planta_s=num_planta_s/den_planta_s;
planta_s=vpa(planta_s,4);
pretty(planta_s) 

% Realimentacion
num_loop=num_controlador*num_planta_s;
den_loop=num_loop+den_controlador*den_planta_s;

num_loop=expand(num_loop);
num_loop=collect(num_loop,S); 
num_loop=vpa(num_loop,4);

den_loop=expand(den_loop);
den_loop=collect(den_loop,S); 
den_loop=vpa(den_loop,4);

display ('---------planta3 controlada----------')
planta_controlada=num_loop/den_loop;
planta_controlada=vpa(planta_controlada,4);
pretty( planta_controlada) % muestra la ecuacion de la planta con el controlador como polinomios


%% % ********************** 3_Funcion de transferencia deseada *******************************
%------- parametros deseados ----------
ts_deseada=5; %tiempo de estabilizacion en segundos
k_deseada=1;           
sita_deseada=0.9; % aseguramos que el sobrepaso es menor al 10%
%-------------------------------------

wn_deseada=(4)/(sita_deseada*ts_deseada);

% ------------- segun la forma canonica ------
num_deseada=[k_deseada*wn_deseada^2];
den_deseada=[1 2*sita_deseada*wn_deseada wn_deseada^2];
deseada=tf( num_deseada,den_deseada)

display ('-------polos deseada ----------------')
[z,p,k]=tf2zp(num_deseada,den_deseada);
p 


%------ aumentando el orden de la deseada---------

polo_alejado=10*(-real(max(p))) % polo aumentado 10 veces

num_deseada_orden_3=num_deseada*polo_alejado;

den_deseada_orden_3=conv( den_deseada,[1 polo_alejado]);

deseada_orden_3=tf(num_deseada_orden_3,den_deseada_orden_3)

display ('-------polos deseada aumentada orden 3 ----------------')
[z,p1,k]=tf2zp(num_deseada_orden_3,den_deseada_orden_3);
p1

%----- analizamos como se compotta nuestra planta deseada y deseada aumentada ---------
figure
step(deseada_orden_3);title('respuesta escalon a la deseada orden mayor')
hold on                    
step(deseada)
hold off
grid on




%% 4_comparando la deseada aumentada con la planta-controlador

% estas formulas son unicas de cada planta
display ('-------Kp Ki sys control ----------------')
Kp=(den_deseada_orden_3(3)-1)/5.04   
Ki=den_deseada_orden_3(4)/5.04

%% probando los parametros calculados con la funcion step

%------- la planta controlada --------------
num_controlada= [Kp,Ki]
den_controlada=[5.04,5,Kp+1,Ki] 
controlada=tf(num_controlada,den_controlada)

%----------- respuesta ante un escalon---------------
figure();
step(controlada, (0:0.1:8)');
grid on

