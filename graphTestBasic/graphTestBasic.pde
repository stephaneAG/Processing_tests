/*
*
*    test of 'graph' visualisation possibilities of processing (..)
*    by Stephane Adam Garnier - 2012
*
*/

float[] values;

void setup(){
    
    size(200, 120);
    smooth();
    
    //an array filled with random values
    values = new float[width];
    for(int i = 0; i < values.length; i++){
        values[i] = random(height);
    }
  
}

void draw(){
    
    background(255);
    
    for(int i = 0; i < values.length; i++){
        stroke(0);
        strokeWeight(2);
        
        if ( i+1 < values.length){
            //line(i, values[i], i+1, values[i+1]);
            point(i, values[i]);
        }
        
    }
  
}
