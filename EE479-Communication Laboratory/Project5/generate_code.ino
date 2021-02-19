//char inChars[12] = "/*12Deneme`";   // $
char inChars[67] = "/*AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUu VvWwXxYyZz0123456789`";
int delayTime = 3; // specify the waiting time in millisecond
int method = 1; // 1 for on-off, 2 for Manchester
void setup ( ) {
  pinMode(3, OUTPUT);    // sets the digital pin 13 as output
}
void loop ( ) {
int charSize = sizeof(inChars);

//delayTime = delayTime + random(-33,33);

/*
 * The chars /* are used for sychronization.
 */
for(int i=0; i<charSize; i++){
  int temp = inChars[i];
  for(int j=0; j<8; j++){
    if (method==1){
      if ((temp >> j) & 1){ // sending on-off signals for  corresponding bits
        digitalWrite(3, HIGH);
      }else{
        digitalWrite(3, LOW);
      }
      delay(delayTime); 
    }else if (method==2){ // sending Manchester signals for corresponding bits, 
      if ((temp >> j) & 1){ // 01 for 1, 10 for 0.
        digitalWrite(3, HIGH);
        delay(delayTime/2);
        digitalWrite(3, LOW);
      }else{
        digitalWrite(3, LOW);
        delay(delayTime/2);
        digitalWrite(3, HIGH);
      }
      delay(delayTime/2);
    }
  }

}
} 
