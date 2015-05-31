/* StephaneAG */
//skeleton tracking test sketch

import SimpleOpenNI.*;

SimpleOpenNI context;

void setup(){
  
  context = new SimpleOpenNI(this); //instanciates a new context
  
  context.enableDepth(); //enable depth image generation
  
  // SKELETON TRACKING NEEDS //
  //enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  //for the skeleton drawing
  background(200, 0, 0);
  stroke(0, 0, 255);
  strokeWeight(3);
  smooth();
  
  size ( context.depthWidth(), context.depthHeight() );
  
}

void draw(){
  
  context.update(); //update the camera
  
  image( context.depthImage(), 0, 0); // draw depth image
  
  // SKELETON TRACKING NEEDS //
  //check if a skeleton is being tracked for all users 1 to 10
  int i;
  for (i = 1; i <= 10; i++){
    
      //check if the skeleton is being tracked
      if(context.isTrackingSkeleton(i)){
          
          //code called anytime a skeleton is being tracked
            //this is where we draw the lines between the joints ( see drawSkeleton fct)
          
            //draw skeleton for user i
            drawSkeleton(i);  
            
            //draw a circle for the head // > JOINTS POSITION IN 3D SPACE FCT (nb)
            circleForAHead(i);
        
      }
    
  }
  
}

// FUNCTIONS //

//drawSkeleton fct
  //draw the skeleton with the selected joints
void drawSkeleton(int userId){
    
    // as a test, draw a skeleton joints (> 'd be funny to "voluntary-mislink" them ;p ... funny&weird ;D ! .. )
    context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 
    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 
    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 
    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 
    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  
  
}


// SKELETON TRACKING EVENTS BASED MTHDS//
  //several fct are necessary for skeletn tracking
  
//Detecting New users & Losing Users
  //mthd called when a person 'user' enters or leaves the field of view
void onNewUser(int userId){
    println("New user detected with ID:" + userId);
    
    //start pose detection
    context.startPoseDetection("Psi", userId);
}

  //mthd called when a person 'user' leaves the field of view
void onLostUser(int userId){
    println("User with ID: " + userId + " lost");
}


//Detecting when a user starts a calibration pose
  //when a user begins a pose
void onStartPose(String pose, int userId){
    println("User with ID: " + userId + "started a pose: " + pose);
    
    //stop pose detection
    context.stopPoseDetection(userId);
    
    //start attempting to calibrate the skeleton
    context.requestCalibrationSkeleton(userId, true); // request to recognise the jointd position on the user
}


//Starting and Ending the calibration process
  //finally, the fct called when the skeleton calibration process begins and ends

  //when calibration begins
  void onStartCalibration(int userId){
      println("Beginning calibration of user with ID: " + userId);
  }
  
  //when calibration ends, successfully or unsuccessfully
  void onEndCalibration(int userId, boolean successfull){
      println("Calibration of user with ID:" + userId + ",successfull: " + successfull);
      
      if (successfull){
          println("User calibrated !");
          
          //calibration successfull, beginning skeleton tracking
          context.startTrackingSkeleton(userId);
      }
      else {
          println("Failed to calibrate user !");
          
          //calibration unsuccessfull, restrating pose detection
          context.startPoseDetection("Psi", userId);
      }

      
  }
  
// JOINTS POSITIONS IN 3D SPACE FCTS //

//fct retrieving the position of the head and drawing circle there
void circleForAHead(int userId){
    
    //get the 3d position of a joint
    PVector jointPos = new PVector(); // create a PVector for joint coords
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPos); // get joint position from OpenNI skeleton part and store it in jointPos
    
    //print out x/y/z position of the head...
    println(jointPos.x);
    println(jointPos.y);
    println(jointPos.z);
    // ... wich is in milimeters and corresponds to the real world
    // > we want our value to be in pixels to corresponds to the projective world on our screen
    
    //convert a real world point to projective space
    PVector jointPos_Proj = new PVector(); // we create another PVector to hold the ppoints' projective world coords
    context.convertRealWorldToProjective(jointPos, jointPos_Proj); // convert real world coords to projective ones
    
    // ACTUALLY DRAW A CIRCLE FOR HEAD //
    
    /* basic: still size circle as head */
//    float headSize = 200; // a 200 px diameter head
//    fill(0,240,0); // set the fill color to fill the circle with desired color
//    ellipse(jointPos_Proj.x, jointPos_Proj.y, headSize, headSize); 
    
    /* imitationg the "perspective projection" (effecti we will aprocimate here using distance-dependent scaling) */
    float headSize = 200; // a 200 px diameter head
    float scalarDistance = (525/jointPos_Proj.z);
    fill(0,240,0); // set the fill color to fill the circle with desired color
    ellipse(jointPos_Proj.x, jointPos_Proj.y, scalarDistance * headSize, scalarDistance * headSize);
    
}

