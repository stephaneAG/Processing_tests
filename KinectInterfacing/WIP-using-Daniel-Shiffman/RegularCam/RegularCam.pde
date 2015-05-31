/* StephaneAG - 2012 */
/* simple Kinect interfacing */

import org.openkinect.*;
import org.openkinect.processing.*;

Kinect kinect; //kinect library object

boolean rgb = true;
//boolean ir = false;
//boolean depth = true;

//tilt start position
float deg = 15;


void setup(){
  
  size(800,600);
  
  kinect = new Kinect(this);
  kinect.start();
  
  //kinect object parameters
  kinect.enableRGB(rgb);
  //kinect.enableIR(ir);
  //kinect.enableDepth(depth);
  kinect.tilt(deg);
  
}

void draw(){
  PImage imageFromKinectRGBCam = kinect.getVideoImage();
  image(imageFromKinectRGBCam,0,0);
  
}

void keyPressed(){
    
    //enable the depth
    
    //enable ir
    
    //enable rgb
    
    
    //tilt up
    if (key == 'z'){
      deg++;
      deg = constrain(deg,0,30);
      kinect.tilt(deg);
    }
    
    //tilt down
    else if (key == 's') {
      deg--;
      deg = constrain(deg,0,30);
      kinect.tilt(deg);
    }
    
  
}

void stop(){ //never seen before but may prevent the application to crahs while ending (..> to digg ! ^)
    kinect.quit();
    super.stop();
}
