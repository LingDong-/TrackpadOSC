#pragma once

#include "ofMain.h"
#include "ofxOsc.h"
#define OSC_PORT 9000

struct Finger{
	int id;
	ofVec2f position;
	ofVec2f velocity;
	ofVec2f ellipse;
	int frame;
	int state;
	float size;
	float angle;
};

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);

		ofxOscReceiver receiver;
    	ofXml xml;
		vector<Finger> fingers;
};
