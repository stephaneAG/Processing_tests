/*
*
*    Circular Pie Chart Test Sketch
*    by Stéphane Adam Garnier - 2012
*/

float diameter;
int[] anglesValues = {30, 10, 47, 35, 60, 38, 75, 67};
float lastAngle = 0;

void setup(){
    size(640, 360);
    background(100);
    noStroke();
    smooth();
    diameter = min(width, height) * 0.75;
    noLoop();
}

void draw(){
    
    for( int i = 0; i < anglesValues.length; i++ ){
        fill(anglesValues[i] * 3.0);
        arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle + radians( anglesValues[i] ) );
        lastAngle += radians( anglesValues[i] );
    }
  
}
