#define soundPin 13
#define lButton 3
#define rButton 2

int buttons[] = {3,2};
int lLeds[] = {10,9,8};
int rLeds[] = {5,6,7};
int* leds[] = {lLeds, rLeds};

void setup() {
  pinMode(rButton, INPUT_PULLUP);
  pinMode(lButton, INPUT_PULLUP);
  pinMode(soundPin, OUTPUT);
  for(int i = 0; i < 3; i++) {
    pinMode(rLeds[i], OUTPUT);
    pinMode(lLeds[i], OUTPUT);
  }
}


void loop() {
  for(int i = 0; i < 3; i++) {
    digitalWrite(rLeds[i], 1);
    digitalWrite(lLeds[i], 1);
  }
  int hps[] = {3,3};
  beep();
  while(hps[0] && hps[1]) {
    for(int p = 0; p < 2; p++) {
      if(digitalRead(buttons[p])) continue;
      hps[p]--;
      for(int i = 0; i < 3; i++) {
        digitalWrite(leds[p][i], i < hps[p]);
      }
      if(hps[p] > 0) {
        tone(soundPin, 4000, 1000);
        delay(1000);
        beep();
      }
    }
  }
  tone(soundPin, 2000, 900);
  for(int j = 0; j < 9; j++) {
    for(int i = 0; i < 3; i++) {
      digitalWrite(lLeds[i], (i==j%3) * hps[1]);
      digitalWrite(rLeds[i], (i==j%3) * hps[0]);
    }
    delay(100);
  }
}

void beep() {
  while(!digitalRead(buttons[0]) || !digitalRead(buttons[1])) {};
  delay(random(1000, 4000));
  tone(soundPin, 3000, 250);
}
