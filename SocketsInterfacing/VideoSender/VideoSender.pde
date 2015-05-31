/* StephaneAG - 2012 */
//server broadcasting video across UDP sockets & WebSockets

import muthesius.net.*; // for WebSocketP5 library
import org.webbitserver.*;

import processing.video.*; //processing official library for cams

import javax.imageio.*; // for image compression
import java.awt.image.*; 

import org.apache.commons.codec.binary.*; // for Base64
//import org.apache.commons.codec.binary.Base64;

// This is the port we are sending to (UDPSocket)
int clientPort = 9100; 
// This is our object that sends UDP out
DatagramSocket ds; 
// Capture object
Capture cam;

// WebSocket part below //
WebSocketP5 ws;

void setup() {
  size(320,240);
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
  
  //setting up the WebSocket
  ws = new WebSocketP5(this, 8080);
  
  // Initialize Camera
  cam = new Capture( this, width,height,30);
}

void captureEvent( Capture c ) {
  c.read();
  // Whenever we get a new image, send it!
  broadcast(c);
}

void draw() {
  image(cam,0,0);
}


// Function to broadcast a PImage over UDP
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
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.1.10"),clientPort)); // iMac
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.85.128"),clientPort)); //Virtual Machine on Lion
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.1.9"),clientPort)); // iPhone
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

