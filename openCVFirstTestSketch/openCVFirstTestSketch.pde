/*
*
*    OpenCV first test sketch
*    by Stéphane Adam Garnier - 2102
*
*/


import hypermedia.video.*;
import java.awt.Rectangle;

OpenCV opencv;

void setup() {

    size( 320, 240 );

    opencv = new OpenCV(this);
    opencv.capture( width, height );
    opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );    // load the FRONTALFACE description file
}

void draw() {
    
    opencv.read();
    image( opencv.image(), 0, 0 );
    
    // detect anything ressembling a FRONTALFACE
    Rectangle[] faces = opencv.detect();
    
    // draw detected face area(s)
    noFill();
    stroke(255,0,0);
    for( int i=0; i<faces.length; i++ ) {
        rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height ); 
    }
}
