/* StephaneAG */
//depth distance test sketch

import SimpleOpenNI.*;

SimpleOpenNI context;

void setup(){
  context = new SimpleOpenNI(this);
  
  context.setMirror(true);
  
  context.enableRGB();
  context.enableDepth();
  
  //context.alternativeViewPointDepthToImage();
  
  size ( context.rgbWidth + context.depthWidth(), context.rgbHeight() );
  
}

void draw(){
  context.update();
  
  image( context.rgbImage(), 0, 0 );
  image( context.depthImage(), context.rgbWidth(), 0);
}

void mousePressed(){
  if (mouseX < context.rgbWidth()){
    int[] depthMap = context.depthMap();
    int idx = mouseX + mouseY * context.rgbWidth();
    println( depthMap[idx] );
  }
}
