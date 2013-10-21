// Fireflies that react to OSC (Open Sound Control) data received
// over the network.
//
// Ira Greenberg, Yong Bakos.


float timeSlice;
float thetaFade;

int NUMBER_OF_FLIES = 1200;
FireFly[] ffs = new FireFly[NUMBER_OF_FLIES];
boolean fliesShouldBeCrazy = false;

// visual configuration
final int SCREEN_WIDTH = 1920;
final int SCREEN_HEIGHT = 1080;
final color black = color(0, 0, 0);
final color white = color(255, 255, 255);
final color yellow = color(255, 255, 0);
final color gold = color(255, 175, 0);
final color periwinkle = color(255, 200, 255);

void setup() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
  background(black);
  smooth();
  timeSlice = 255.0 / 480000.0;
  for (int i = 0; i < NUMBER_OF_FLIES; ++i) {
    ffs[i] = new FireFly(random(6, 4), random(2, 1), gold, yellow);
  }
  startOSC();
  noLoop(); // wait for mouse click
  noCursor();
}

void draw() {
  float alph = 0; //sin(thetaFade) * (millis() * timeSlice);
  background(0);
  translate(width / 2, height / 2);
  beginShape();
  stroke(255, 255, 200, alph * 0.35);
  noFill();
  for (int i = 0; i < NUMBER_OF_FLIES; ++i) {
    vertex(ffs[i].loc.x, ffs[i].loc.y);
  }
  endShape();
  for (int i = 0; i < NUMBER_OF_FLIES; ++i) {
    noStroke();
    ffs[i].display();
    ffs[i].move();
  }
  thetaFade += PI / (480 * 60);
}

void mousePressed() {
  loop();
}

void keyPressed() {
  if (key == 'q') {
    fliesShouldBeCrazy = true;
  } else if (key == 'w') {
    fliesShouldBeCrazy = false;
  }
}
