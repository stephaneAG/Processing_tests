/*
*
*    Text around a circle Other Way Digits Test Sketch
*    by Stéphane Adam Garnier - 2012
*/

PFont font;

String[] names = {"The          ",
                  "          future",
                  "has          ",
                  "          to",
                  "be          ",
                  "          done."
                  };

float delta = TWO_PI / names.length;
int radius = names.length * 10;

float i0 = 0.0;
float d0 = 0.0;

void setup(){
    size( 400, 400);
    smooth();
    font = createFont("CourrierNewPSMT", 10);
    textFont(font, 14);
}

void draw(){
    background(0);
    fill(255);
    
    d0 += 0.10;
    i0 += 0.036;
    for( int i = 0; i < names.length; i++ ){
        float xPos = width/2 + radius * cos(0.7 * i0 + i * delta );
        float yPos = height/2 + radius * sin(0.7 * i0 + i * delta );
        
        pushMatrix();
            translate( xPos, yPos);
            rotate( d0 + delta * i );
            text( names[i], 0, 0 );
        popMatrix();
    }
}

