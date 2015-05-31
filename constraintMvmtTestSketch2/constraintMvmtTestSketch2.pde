/*
*
*    Constraint movement Test Sketch 2 (one eye)
*    by Stéphane Adam Garnier - 2012
*
*/


float mx, my; // used to position the circle

float easing = 0.05; // used to create 'intermediary steps' between the 'current mx/my' and the 'final mx/my)

float esize = 12; // eye size
float ebounds = esize + 14; // eye bounds

int halfBounds =22;
int halfWidth, halfHeight;

void setup(){
    size( 500, 500);
    noStroke();
    smooth();
    //ellipseMode(CENTER_RADIUS);
    ellipseMode(RADIUS);
    
    halfWidth = width / 2;
    halfHeight = height / 2;
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
    
    // Calculate tuff part (..)
    float distance = esize * 2;
    
    // Constrain movement part (..)
    //mx = constrain(mx, 120, 155); // constraint x position (min X / max X)
    //my = constrain(my, 89, 115); // constraint x position (min Y / max Y)
    
    mx = constrain(mx, (halfWidth - halfBounds), (halfWidth + halfBounds) ); // constraint x position (min X / max X)
    my = constrain(my, (halfHeight - halfBounds), (halfHeight + halfBounds) ); // constraint x position (min Y / max Y)
    
    
    // Draw stuff part (..)
    fill(0);
    //ellipse(( 120 + (155 - 120) ), ( 89 + (115 - 89) ), esize * 2, esize * 2);
    //ellipse( (halfWidth - halfBounds), (halfHeight - halfBounds), ( halfBounds * 2 ), ( halfBounds * 2 ) );
    //rectMode(CORNER);
    //rect( (halfWidth - halfBounds), (halfHeight - halfBounds), ( halfBounds * 2 ), ( halfBounds * 2 ) ); // basic centered
    ellipseMode(CORNER);
    //ellipse( (halfWidth - halfBounds), (halfHeight - halfBounds), ( halfBounds * 2 ), ( halfBounds * 2 ) ); // basic centered
    //ellipse( (halfWidth - (halfBounds + esize ) ), (halfHeight - (halfBounds + esize ) ), ( (halfBounds + esize ) * 2 ), ( (halfBounds + esize ) * 2 ) );
    ellipse( (halfWidth - (halfBounds + ebounds ) ), (halfHeight - (halfBounds + ebounds ) ), ( (halfBounds + ebounds ) * 2 ), ( (halfBounds + ebounds ) * 2 ) );
    
    ellipseMode(RADIUS);
    fill(255);
    ellipse(mx, my, esize, esize);
    
}
