#include "Wire.h"
#include "TroykaLedMatrix.h"

TroykaLedMatrix matrix;

const uint8_t frame1[] {
  0b00000000,
  0b10001000,
  0b01110000,
  0b10101000,
  0b01110000,
  0b00100000,
  0b01110000,
  0b11111111,
};
const uint8_t frame2[] {
  0b00000000,
  0b01000100,
  0b00111000,
  0b01010100,
  0b00111000,
  0b00010000,
  0b00111000,
  0b11111111,
};
const uint8_t frame3[] {
  0b00000000,
  0b00100010,
  0b00011100,
  0b00101010,
  0b00011100,
  0b00001000,
  0b00011100,
  0b11111111,
};

void setup() {
  Wire.begin();
  matrix.begin();
  matrix.clear();
  matrix.drawBitmap(frame1);
}

void loop() {
  matrix.drawBitmap(frame1);
  delay(100);
  matrix.drawBitmap(frame2);
  delay(100);
  matrix.drawBitmap(frame3);
  delay(100);
  matrix.drawBitmap(frame2);
  delay(100);
}