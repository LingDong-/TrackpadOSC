
import oscP5.*;

OscP5 oscP5;
MultitouchController multitouch;

PVector cursor = new PVector(0,0);

void setup(){
  //fullScreen();
  size(640,480);
  oscP5 = new OscP5(this,9000);
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
