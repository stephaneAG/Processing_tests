/*
*
*    Constraint movement Test Sketch 1
*    by STéphane Adam Garnier - 2012
*
*/


float mx, my; // used to position the circle

float easing = 0.05; // used to create 'intermediary steps' between the 'current mx/my' and the 'final mx/my)

int radius = 24; // radius of the circle
int edge = 100; // left-border/start of the rectangle
int inner = edge + radius; // simple formula

void setup(){
    size( 640, 360);
    noStroke();
    smooth();
    ellipseMode(RADIUS);
    rectMode(CORNERS);
}

void draw(){
    background(51);
    
    // Follow the mouse part (..)
    if( abs(mouseX - mx) > 0.1 ){ // if the distance between the 2 points is greater than 1 px (..)
        mx = mx + (mouseX - mx) * easing;
    }
    
    if( abs(mouseY - my) > 0.1 ){ // if the distance between the 2 points is greater than 1 px (..)
        my = my + (mouseY - my) * easing;
    }
    
    // Constrain movement part (..)
    mx = constrain(mx, inner, width-inner); // constraint x position (min X / max X)
    my = constrain(my, inner, height-inner); // constraint x position (min Y / max Y)
    
    // Draw stuff part (..)
    fill(76);
    rect(edge, edge, width- edge, height- edge); // draw the rect (..)
    
    fill(255);
    ellipse(mx, my, radius, radius);
    
}
