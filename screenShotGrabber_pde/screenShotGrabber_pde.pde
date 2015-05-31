/* screenGrabber > little tool to capture desktop screen */

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.DisplayMode;
import java.awt.image.BufferedImage;

PImage screenShot;

//static public void main(String args[]){
//  PApplet.main(new String[]{
//    "--present", "screenShotGrabber"
//  });
//}

void setup(){
  size(screen.width, screen.height);
  screenShot = getScreen();
}

void draw(){
  image( screenShot, 0, 0, width, height );
}

// function that handles taking a screenshot and returning a PImage
PImage getScreen(){
  
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment(); // ge stands for Graphics Env
  GraphicsDevice[] gs = ge.getScreenDevices(); // gs stands for Get Screen
  DisplayMode mode = gs[0].getDisplayMode();
  
  Rectangle bounds = new Rectangle( 0, 0, mode.getWidth(), mode.getHeight() );
  BufferedImage desktop = new BufferedImage( mode.getWidth(), mode.getHeight(), BufferedImage.TYPE_INT_RGB );
  
  try{
    desktop = new Robot(gs[0]).createScreenCapture(bounds);
  }
  catch(AWTException e){
    System.err.println("Screen capture failed");
  }
  
  return( new PImage(desktop) );
  
}
