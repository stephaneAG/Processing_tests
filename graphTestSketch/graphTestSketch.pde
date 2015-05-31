/*
*
*    First test of 'graph' visualisation possibilities of processing (..)
*    by Stephane Adam Garnier - 2012
*
*/

float[] values;

void setup(){
    
    size(400, 200);
    smooth();
    
    //an array filled with random values
    values = new float[width];
    for(int i = 0; i < values.length; i++){
        values[i] = random(height);
    }
  
}

void draw(){
    
    background(255);
    
    //draw lines connecting all points
    for(int i = 0; i < values.length; i++){
        stroke(0);
        strokeWeight(2);
        //line(i, values[i], i+1, values[i+1]);
        //println(i + " = " + values[i] + " | " + (i+1) + " = " + values[i+1]);
        if ( i+1 < values.length){
            //line(i, values[i], i+1, values[i+1]); // seems to work
            //point(i, values[i]); // points ?
            //line(i, 0, i+1, values[i]); // seems to work, different render (like this one ;D)
            
            //line(i, 0, i, values[i]); // even nicer ;l)
            
            //line(i, 0, i, values[i]); // interesting
            //line(i, values[i], i, values[i+1]);
            
            //line(i, 0, i, (values[i] - 1) ); // othe experiment
            //stroke(255);
            //line(i, height, i, (values[i] + 1) );
            //stroke(0);
            
            //line(i, (height/2 - 15 ), i, (height/2 + 15) ); // basic principle (should be ,nb ;p)
            //line(i, (height/2 - map(values[i], 0, height, 0, height/2) ), i, (height/2 + map(values[i], 0, height, 0, height/2) ) ); // basic 'spectrum-like'
            
            strokeWeight(1);
            line(i, (height/2 - map(values[i], 0, height, 0, (height/2 - 15) ) ), i, (height/2 + map(values[i], 0, height, 0, (height/2 - 15 ) ) ) ); // even nicer ? ;D
        }
        
    }
    
    //slide everything down in the array
    for(int i = 0; i < values.length-1; i++){
        values[i] = values[i+1];
    }
    
    //add a new random value to the array
    values[values.length-1] = random(height);
  
}
