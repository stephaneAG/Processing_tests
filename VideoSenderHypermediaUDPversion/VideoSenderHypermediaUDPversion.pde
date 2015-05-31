/*
*
*    VideoSender Processing Test Sketch ,this time using the 'hypermedia' UDP lib
*    by Stéphane Adam Garnier - 2012
*    >> Code adapted from random source, for the moment worst than personal code in terms of execution (..)
*
*/

// libs imports // ------ //
import processing.video.*;
import java.io.*;
import javax.imageio.*;
import java.awt.image.BufferedImage;

import hypermedia.net.*; // the hypermedia UDP lib

// class instances & vars  // ------ //
UDP udp; // the UDP obj
Capture cam; // the camera capture obj

//BufferedImage bufferedImageIN; // the image as seen by connected clients (..)
PImage remoteView; // above  ?

int w = 320; // the width of one image (the sketch uses the double of this var as its width (..) )
int h = 240;
// setup // ------ //
void setup(){
    size(w * 2, h, P2D);
    smooth();
    
    // setting up UDP
    udp = new UDP(this, 9100, "127.0.0.1");
    udp.listen(true);
    
    println("isMulticast? " + udp.isMulticast() );
    println("isJoined? " + udp.isJoined() );
    
    // setting up camera capture
    cam = new Capture(this, width, height, 30);
    
    //setup the bufferedImage we'll use later for received bytes
    //bufferedImageIN = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );
    
}
// draw // ------ //
void draw(){
  image(cam, 0, 0, w, h);
  //image(remoteView, w, 0, w, h);
}
// main fcns // ------ //
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
    udp.send(packet);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  
}

void receive(byte[] data){ // method provided by the 'hypermedia UDP' library
  println("Got datagram with " + data.length +" bytes of data");
  
    // read incoming data into a ByteArrayInputStream
    ByteArrayInputStream baiSt = new ByteArrayInputStream(data);
    //InputStreamReader isr = new InputStreamReader(baiSt);
  
  //receivedFromUDP(data); // dumb, isn't it ? ;D
}

void receivedFromUDP(byte[] data){ // custom function to call the one just above (easier to comment/uncomment (..) )
    println("Got datagram with " + data.length +" bytes of data");
    
    // read incoming data into a ByteArrayInputStream
    ByteArrayInputStream baiSt = new ByteArrayInputStream(data);
    InputStreamReader isr = new InputStreamReader(baiSt);
    
    // notify about the new image
    //gettingNewImage = true;
    
    //load up pixel array from remoteFrame
    //remoteFrame.loadPixels();
    
    try{
        //try to build a BufferedImage based on the incoming data ( and making JPEG data > pixel data )
        BufferedImage img = ImageIO.read(baiSt);
        
        //move pixel data into the remoteFrame
        //img.getRGB(0, 0, w, h, remoteFrame.pixels, 0, w);
        
    }catch(IOException ioe){
        println("Read exception " + ioe.getMessage() );
    }
    
    //update the remoteFrame with new content
    //remoteFrame.updatePixels();
    //gettingNewImage = false;
    
    
    
}

// other fcns // ------ //
void keyPressed(){
    if(key == 'q'){
       exit();
    }
}

void captureEvent(Capture capt){
        //read from camera
        capt.read();
        //whenever we get an image, send it
        broadcast(capt);
}
