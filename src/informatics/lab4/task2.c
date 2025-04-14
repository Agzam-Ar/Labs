#include <LiquidCrystal.h>

#define ledPin 7
#define textSize 113

int buttons[] = {5,4,3};

LiquidCrystal lcd(8, 9, 10, 11, 12, 13);

char* text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit Lorem ipsum dolor sit amet, consectetur adipisicing elit";

void setup () { 
  lcd.begin(16, 10);
  lcd.noAutoscroll();
  for(int i = 0; i < 3; i++) {
    pinMode(buttons[i], INPUT_PULLUP);
  }
  pinMode(ledPin, OUTPUT);
}

int led = 0;
int lastLed = 0;
int y = 0;

int direction = 0;

int lastDir = 0;

void loop () {
  if(!digitalRead(buttons[0])) {
    if(y+1 < textSize/16) y++;
  }
  if(!digitalRead(buttons[2])) {
    if(y > 0) y--;
  }  
  
  for(int l = 0; l < 2; l++) {
    lcd.setCursor(0,l);
    for(int x = 0; x < 16; x++) {
      int index = x + 16*y + l*16;
      if(index >= textSize) {
        lcd.print(" ");
        continue;
      }
      lcd.print(text[index]);
    }
  }

  int ledState = !digitalRead(buttons[1]);
  if(!ledState && lastLed) {
    led = !led;
    digitalWrite(ledPin, led);
  }
  lastLed = ledState;
  delay(100);
}