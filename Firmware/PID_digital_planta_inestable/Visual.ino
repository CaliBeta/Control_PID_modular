void mostrar_ganancias() {
  lcd.setCursor(0, 0);
  lcd.print("Kp=");
  lcd.print(Kp);
  lcd.setCursor(7, 0);
  lcd.print(" Ki=");
  lcd.print(Ki);
  lcd.setCursor(0, 1);
  lcd.print("Kd=");
  lcd.print(Kd);
  lcd.setCursor(7, 1);
  lcd.print("IN=");
  lcd.print(entrada);
}
