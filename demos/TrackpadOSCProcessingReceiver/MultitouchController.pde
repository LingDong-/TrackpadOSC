class Finger {
  int id = -1;
  int status = -1;
  float angle = -1;
  float size = -1;
  PVector position = new PVector(-1,-1);
  PVector velocity = new PVector(-1,-1);
  PVector ellipse = new PVector(-1,-1);
}

class MultitouchController {
  ArrayList<Finger> fingers = new ArrayList();
  void receive(OscMessage theOscMessage){
    if(theOscMessage.checkAddrPattern("/trackpad") == true) {
      XML multitouch = parseXML(theOscMessage.get(0).stringValue());
      XML[] children = multitouch.getChildren("finger");
      fingers = new ArrayList();

      for (int i = 0; i < children.length; i++) {
        float[] pos = float(split(children[i].getString("position"),','));
        float[] vel = float(split(children[i].getString("velocity"),','));
        float[] elp = float(split(children[i].getString("ellipse" ),','));
        
        Finger fgr = new Finger();
        fgr.id = children[i].getInt("id");
        fgr.status = children[i].getInt("status");
        fgr.angle = -children[i].getFloat("angle") * PI/180.0;
        fgr.size = children[i].getFloat("size");
        fgr.position = new PVector(pos[0],pos[1]);
        fgr.velocity = new PVector(vel[0],vel[1]);
        fgr.ellipse = new PVector(elp[0],elp[1]);
        fingers.add(fgr);
      }
    }
  }
    
  void visualize(){
    pushStyle();
    colorMode(HSB,255);

    for (int i = 0; i < fingers.size(); i++) {
      Finger fgr = fingers.get(i);
      
      float x = fgr.position.x*width;
      float y = (1-fgr.position.y)*height;
      noStroke();
      fill((fgr.id*24)%255,100,200);
      
      pushMatrix();
      translate(x,y);
      rotate(fgr.angle);
      ellipse(0,0,10*fgr.size*fgr.ellipse.x, 10*fgr.size*fgr.ellipse.y);
      popMatrix();
      
      strokeWeight(10);
      stroke(0,0,255);
      line(x,y,x+fgr.velocity.x*width*0.1,y-fgr.velocity.y*height*0.1);
    }
    
    popStyle();
  }  
  
}
