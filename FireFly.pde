class FireFly {

  float r;
  float g;
  float b;
  float a;
  color col;
  color colStroke;

  PVector loc;
  PVector spd;
  float len, ht;
  PVector[] vecs = new PVector[3];

  // motion dynamics
  PVector wave = new PVector();
  float waveAmp;
  float waveFreq;
  float waveJitter;
  float waveTheta;

  float scaleFactor = 1.0;
  float initScale = scaleFactor;

  FireFly() {
    loc = new PVector();
    spd = new PVector();
    init();
  }

  FireFly(float len, float ht, color col, color colStroke) {
    this.len = len;
    this.ht = ht;
    this.col = col;
    this.colStroke = colStroke;
    loc = new PVector();
    spd = new PVector(random(-.2, 2), random(-.2, .2));
    init();
  }

  FireFly(PVector loc, float len, float ht, color col, color colStroke, PVector spd) {
    this.loc = loc;
    this.len = len;
    this.ht = ht;
    this.col = col;
    this.colStroke = colStroke;
    this.spd = spd;
    init();
  }

  void init() {
    // draw triangle
    float theta = 0.0;
    float rot = TWO_PI / 3.0;
    for (int i = 0; i < 3; ++i) {
      float x = cos(theta)*len;
      float y = sin(theta)*ht;
      vecs[i] = new PVector(x, y);
      theta += rot;
    }
    // init motion dynamics
    waveAmp = random(3);
    waveFreq = random(-PI / 30, PI / 30);
  }

  void display() {
    fill(col);
    noStroke();
    pushMatrix();
    translate(loc.x, loc.y);
    scale(scaleFactor);
    strokeWeight(1);
    float rot = atan2(wave.y, wave.x);
    rotate(rot);
    beginShape();
    for (int i = 0; i < 3; ++i) {
      vertex(vecs[i].x, vecs[i].y);
    }
    endShape(CLOSE);
    popMatrix();

    if (loc.x > width / 2) {
      loc.x = -width / 2;
      //spd.x = random(-spd.x, spd.x);
    } else if (loc.x < -width / 2) {
      loc.x = width / 2;
      //spd.x = random(-spd.x, spd.x);
    }
    if (loc.y > height / 2) {
      loc.y = -height / 2;
      //spd.y = random(-spd.y, spd.y);
    } else if (loc.y < -height / 2) {
      loc.y = height / 2;
      //spd.y = random(-spd.y, spd.y);
    }
    if (scaleFactor > initScale) {
      scaleFactor*=.2;
    }
  }

  void move() {
    waveJitter = random(-3.3, 3.3); // makes fireflies shake
    wave.x = spd.x + sin(waveTheta) * waveAmp + waveJitter;
    wave.y = spd.y + cos(waveTheta) * waveAmp + waveJitter;
    //wave.x = sin(waveTheta)*waveAmp + waveJitter;
    //wave.y = cos(waveTheta)*waveAmp + waveJitter;
    // wave.x = mouseX + sin(waveTheta)*waveAmp + waveJitter;
    //wave.y = mouseY + cos(waveTheta)*waveAmp + waveJitter;
    loc.add(wave);
    waveTheta += waveFreq;
  }

  void setScaleFactor(float scaleFactor) {
    this.scaleFactor = scaleFactor;
  }

  void setColor(color col) {
    this.col = col;
  }

  void setSpd(PVector spd) {
    this.spd.set(spd);
  }

}
