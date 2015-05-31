/* StephaneAG - 2012 */
//server broadcasting video across UDP sockets & WebSockets

import muthesius.net.*; // for WebSocketP5 library
import org.webbitserver.*;

import processing.video.*; //processing official library for cams

import javax.imageio.*; // for image compression
import java.awt.image.*; 

import org.apache.commons.codec.binary.*; // for Base64
//import org.apache.commons.codec.binary.Base64;

// below imports are need to grab a screenshot of the desktop screen
// >> (> forward what is ACTUALLY on screen, so we can hide the processing App while cotinuing to broadcast the 'desktop view' )
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.DisplayMode;
//import java.awt.image.BufferedImage; // should not be needed as we already imported all the content of java.awt.image.* (..)
//PImage screenShot; // will be used in setup to get the first screenshot (and then start to broadcast it/the following screenshots)

// This is the port we are sending to (UDPSocket)
int clientPort = 9100; 
// This is our object that sends UDP out
DatagramSocket ds; 
// Capture object
//Capture cam; // was used to broadcast webcam output

// WebSocket part below //
WebSocketP5 ws;

void setup() {
  frameRate(60); // testing if it does make any difference
  size(320,240); // was used to fit in the iphone screen / to get not too big image from webcam (..)
  //size(screen.width, screen.height);
  //screenShot = getScreen(); // get first screenshot and display it in the 'Processing App view'
  background(102);
  
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
  
  //setting up the WebSocket
  ws = new WebSocketP5(this, 8080);
  
  // Initialize Camera
  //cam = new Capture( this, width,height,30); // was used to broadcast webcam output
}

//void captureEvent( Capture c ) {
//  c.read();
//  // Whenever we get a new image, send it!
//  broadcast(c);
//}

void draw() {
  //image(cam,0,0); // was used to broadcast webcam output
  //image( screenShot, 0, 0, width, height ); // 'first time display' ( recalled at the bottom of the function invoked right below  to update)
  startScreenCapture(); // start to take screenshot of the desktop & display them in the Processing App view / broadcast them
}


// Function to broadcast a PImage over UDP & Websockets
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)
void broadcast(PImage img) {

  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream	= new ByteArrayOutputStream();
  BufferedOutputStream bos		= new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  
  
  // SEND STUFF TO "CLASSIC" UDP SOCKET //
  
  // Get the byte array, which we will send out via UDPSocket
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("Sending datagram with " + packet.length + " bytes");
  try {
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("localhost"),clientPort));
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.1.7"),clientPort));
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.85.128"),clientPort)); //Virtual Machine on Lion
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.1.9"),clientPort)); // iPhone // DACTIVATED DURING SOME TESTS
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  
  // SEND STUFF TO WEBSOCKET
  
  //get the byte array wich we will send via WebSocket
  try{
      String out = new String(Base64.encodeBase64(baStream.toByteArray(), false));
      ws.broadcast("data:image/*; base64, "+out);
  }
  catch(Exception e){
      e.printStackTrace();
  }
  
  
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

// function that dispatch the needed actions in a practical order (..)
void startScreenCapture(){
  //background(102); // set the background to black > should clear the screen (and thus, clear the last display screenshot too ;p)
  PImage currentScreenShot = getScreen(); // 1 > get a Pimage from a desktop screenshot
  currentScreenShot.resize(0, 600); // resize it (really basic for the moment) > will fit to the resolution of the ipad (goal of the experiment (..))
  broadcast(currentScreenShot);// 2 > broadcast it
  //image( currentScreenShot, 0, 0, width, height );// 3 > display it in the Processing App view
}
