import oscP5.*;
import netP5.*;

// OSC and Network config
final int LOCAL_PORT = 12001;
final String REMOTE_IP_ADDRESS = "127.0.0.1";
final int REMOTE_PORT = 12001;

OscP5 server;
NetAddress myRemoteLocation;

final int GAIN = 15;

void startOSC() {
  server = new OscP5(this, LOCAL_PORT);
  myRemoteLocation = new NetAddress(REMOTE_IP_ADDRESS, REMOTE_PORT);
}

void oscEvent(OscMessage message) {
  if (message.checkAddrPattern("/aurora/layer1")) {
    reactToLayer1(message.get(0).intValue(), message.get(1).intValue(), message.get(2).floatValue(), message.get(3).floatValue());
  } else if (message.checkAddrPattern("/aurora/layer2")) {
    reactToLayer2(message.get(0).intValue(), message.get(1).intValue(), message.get(2).floatValue(), message.get(3).floatValue());
  }
}

void reactToLayer1(int track, int flag, float frequency, float amplitude) {
  for (int i = 0; i < NUMBER_OF_FLIES; i += track) {
    ffs[i].setScaleFactor(GAIN * amplitude);
  }
  // println("Layer 1 | track:" + track + " flag:" + flag + " freq:" + frequency + " amplitude:" + amplitude);
}

void reactToLayer2(int track, int flag, float frequency, float amplitude) {
  // println("Layer 2 | track:" + track + " flag:" + flag + " freq:" + frequency + " amplitude:" + amplitude);
}
