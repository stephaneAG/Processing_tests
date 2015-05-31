/*
*
*    Streaming capturing images in Processing Test Sketch
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
Capture cam;
UDP udp;

PGraphics workspace;
PImage localFrame;
PImage remoteFrame;

int w = 320;
int h = 240;

boolean gettingNewImage = false;

// setup // ------ //
void setup(){
    size(w * 2, h, P2D);
    //smooth();
    background(44);
    colorMode(RGB, 255);
    
    udp = new UDP(this, 6000, "127.0.0.1");
    udp.listen(true);
    
    println("isMulticast? " + udp.isMulticast() );
    println("isJoined? " + udp.isJoined() );
    
    localFrame = new PImage(w, h);
    remoteFrame = new PImage(w, h);
    workspace = createGraphics(w, h, P2D);
    
}
// draw // ------ //
synchronized void draw(){
    
    // if we have a localFrame, draw it
    if ( localFrame != null ){
        image(localFrame, 0, 0);
    }
    
    //if we're not currently currently getting a new frame, show the one we have
    if( !gettingNewImage && remoteFrame != null ){
        image(remoteFrame, w, 0);
    }
  
}
// main fcns // ------ //
void sendFrame(){
  
    ByteArrayOutputStream baoSt = new ByteArrayOutputStream();
    BufferedOutputStream boSt = new BufferedOutputStream(baoSt);
    
    //load up the pixel array from fro the local frame
    localFrame.loadPixels();
    
    //create a bufferedImage so we can use the 'JPEG' encoder inside
    BufferedImage img = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
    
    // transfer pixels from localFrame to the bufferedImage
    try{
        //encode data inside the bufferedImage into JPEG data and store it in the BufferedOutputStream 'boSt'
        ImageIO.write(img, "jpg", boSt);
        
    }catch(IOException ioe){
        println("write exception " + ioe.getMessage() );
    }
    
    // get the byteArray from the ByteArrayOutputStream 'baoSt'
    byte[] packet = baoSt.toByteArray();
    
    // send JPEG data as a datagram
    println("Sending datagram with " + packet.length +" bytes");
    udp.send(packet);

}

void receive(byte[] data){
    
    println("Got datagram with " + data.length +" bytes of data");
    
    // read incoming data into a ByteArrayInputStream
    ByteArrayInputStream baiSt = new ByteArrayInputStream(data);
    InputStreamReader isr = new InputStreamReader(baiSt);
    
    // notify about the new image
    gettingNewImage = true;
    
    //load up pixel array from remoteFrame
    remoteFrame.loadPixels();
    
    try{
        //try to build a BufferedImage based on the incoming data ( and making JPEG data > pixel data )
        BufferedImage img = ImageIO.read(baiSt);
        
        //move pixel data into the remoteFrame
        img.getRGB(0, 0, w, h, remoteFrame.pixels, 0, w);
        
    }catch(IOException ioe){
        println("Read exception " + ioe.getMessage() );
    }
    
    //update the remoteFrame with new content
    remoteFrame.updatePixels();
    gettingNewImage = false;
    
  
}

// other fcns // ------ //
synchronized void keyPressed(){
    if(key == 'q'){
       exit();
    }
    if(key == 'c'){
        cam = new Capture(this, w, h, 30); // 5 ? > I thnk its the fps
        println("capture started ..");
    }
    
}

synchronized void captureEvent(Capture capt){
    if( capt.available() ){
        
        //read from camera
        capt.read();
        
        // store camera frame in the localFrame obj
        workspace.set(0, 0, capt);
        localFrame = workspace.get();
        
        sendFrame();
    }
}
