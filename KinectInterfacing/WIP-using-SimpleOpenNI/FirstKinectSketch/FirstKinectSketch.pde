/* StephaneAG - 2012*/
/* first Processing sktech making use of the libfreenect & Simple-openni [learned for jap website] */

import SimpleOpenNI.*;

SimpleOpenNI  context;

void setup()
{ 
  context = new SimpleOpenNI(this);
  
  context.setMirror(true);
  
  // enable camera image generation
  context.enableRGB();
 
  background(200,0,0);
  size(context.rgbWidth(), context.rgbHeight()); 
}

void draw()
{
  // update the cam
  context.update();
  
  // draw camera
  image(context.rgbImage(),0,0);
}

void keyPressed(){
    if (key == 's'){
        save ("kinectTof.jpg");
    }
}
