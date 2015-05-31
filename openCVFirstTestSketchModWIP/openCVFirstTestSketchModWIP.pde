/*
*
*    OpenCV first test sketch
*    by Stéphane Adam Garnier - 2102
*
*/


import hypermedia.video.*;
import java.awt.Rectangle;

float facePosX, facePosY;

OpenCV opencv;

void setup() {

    size( 320, 240 );

    opencv = new OpenCV(this);
    opencv.capture( width, height );
    opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );    // load the FRONTALFACE description file
}

void draw() {
    
    opencv.read();
    opencv.flip( OpenCV.FLIP_HORIZONTAL );
    //image( opencv.image(), 0, 0 );
    background(0); // necessary if we don't draw the image fro the webcam (..)
    
    // detect anything ressembling a FRONTALFACE
    //Rectangle[] faces = opencv.detect();
    Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );
    
    // draw detected face area(s)
    noFill();
    stroke(255,0,0);
    for( int i=0; i<faces.length; i++ ) {
        //rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height ); 
    }
    
    if (faces.length > 0){
        facePosX = faces[0].x + ( faces[0].width / 2 );
        facePosY = faces[0].y + ( faces[0].height / 2 );
        fill(200);
        noStroke();
        ellipseMode(RADIUS);
        ellipse( facePosX, facePosY, 10, 10);
        println("facePosX: " + facePosX);
        println("facePosY: " + facePosY);
        println("Face position X: " + map(facePosX, 0, width, 0, 150) + "/ 150" );
    }
}

// properly quit OpenCV when app quit (..)

public void stop(){
    opencv.stop();
    super.stop();
}
