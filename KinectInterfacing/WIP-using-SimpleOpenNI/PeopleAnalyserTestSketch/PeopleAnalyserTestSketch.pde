/* StephaneAG */
//people analyser test sketch

import SimpleOpenNI.*;

SimpleOpenNI context;

void setup(){
  
  context = new SimpleOpenNI(this); //instanciates a new context
  
  context.enableDepth(); //enable depth image generation
  
  context.enableScene(); //enable scene analyser
  
  size ( context.depthWidth(), context.depthHeight() );
  
}

void draw(){
  
  context.update(); //update the camera
  
  image( context.sceneImage(), 0, 0); // draw SCENE image
  
  //ADVANCED USE : ACCESSING THE LABELLING DATA //
  //get a label map, 0 = no person, 0+n = n person
  int[] map = context.sceneMap();
  
  //set foundPerso to false at beginning of each frame
  boolean foundPerson = false;
  
  //go through all values in the array
  for ( int i = 0; i < map.length; i++ ){
    
    //if something in the foreground has been identifed
    if(map[i] > 0){ // at least one something ;p
    
      //change the flag to true
      foundPerson = true;
    }
    
  }
  
  //what do we do if we find someone ?
  if (foundPerson){
    println("Someone there ..... hello Dude ?");
    println("Subject position: " + map[1]);
  }
  
}

