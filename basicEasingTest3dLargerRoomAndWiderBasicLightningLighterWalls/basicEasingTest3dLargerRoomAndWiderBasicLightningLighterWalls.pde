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

// 3d walls
int wallWidth; // = 500;
int wallHeight; // = 500;
int wideSpacer = 100;

void setup(){
    size(700, 550, OPENGL);
    noStroke();
    stroke(250);
    strokeWeight(1);
    //y = height/2;
    wallWidth = width;
    wallHeight = height;
    smooth();
}

void draw(){
    
    setupLights();
  
    //background(51); dark grey background
    background(230); // lighter
    
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
    translate( x, y, -(width/2) );
    rotateY(radians(55)); // show the cube at start like in Emotiv's app
    rotateX(radians(-8));
    rotateZ(radians(-5));
    fill(165);
    rectMode(CENTER);
    box(rectSize);
    popMatrix();
    
    
    //fill(87);
    //ellipse(x- 43, y - 43, 33, 33); // rest of the previous test (..)
    
    // ENVIRONMENT BUILDING //
    noStroke();
    // build the background
    pushMatrix();
    translate(width/2, height/2, -width ); // go to top-left corner of the screen
    //fill(240); // little lighter than the walls
    fill(20);
    rectMode(CENTER);
    //rotateY(165); // nearly good
    //rotateY(45);
    rect(0, 0, (width/2 + wideSpacer), height/2);
    popMatrix();
    
    // WALLS BUIDLING //
    // wall 1
    pushMatrix();
    //translate(-30, 0, 0); // go to top-left corner of the screen
    translate(-wideSpacer, 0, 0);
    //fill(245, 30, 45); // vivid red ;D
    fill(255);
    rectMode(CORNER);
    //rotateY(165); // nearly good
    rotateY(radians(90));
    rect(0, 0, (width * 3), wallHeight );
    popMatrix();
    
    // wall2
    pushMatrix();
    //translate(-30, 0, 0); // go to top-left corner of the screen
    translate(width+wideSpacer, 0, -(width * 3) );
    rectMode(CORNER);
    //rotateY(165); // nearly good
    rotateY(radians(-90));
    rect(0, 0, (width * 3), wallHeight );
    popMatrix();
    
    // roof
    pushMatrix();
    //translate(-30, 0, 0); // go to top-left corner of the screen
    translate(-wideSpacer, 0, 0);
    //fill(245, 30, 45); // vivid red ;D
    fill(255);
    rectMode(CORNER);
    //rotateY(165); // nearly good
    rotateY(radians(90));
    rotateX(radians(90));
    rect(0, 0, (width * 3), wallHeight*2 ); //wallHeight );
    popMatrix();
    
}

// temporary light on mousepress
void setupLights(){
    ambientLight(85, 85, 85);
    //directionalLight(200, 200, 200, 0.5, 0.5, -1);
    directionalLight(85, 85, 85, 0, 0, -1);
    pointLight(200, 200, 200, (width+wideSpacer)/2, height/2, 200);
}
