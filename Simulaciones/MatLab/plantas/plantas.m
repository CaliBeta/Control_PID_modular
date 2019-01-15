clc
clear all
close all

%% valores de la planta 1

%-------- planta1 ------
numerador_p1=[1];
denominador_p1=[1,1,-2];

display ('-------------------------planta1----------------------------------')
printsys(numerador_p1,denominador_p1,'s')

%% valores de la planta 2

% %------ planta 2 fdt calulada------
% 
% numerador_p2=[4];
% denominador_p2=[1,1,2];
% 
% display ('-------------------------planta2----------------------------------')
% printsys(numerador_p2,denominador_p2,'s')


%______________________bloques en realimentacion___________________________

numerador_hs=4;
denominador_hs=1;

numerador_a=4;
denominador_a=1;

display ('-----------------------planta 2---------------')
[numerador_realimentado,den_realimentado]=feedback(numerador_p1,denominador_p1,numerador_hs,denominador_hs);
[numerador_p2,denominador_p2]=series(numerador_realimentado,den_realimentado,numerador_a,denominador_a);
printsys(numerador_p2,denominador_p2)

%% valores de la planta 3

%-------- planta3 ------
numerador_p3=[1];
denominador_p3=[5.04,5,1];

display ('-------------------------planta3----------------------------------')
printsys(numerador_p3,denominador_p3,'s')



%% hallo los polos

display ('************************polos *********************************')

display ('---------polos planta1 -------------------')
[z,p,k]=tf2zp(numerador_p1,denominador_p1);
p

display ('---------polos planta2 -------------------')
[z,p,k]=tf2zp(numerador_p2,denominador_p2);
p


display ('---------polos planta3 -------------------')
[z,p,k]=tf2zp(numerador_p3,denominador_p3);
p


%% respuesta al escalon

figure('Name','Respuesta escalón planta1');
title('planta 1');
step(tf(numerador_p1,denominador_p1))

figure('Name','Respuesta escalón del planta2');
title('planta 2');
step(tf(numerador_p2,denominador_p2))

figure('Name','Respuesta escalón del planta3');
title('planta 3');
step(tf(numerador_p3,denominador_p3))

