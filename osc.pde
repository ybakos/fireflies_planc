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
  print("Layer 1: ");
  Object[] objs = message.arguments();
  println(objs);
}

void reactToLayer2(OscMessage message) {
  makeFireFliesGoCrazy();
}

void makeFireFliesGoCrazy() {

}

