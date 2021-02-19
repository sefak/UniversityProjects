int sensorValue = 0 ;
void setup ( ) {
Serial.begin(115200); } // serial communication hizini belirleme
void loop ( ) {
sensorValue = analogRead(A0) ; // A0 portundan sample alma
sensorValue = sensorValue / 4 ; // 10 bitlik sample iprecision kaybi yaparak 8 bit e cevirimis oluyoruz
Serial.write(sensorValue); } // serial port dan PC ye yollama
