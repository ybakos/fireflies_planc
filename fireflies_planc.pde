// Fireflies that react to OSC (Open Sound Control) data received
// over the network.
//
// Ira Greenberg

import oscP5.*;
import netP5.*;

// OSC and Network config
final int LOCAL_PORT = 12000;
final String REMOTE_IP_ADDRESS = "127.0.0.1";
final int REMOTE_PORT = 12001;

OscP5 server;
NetAddress myRemoteLocation;

String[] maxVarNames = {"fFlies", "trackNum", "flagData", "ampData", "freqData"};

int trackNum, flagData; // (-1, 0, 1)
float ampData, freqData;
float timeSlice;
float thetaFade;

int NUMBER_OF_FLIES = 300;
FireFly[] ffs = new FireFly[NUMBER_OF_FLIES];

// visual configuration
final int SCREEN_WIDTH = 1280;
final int SCREEN_HEIGHT = 960;
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
}

void draw() {
  float alph = sin(thetaFade) * (millis() * timeSlice);
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

void startOSC() {
  server = new OscP5(this, LOCAL_PORT);
  myRemoteLocation = new NetAddress(REMOTE_IP_ADDRESS, REMOTE_PORT);
}

void oscEvent(OscMessage message) {
  // println(message.get(0));
  if (message.checkAddrPattern("/fFlies/allData")) {
    Object[] objs = message.arguments();
    int counter = 0;
    for (int i = 0; i < objs.length; ++i) {
      //objs[i].toString()
      switch(counter) {
      case 0:
        trackNum = int(objs[i].toString()) - 1;
        // println("trackNum = " + trackNum);
        break;
      case 1:
        flagData = int(objs[i].toString());
        if (flagData == 1) {
          ffs[trackNum].setColor(white);
        } else if (flagData == -1) {
          // ffs[trackNum].setScaleFactor(ffs[trackNum].initScale);
          //ffs[trackNum].setColor(color(255, 255, 0, 0));
        } else {
          ffs[trackNum].setColor(periwinkle);
        }
        // println("flagData = " + flagData);
        break;
      case 2:
        freqData = float(objs[i].toString());
        // println("freqData = " + freqData);
        break;
      case 3:
        ampData = float(objs[i].toString());
        //println("ampData = " + ampData);
        // ampData >.001 keeps low level stuff out,  increase for guitar noise
        if (ampData > 0.001 && flagData != -1) {
          //println("freq = " + (1+((8000.0-freqData)*.0009)));
          // println (ampData);
          //ffs[trackNum].setScaleFactor(1+(((8000.0-freqData)*.0009)));
          ffs[trackNum].setScaleFactor(pow(1 / (freqData / 8000.0), 0.68));
          //ffs[trackNum].setColor(color(255, 255, 200 + random(55)));
          ffs[trackNum].setColor(color(255 * (ampData * 10), 0 , 255 - (ampData * 10)));
          //println(255 * ampData * 10);
        }
        // println("ampData = " + ampData);
        //  println();
        break;
      } // end switch
      if (counter < 4) {
        ++counter;
      } else {
        counter = 0;
      }
    }
    //println("trackNum = " + trackNum);
    //println("trackNum1 = " + trackNum);
  }
}

