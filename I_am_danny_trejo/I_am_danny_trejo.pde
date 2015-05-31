import hypermedia.video.*;
import java.awt.Rectangle;


OpenCV opencv;

// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;
float lastWidth = 0;
float lastHeight =0;
float lastX=0;
float lastY=0;
float followSpeed = 0.25;
boolean initial = false;

PImage otherFaceImage;  // Declare variable "a" of type PImage




void setup() {

    size( 320, 240 );

    opencv = new OpenCV( this );
    opencv.capture( width, height );                   // open video stream
    opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT2 );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"


    // print usage
    println( "Drag mouse on X-axis inside this sketch window to change contrast" );
    println( "Drag mouse on Y-axis inside this sketch window to change brightness" );

    otherFaceImage = loadImage("danny.png");

}


public void stop() {
    opencv.stop();
    super.stop();
}



void draw() {
  
  
  
  
  

    // grab a new frame
    // and convert to gray
    opencv.read();
    opencv.convert( GRAY );
    opencv.contrast( contrast_value );
    opencv.brightness( brightness_value );

    // proceed detection
    Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );
 //tint(255, 155);
    // display the image
    image( opencv.image(), 0, 0 );

    // draw face area(s)
    noFill();
    stroke(155,155,155);
    for( int i=0; i<faces.length; i++ ) {
        
        if(initial == false)
        {
          initial = true;
          lastWidth =  faces[i].width;
          lastHeight = faces[i].height;
          lastX = faces[i].x;
          lastY = faces[i].y;
        }
        
        
       /*  rect(lastX, 
                              lastY, 
                               lastWidth, 
                              lastHeight);*/
         tint(255, 33);
        
        image(otherFaceImage,  lastX, 
                              lastY, 
                               lastWidth, 
                              lastHeight);
                              
         lastWidth = lastWidth +  ((faces[i].width - lastWidth)* followSpeed);
          lastHeight = lastHeight + ((faces[i].height - lastHeight)* followSpeed);
          lastX = lastX + ((faces[i].x - lastX)* followSpeed);
          lastY = lastY + ((faces[i].y - lastY)* followSpeed);
        i = faces.length;
    }
    
    
  //saveFrame("i_am_danny_trejo-####.tif"); 

}



/**
 * Changes contrast/brigthness values
 */
void mouseDragged() {
    contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
    brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}


