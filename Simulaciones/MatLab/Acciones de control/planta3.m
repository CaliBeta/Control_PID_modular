clc
clear all
close all

%% planta a controlar

display ('------------------------planta a acontrolar----------------------------------')
num_planta=[1];
den_planta=[5.04,5,1];
Planta=tf(num_planta,den_planta)

display ('-------polos planta ----------------')
[z,polos,k]=tf2zp(num_planta,den_planta);
polos

figure
pzmap(Planta);title('polos y ceros planta')

%----------- respuesta ante un escalon---------------
figure();
step(Planta, (0:0.1:35)');
grid on


%%  *********  calculos realimentacion la planta con controlador **********************
syms('Kp');
syms('Ti');
syms('Td');
syms('S')

display ('---------bloque pid-----------')
num_controlador=Kp*Ti*Td*S^2+Kp*Ti*S+Kp;
den_controlador=Ti*S;
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

display ('---------plant3 controlada----------')
planta_controlada=num_loop/den_loop;
planta_controlada=vpa(planta_controlada,4);
pretty( planta_controlada) % muestra la ecuacion de la planta con el controlador como polinomios


%% % ********************** 3_Funcion de transferencia deseada *******************************
%------- parametros deseados ----------
ts_deseada=5; %tiempo de estabilizacion en segundos
k_deseada=1;           
sita_deseada=0.8; % aseguramos que el sobrepaso es menor al 10%
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
display ('-------Kp Ti Td sys control ----------------')
Kp=(den_deseada_orden_3(3)-(1/5.04))*(5.04)   
Ti=(Kp)/(5.04*den_deseada_orden_3(4))
Td=(((den_deseada_orden_3(2))-((5/5.04)))*(5.04))/(Kp)



%% probando los parametros calculados con la funcion step

%------- la planta controlada --------------
num_controlada= [Kp*Ti*Td, Kp*Ti, Kp]
den_controlada=[Ti*5.04, 5*Ti+Kp*Td*Ti, Kp*Ti+Ti, Kp] 
controlada=tf(num_controlada,den_controlada)

%----------- respuesta ante un escalon---------------
figure();
step(controlada, (0:0.1:8)');
grid on

%% probando los parametros calculados con Simulink

open_system('DB_Control_PID');
Kp_1=Kp   
Ti_1=Ti
Td_1=Td



