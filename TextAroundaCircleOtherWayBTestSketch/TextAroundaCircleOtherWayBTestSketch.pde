/*
*
*    Text around a circle Other Way B Test Sketch
*    by Stéphane Adam Garnier - 2012
*/

PFont font;

String[] names = {"TEF", "tuf", "thom", "quatre", "cinq", "six", "sept", "hui", "neuf" };

float delta = TWO_PI / names.length;
int radius = names.length * 10;

float i0 = 0.0;

void setup(){
    size( 400, 400);
    smooth();
    font = createFont("CourrierNewPSMT", 10);
    textFont(font, 10);
}

void draw(){
    background(0);
    fill(255);
    
    i0 += 0.1;
    
    for( int i = 0; i < names.length; i++ ){
        float xPos = width/2 + radius * cos( i * delta );
        float yPos = height/2 + radius * sin( i * delta );
        
        pushMatrix();
            translate( xPos, yPos);
            rotate( i0 + delta * i );
            text( names[i], 0, 0 );
        popMatrix();
    }
}

