
import oscP5.*;

OscP5 oscP5;
MultitouchController multitouch;

PVector cursor = new PVector(0,0);

void setup(){
  //fullScreen();
  size(640,480);
  OscProperties prop = new OscProperties();
  // increase the datagram size
  // by default it is set to 1536 bytes
  // https://sojamo.de/libraries/oscP5/reference/index.html
  prop.setDatagramSize(10000); 
  prop.setListeningPort(9000);
  
  oscP5 = new OscP5(this, prop);
  
  multitouch = new MultitouchController();

}

void draw(){
  background(0);
  multitouch.visualize();
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/trackpad") == true) {
    multitouch.receive(theOscMessage);
  }
}
