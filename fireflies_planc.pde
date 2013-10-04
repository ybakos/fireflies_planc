import oscP5.*;
import netP5.*;

//FireFly ff;
// lower track 

PVector prey;
boolean isPressed;

int len = 300;
FireFly[] ffs = new FireFly[len];

OscP5 oscP5;
NetAddress myRemoteLocation;

String[] maxVarNames = {
  "fFlies", "trackNum", "flagData", "ampData", "freqData"
};

int trackNum, flagData; //(-1, 0, 1)
float ampData, freqData;
float timeSlice;
float thetaFade;
//boolena isStart;

void setup() {
  size(1280, 960);
  background(0);
  smooth();
  timeSlice = 255.0/480000.0;
  //noStroke();
  //prey = new PVector();
  //float len, float ht, color col
  //ff = new FireFly(8, 4, color(127, 115, 115));
  for (int i=0; i<len; i++) {
    ffs[i] = new FireFly(random(6, 4), random(2, 1), color(255, 175, 0), color(255, 255, 0));
  }
  startOSC();
  noLoop();
}


void startOSC() {
  //start oscP5
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
}


void oscEvent(OscMessage theOscMessage) {
  // println(theOscMessage.get(0));
  if(theOscMessage.checkAddrPattern("/fFlies/allData")==true) {
    Object[] objs = theOscMessage.arguments();
    int counter = 0;
    for (int i=0; i<objs.length; i++) {
      //objs[i].toString()
      switch(counter) {
      case 0:
        trackNum = int(objs[i].toString())-1;
        // println("trackNum = " + trackNum);
        break;
      case 1:
        flagData = int(objs[i].toString());

        if(flagData==1) {
          ffs[trackNum].setColor(color(255, 255, 255));
        } 
        else if (flagData==-1) {
          // ffs[trackNum].setScaleFactor(ffs[trackNum].initScale);
          //ffs[trackNum].setColor(color(255, 255, 0, 0));
        } 
        else {        
          ffs[trackNum].setColor(color(255, 200, 255));
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
        if (ampData>.001 && flagData!=-1) { 
          //println("freq = " + (1+((8000.0-freqData)*.0009)));
          // println (ampData);
          //ffs[trackNum].setScaleFactor(1+(((8000.0-freqData)*.0009)));
          ffs[trackNum].setScaleFactor(pow(1/(freqData/8000.0), .68));
          //ffs[trackNum].setColor(color(255, 255, 200 + random(55)));
          ffs[trackNum].setColor(color(255 * (ampData * 10), 0 , 255 - (ampData * 10)));
          //println(255 * ampData * 10);        
        }
        // println("ampData = " + ampData);
        //  println();
        break;
      }
      if(counter<4) {
        counter++;
      } 
      else {
        counter = 0;
      }
    }
    //println("trackNum = " + trackNum);
    //println("trackNum1 = " + trackNum);
  }
}


void draw() {
 // if (isPressed) {
    float alph = sin(thetaFade)*(millis()*timeSlice);
    //fill(0, 255);
 // }
  background(0);
  translate(width/2, height/2);
  //ff.display();
  //ff.move();

  beginShape();

  //println(alph);
  stroke(255, 255, 200, alph*.35);
  //println(alph);
  //stroke(255, 255, 255,  150);
  noFill();
  for (int i=0; i<len; i++) {
    vertex(ffs[i].loc.x, ffs[i].loc.y);
  }
  endShape();

  for (int i=0; i<len; i++) {
    noStroke();
    ffs[i].display();
    ffs[i].move();
  }
  thetaFade += PI/(480*60);
}

void mousePressed() {
  loop();
  isPressed = true;
}

