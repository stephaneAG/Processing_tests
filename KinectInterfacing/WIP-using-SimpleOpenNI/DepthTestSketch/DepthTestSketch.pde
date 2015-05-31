/* StephaneAG - 2012 */
//Kinect depth

import SimpleOpenNI.*;

SimpleOpenNI context;

void setup(){
    context = new SimpleOpenNI(this);
    
    context.setMirror(true);
    
    context.enableDepth();
    
    size( context.depthWidth(), context.depthHeight() );
    
}

void draw(){
    
    context.update();
    
    image( context.depthImage(), 0, 0);
  
}

void keyPressed(){
    if(key == ' '){
      save("tof.jpg");
    }
}
