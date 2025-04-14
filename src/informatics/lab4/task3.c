#include <LiquidCrystal.h>

#define ledPin 7
#define textSize 26

int buttons[] = {5,4,3};

LiquidCrystal lcd(8, 9, 10, 11, 12, 13);

void setup () { 
  lcd.begin(textSize, 2);
  lcd.noAutoscroll();
  lcd.print("Lorem ipsum dolor sit amet");
  for(int i = 0; i < 3; i++) {
    pinMode(buttons[i], INPUT_PULLUP);
  }
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, 1);
}

int led = 0;
int lastLed = 0;
int x = 0;

int direction = 0;

int lastDir = 0;

void loop() {
  int dirState = !digitalRead(buttons[0]);
  if(!dirState && lastDir) {
    direction = !direction;
  }
  lastDir = dirState;

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

  lcd.setCursor(x,1);
  lcd.print(millis()/1000);
  lcd.print(" ");
    
  delay(200);
}