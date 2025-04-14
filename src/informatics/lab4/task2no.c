#include <LiquidCrystal.h>

#define ledPin 7
#define textSize 56

int buttons[] = {5,4,3};

LiquidCrystal lcd(8, 9, 10, 11, 12, 13);

void setup () { 
  lcd.begin(textSize, 1);
  lcd.noAutoscroll();
  lcd.print("Lorem ipsum dolor sit amet, consectetur adipisicing elit");
  for(int i = 0; i < 3; i++) {
    pinMode(buttons[i], INPUT_PULLUP);
  }
  pinMode(ledPin, OUTPUT);
}

int led = 0;
int lastLed = 0;
int x = 0;

int direction = 0;

int lastDir = 0;

void loop () {
  int dirState = !digitalRead(buttons[0]);
  if(dirState) {
    if(direction) {
      if(x < textSize-16) {
        lcd.scrollDisplayLeft();
        x++;
      }
    } else {
      if(x > 0) {
        lcd.scrollDisplayRight();
        x--;
      }
    }
  }
  if(!dirState && lastDir) {
    direction = !direction;
  }
  lastDir = dirState;


  int ledState = !digitalRead(buttons[1]);
  if(!ledState && lastLed) {
    led = !led;
    digitalWrite(ledPin, led);
  }
  lastLed = ledState;
  delay(100);
}