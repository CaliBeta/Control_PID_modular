#ifndef __Descriptors_H__
#define __Descriptors_H__

//Definimos los pines necesarios para controlar el hardware
//pines de PWM para la salida de control
#define U_CONTROL      9

//lectura señales del generador y de la planta
#define SETPOINT      A0
#define ENTRADA       A1
#define INICIO        A2

//Pines pantala LCD 16x2
#define RS            40
#define RW            38
#define EN            36
#define D4            34
#define D5            32
#define D6            30
#define D7            28

//Parametros del controlador
#define T_MUESTREO    100 //Tiempo de muestreo en milisegundos
#define OUTMAX        12  //Salida maxima
#define OUTMIN        -12 //Salida minima
#define OFFSET        125 //Cero de la salida de control

#endif
