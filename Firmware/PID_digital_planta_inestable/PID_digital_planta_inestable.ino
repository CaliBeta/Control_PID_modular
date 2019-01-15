//Incluimos las librerias necesarias
#include <LiquidCrystal.h>
#include "Descriptors.h"
#include <PID_v1.h>

//Variables globales
//Variables para controladores PID
double consigna = 0.0;
double entrada = 0.0;
double salida = 0.0;
double Kp = 15.8;
double Ki = 8.0;
double Kd = 7.16;
double C = 1.05;
unsigned long time;
int inicio = 0;
int sal_pwm = 0;
uint8_t a = 0;

//Instanciamos los objetos de las ibrerias
PID PID1(&entrada, &salida, &consigna, Kp, Ki, Kd, DIRECT);
LiquidCrystal lcd(RS, RW, EN, D4, D5, D6, D7);
//-------------------------------------------------------------

void setup() {
  //Inicializamos el puerto serie a 9600 baudios
  Serial.begin(9600);
  //Inicializamos la pantalla LCD 16x2
  lcd.begin(16, 2);
  //Registro Timer1 (pines 9 y 10) divisor frecuencia central por 8 (1.95KHz con
  //cristal de 8MHz y 3.9KHz con cristal de 16MHz)
  TCCR2B = _BV (CS00); //asi para Arduino mega

  pinMode(U_CONTROL, OUTPUT);
  pinMode(INICIO, INPUT);

  analogWrite(U_CONTROL, OFFSET);
  PID1.SetTunings(Kp/C, Ki/C, Kd/C);
  PID1.SetOutputLimits(OUTMIN, OUTMAX);
  PID1.SetSampleTime(T_MUESTREO);
  PID1.SetMode(AUTOMATIC);

  lcd.setCursor(0, 0);
  lcd.print("CONTROLADOR PID");
  lcd.setCursor(4, 1);
  lcd.print("DIGITAL");
  delay(3000);
  lcd.clear();
}
//----------------------------------------------------------------------

void loop() {
  consigna = (analogRead(SETPOINT) * 0.02053) - 10.42;
  entrada = (analogRead(ENTRADA) * 0.02053) - 10.42;

  mostrar_ganancias();

  PID1.Compute(); //Iniciamos el algoritmo del PID
  sal_pwm = OFFSET + int(salida * 10.41);
  //Condiciones de saturacion
  if (sal_pwm > 255) {
    sal_pwm = 255;
  }
  else if (sal_pwm < 0) {
    sal_pwm = 0;
  }

  analogWrite(U_CONTROL, sal_pwm);
  Serial.print("Setpoint = ");
  Serial.print(consigna);
  Serial.print("  Planta = ");
  Serial.print(entrada);
  Serial.print("  Control = ");
  Serial.println(salida);
}
