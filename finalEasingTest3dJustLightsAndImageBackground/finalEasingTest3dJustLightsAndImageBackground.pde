/*
*
*  Basic 3d test sketch ( basic 3d shape moving in 3d)
*  by Stephane Adam Garnier - 2012
*
*/

import processing.opengl.*; // import OpenGL (..) > only thing needed to use the OpenGL renderer

// easing & position parameters
float x;
float y;
float easing = 0.05;

// 3d parameters
int rectSize = 120;

// scene background image
PImage backgroundImg;

void setup(){
    size(700, 550, OPENGL);
    noStroke();
    frameRate(60);
    stroke(250);
    strokeWeight(1);
    //y = height/2;
    smooth();
    backgroundImg = loadImage("fake3dbackground3.jpg");
}

void draw(){
    
    setupLights();
  
    //background(51); // dark grey background
    //background(230); // lighter
    background(backgroundImg); // apply the background image
    
    float targetX = mouseX; // newMousePosition is the target
    float distInBeX = targetX - x; // target positionX minus originX
    
    if( abs(distInBeX) > 1 ){ // if distance bigger than 1 px
        x += distInBeX * easing; // we steps the position animation
    }
    
    float targetY = mouseY; // newMousePosition is the target
    float distInBeY = targetY - y; // target positionX minus originX
    
    if( abs(distInBeY) > 1 ){ // if distance bigger than 1 px
        y += distInBeY * easing; // we steps the position animation
    }
    
    //fill(14);
    //ellipse(x, y, 66, 66); // rest of the previous test (..)
    
    // BOX IN 3D //
    pushMatrix();
    //translate( width/2, height/2, 0 ); // immuable, in the center of the screen
    translate( x, y, -(width/2) ); // > useful when using a 3d environment ( put the cube in the center of its environment in Z )
    //translate( x, y, 0 );
    rotateY(radians(55)); // show the cube at start like in Emotiv's app
    rotateX(radians(-8));
    rotateZ(radians(-5));
    //fill(165);
    noStroke();
    fill(235, 92, 30); // Emotiv like ?
    fill(47, 92, 166); // but mine will be blue! ^^
    fill(11, 193, 255); // controlP5 blue ;D
    rectMode(CENTER);
    box(rectSize);
    popMatrix();
    
    
    //fill(87);
    //ellipse(x- 43, y - 43, 33, 33); // rest of the previous test (..)
    
}

// temporary light on mousepress
void setupLights(){
    ambientLight(85, 85, 85);
    //directionalLight(200, 200, 200, 0.5, 0.5, -1);
    //directionalLight(85, 85, 85, 0, 0, -1);
    pointLight(200, 200, 200, width/2, height/2, 200);
}
