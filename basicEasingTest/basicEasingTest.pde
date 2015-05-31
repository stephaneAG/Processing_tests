float x;
float y;
float easing = 0.05;

void setup(){
    size(640,360);
    noStroke();
    y = height/2;
    smooth();
}

void draw(){
    
    background(51);
    
    float targetX = mouseX; // newMousePosition is the target
    float distInBeX = targetX - x; // target positionX minus originX
    
    if( abs(distInBeX) > 1 ){ // if distance bigger than 1 px
        x += distInBeX * easing; // we steps the position animation
    }
    
    ellipse(x, y, 66, 66);
}
