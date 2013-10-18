void startOSC() {
  server = new OscP5(this, LOCAL_PORT);
  myRemoteLocation = new NetAddress(REMOTE_IP_ADDRESS, REMOTE_PORT);
}

void oscEvent(OscMessage message) {
  if (message.checkAddrPattern("/aurora/layer1")) {
    reactToLayer1(message);
  } else if (message.checkAddrPattern("/aurora/layer2")) {
    reactToLayer2(message);
  }
}

void reactToLayer1(OscMessage message) {
  int track = message.get(0).intValue();
  int flag = message.get(1).intValue();
  float frequency = message.get(2).floatValue();
  float amplitude = message.get(3).floatValue();
  for (int i = 0; i < NUMBER_OF_FLIES; i += track) {
    ffs[i].setScaleFactor(15 * amplitude);
  }
  //println("Layer 1 | track:" + track + " flag:" + flag + " freq:" + frequency + " amplitude:" + amplitude);
}

void reactToLayer2(OscMessage message) {
  int track = message.get(0).intValue();
  int flag = message.get(1).intValue();
  float frequency = message.get(2).floatValue();
  float amplitude = message.get(3).floatValue();
  println("Layer 2 | track:" + track + " flag:" + flag + " freq:" + frequency + " amplitude:" + amplitude);
}
