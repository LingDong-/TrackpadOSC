#include "ofApp.h"

ofVec2f str2vec2f(string s){
  int comma = s.find(",");
  return ofVec2f(stof(s.substr(0,comma)), stof(s.substr(comma+1)));
}

ofColor id2color(int id){
  int r = (id>>4)&3;
  int g = (id>>2)&3;
  int b = id&3;
  return ofColor(r*255/3,g*255/3,b*255/3);

}

//--------------------------------------------------------------
void ofApp::setup(){
  receiver.setup(OSC_PORT);
}

//--------------------------------------------------------------
void ofApp::update(){
  while(receiver.hasWaitingMessages()){

    ofxOscMessage m;
    receiver.getNextMessage(m);
    if(m.getAddress() == "/trackpad"){
      fingers.clear();

      string s = m.getArgAsString(0);
      xml.loadFromBuffer(s);
      xml.setTo("multitouch");
      int nChildren = xml.getNumChildren();
      for (int i = 0; i < nChildren; i++){xml.setToChild(i);
        Finger fgr;

        fgr.id = stoi(xml.getAttribute("id"));
        fgr.frame = stoi(xml.getAttribute("frame"));
        fgr.state = stoi(xml.getAttribute("state"));
        fgr.position = str2vec2f(xml.getAttribute("position"));
        fgr.velocity = str2vec2f(xml.getAttribute("velocity"));
        fgr.ellipse = str2vec2f(xml.getAttribute("ellipse"));
        fgr.angle = stof(xml.getAttribute("angle"));
        fgr.size = stof(xml.getAttribute("size"));

        fingers.push_back(fgr);
      xml.setToParent();}

    }else{
      cout << "unrecognized OSC message received" << endl;
    }

  }
}

//--------------------------------------------------------------
void ofApp::draw(){
  float w = ofGetWindowWidth();
  float h = ofGetWindowHeight();
  for (int i = 0; i < fingers.size(); i++) {
    Finger fgr = fingers[i];
    
    float x = fgr.position.x*w;
    float y = (1-fgr.position.y)*h;

    ofPushMatrix();
    ofTranslate(x,y);
    ofRotate(-fgr.angle);

    ofFill();
    ofSetColor(id2color(fgr.id));
    ofDrawEllipse(0,0, 10*fgr.size*fgr.ellipse.x, 10*fgr.size*fgr.ellipse.y);
    ofPopMatrix();
    
    ofSetLineWidth(10);
    ofNoFill();
    ofSetColor(255);
    ofDrawLine(x,y,x+fgr.velocity.x*w*0.1,y-fgr.velocity.y*h*0.1);
  }

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
