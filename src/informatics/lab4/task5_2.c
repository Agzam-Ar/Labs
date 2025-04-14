#define w 5
#define h 7

int xs[] = {9,10,11,12,13};
int ys[] = {2,3,4,5,6,7,8};

int frame1[] = {
  0b00000,
  0b00000,
  0b10100,
  0b01010,
  0b01111,
  0b01010,
  0b10100
};

int frame2[] = {
  0b00000,
  0b10100,
  0b01010,
  0b01111,
  0b01010,
  0b10100,
  0b00000
};

int frame3[] = {
  0b10100,
  0b01010,
  0b01111,
  0b01010,
  0b10100,
  0b00000,
  0b00000
};

void setup() {
    for(int i = 2; i <= 13; i++) {
  		pinMode(i, OUTPUT);
 	}
}

void loop() {
  int fid = millis()/500%4;
	int* frame = fid%2 ? frame2 : (fid == 0 ? frame1 : frame3);
  
	for(int y = 0; y < h; y++) {
	  for(int y1 = 0; y1 < h; y1++) {
			digitalWrite(ys[y1], 1);
    }
    for(int x = 0; x < w; x++) {
			digitalWrite(xs[x], bitRead(frame[y], x));
    }
	  digitalWrite(ys[y], 0);
    delay(1);
	}
}

