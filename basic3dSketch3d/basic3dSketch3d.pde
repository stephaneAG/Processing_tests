/*
*
*  Basic 3d test sketch ( basic 3d shape moving in 3d)
*  by Stephane Adam Garnier - 2012
*
*/

import processing.opengl.*; // import OpenGL (..) > only thing needed to use the OpenGL renderer

int rectZ = 20;
int rectSize = 100;
float rectRotZ = 0;
float rectRotX = 0;
float rectRotY = 0;

//lights params
float lightDirX = 0;
float lightDirY = 0;

void setup(){
   size( 200, 200, P3D); // use P3D as renderer(or OpenGL: " size( 200, 200, OPENGL); ")
   // nb: 'glitches' seems to appear when using 'P3D' (> like a triangle 'cut' in the midle of a basic rectangle roatating in 3d)   
   //frameRate(60);
   colorMode(RGB, 1);
   fill(0.4);
   smooth();
}

void draw(){
    background(51); // clear 'canvas' after each 'draw()' loop
    
    // mouse light
    float dirY = ( mouseY / float(height) - 0.5 ) * 2;
    float dirX = ( mouseX / float(width) - 0.5 ) * 2;
    // light specular for the following light
    lightSpecular( 1, 1, 1);
    //directionalLight( 204, 204, 204, -dirX, -dirY, -1);
    directionalLight( 0.8, 0.8, 0.8, 0, 0, -1);
    float s = mouseX / float(width);
    specular(s, s, s);
    
    pushMatrix();// ?
    //translate( (200/2 - rectWidth/2) , (200/2 - rectHeight/2) , rectZ); // translate in the middle of the screen (including rect W&H / 2) before drawing
    translate( (200/2) , (200/2) , rectZ);
    rotateZ(rectRotZ);
    rotateX(rectRotX);
    rotateY(rectRotY);
    rectMode(CENTER); // easier to set stg in some place (..)
    noStroke(); // prevent the glitch > but will need some light
    // 3d equivalent of saying 'rotate()' (>actually , saying "rotate around the Z axis")
    //rect(0, 0, rectWidth, rectHeight); // draw the rect
    box(rectSize);
    popMatrix();// ?
    //rectZ++; // move the rectangle forward the user
    rectRotZ += 0.005; // increase rectangle 's rotation
    rectRotX += 0.005;
    rectRotY += 0.005;
}
