/* StephaneAG - 2012 */
//simple MIDI interfacing test sketch

import rwmidi.*;

MidiInput input;
MidiOutput output;

//further tests
String intputDeviceName;

//declaration of the PFont var
PFont font;
String message = "MIDI Interface Started";
float rotateAngle;

void setup(){
  
    //visual setup
    size(600,200);
    background(0);
    frameRate(60);
    
    //loading of the font
    font = loadFont("ArialMT-16.vlw");
    textFont(font,20); // specify wich font to be used
    fill(255); // specify font fill color
  
    //input = RWMidi.getInputDevices()[0].createInput(this); // ORIGINAL, WORKING
    input = RWMidi.getInputDevices()[0].createInput(this);
    output = RWMidi.getOutputDevices()[0].createOutput();
    // try a plug
    //input.plug(this, "notOnMyWay"); // works, but not yet needed
    
    //get&print all list of the output/input devices
    println("Input devices:");
    println();
    
    String[] inputDevices = RWMidi.getInputDeviceNames();
    int inLen = inputDevices.length;
    for (int i = 0; i < inLen; i++){
      println(inputDevices[i]);
    }
    println("\n");
    
    println("Output devices:");
    println();
    
    String[] outputDevices = RWMidi.getOutputDeviceNames();
    int outLen = outputDevices.length;
    for (int i = 0; i < outLen; i++){
      println(outputDevices[i]);
    }
    println("\n");
    
    
    // get&print currently used device
    intputDeviceName = input.getName();
    println("CURRENT INTPUT DEVICE: "+ intputDeviceName);
    
     println("\n");
     
     

}

//a key has been hit 
void noteOnReceived(Note note){
    //println("NOTE ON > note keycode: " + note.getPitch() ); // returns the pitch of the note (from 21 to 108 on my M-audio KeyStation 88es)
    //println("NOTE ON > note velocity: "+ note.getVelocity() ); // return the velocity of the note
    
    //getting the note corresponding to that keycode
    //getNoteFromKeyCode(note.getPitch() ); // now using fct below to use it
    //getting the status of the key in order to choose whether or not to use the above function (to get the note corresponding to a keyCode)
    //getCurrentKeyStatus(note.getPitch());
    
    // EVEN SIMPLER/SMARTER (!) [> i may have thought about it before ! ]
    // > the velocity, during a keypress relase, is 0. So by testing if the velocity number is different from 0, we can now if the key is release or pressed ;D
    // >>as far as i can see, min velocity in 1 and max in 127 for my keyboard()
    if (note.getVelocity() == 0){
      //println("velocity equals 0: this is a key release");
        println(".. key release ..");
    } else {
      //println("velocity is greater than 0: this is a key press");
      getNoteFromKeyCode(note.getPitch() );
      println(" was pressed, with " + note.getVelocity()  + "/127 velocity");
    }
}

//a note has finshed to being hit (! :| )
void noteOffReceived(Note note){
  println("NOTE OFF > not: " + note.getPitch() );
  println("NOTE OFF > note velocity: "+ note.getVelocity() );
}


//impl&test of other fcts
void programChangeReceived(rwmidi.ProgramChange pc){
  println("program change received");
  println("program change number of message: " + pc.getNumber() );
  println();
}

void controllerChangeReceived(rwmidi.Controller cntrl){
  println("controller change received");
  //println("CC number of message: " + cntrl.getCC() );
  //get controller type from CCNumber
  getControllerTypeFromMessageCCNumber( cntrl.getCC() );
  
  println("value of the CC message: " + cntrl.getValue() );
  
  println();
}


void sysexReceived(rwmidi.SysexMessage msg){
    println("sysex " + msg.getMessage());
}

void mousePressed(){
  int ret = output.sendNoteOn(0, 3, 3);
  ret = output.sendSysex(new byte[] {(byte)0xF0, 1, 2, 3, 4, (byte)0xF7});
}

void draw(){
    
    background(0);
    translate(width/2, height/2);
    textAlign(CENTER);
    text(message, 0,0); //display base text
    rotate(rotateAngle);
    
    rotateAngle += 0.5;
    
}




// ADVANCED / PERSONAL FCTS //

//notOnMyWay //Nb: works as "noteOnReceived" (> thus exectued from the same events (key press&release))
public void notOnMyWay(Note note){
  int vel = note.getVelocity();
  println("note velocity: " + vel );
}

//tell me wich controller has performed the change
void getControllerTypeFromMessageCCNumber(int ccNumber){
  if (ccNumber == 7){
      println("Controller type: Volume");
  } else if (ccNumber == 1){
      println("Controller type: Modulation");
  }
}


//tell me the note that corresponds to that keycode
void getNoteFromKeyCode(int noteKeyCode){
    if (noteKeyCode == 21){
        println("A-1 | LA");
        message = "A-1 | LA";
    } else if (noteKeyCode == 22){
        println("A-1# / B-1b | LA# / SIb ");
        
    } else if (noteKeyCode == 23){
        println("B1 | SI");
    
    } else if (noteKeyCode == 24){
        println("C0 | DO");
    
    } else if (noteKeyCode == 25){
        println("C0# / D0b | DO# / RÉb ");
    
    } else if (noteKeyCode == 26){
        println("D0 | RÉ");
    
    } else if (noteKeyCode == 27){
        println("D0# / E0b | RÉ# / MIb");
    
    } else if (noteKeyCode == 28){
        println("E0 | MI");
    
    } else if (noteKeyCode == 29){
        println("F0 | FA");
    
    } else if (noteKeyCode == 30){
        println("F0# / G0b | FA# / SOLb");
    
    } else if (noteKeyCode == 31){
        println("G0 | SOL");
    
    } else if (noteKeyCode == 32){
        println("G0# /A0b | SOL# / LAb");
    
    } else if (noteKeyCode == 33){
        println("A0 | LA");
    
    } else if (noteKeyCode == 34){
        println("A0# / B0b | LA# / SIb");
    
    } else if (noteKeyCode == 35){
        println("B0 | SI");
    
    } else if (noteKeyCode == 36){
        println("C1 | DO");
    
    } else if (noteKeyCode == 37){
        println("C1# / D1b | DO# / RÉb");
    
    } else if (noteKeyCode == 38){
        println("D1 | RÉ");
    
    } else if (noteKeyCode == 39){
        println("D1# / E1b | RÉ# / MI");
    
    } else if (noteKeyCode == 40){
        println("E1 | MI");
    
    } else if (noteKeyCode == 41){
        println("F1 | FA");
    
    } else if (noteKeyCode == 42){
        println("F1# / G1b | FA# / SOLb");
    
    } else if (noteKeyCode == 43){
        println("G1 | SOL");
    
    } else if (noteKeyCode == 44){
        println("G1# / A1b | SOL# / LAb");
    
    } else if (noteKeyCode == 45){
        println("A1 | LA");
    
    } else if (noteKeyCode == 46){
        println("A1# / B1b | LA# / SIb");
    
    } else if (noteKeyCode == 47){
        println("B1 | SI");
    
    } else if (noteKeyCode == 48){
        println("C2 | DO");
    
    } else if (noteKeyCode == 49){
        println("C2# / D2b | DO# / RÉb");
    
    } else if (noteKeyCode == 50){
        println("D2 | RÉ");
    
    } else if (noteKeyCode == 51){
        println("D2# / E2b | RÉ# / MI");
    
    } else if (noteKeyCode == 52){
        println("E2 | MI");
    
    } else if (noteKeyCode == 53){
        println("F2 | FA");
    
    } else if (noteKeyCode == 54){
        println("F2# / G2b | FA# / SOLb");
    
    } else if (noteKeyCode == 55){
        println("G2 | SOL");
    
    } else if (noteKeyCode == 56){
        println("G2# / A2b | SOL# / LAb");
    
    } else if (noteKeyCode == 57){
        println("A2 | LA");
    
    } else if (noteKeyCode == 58){
        println("A2# / B2b | LA# / SIb");
    
    } else if (noteKeyCode == 59){
        println("B2 | SI");
    
    } else if (noteKeyCode == 60){
        println("C3 | DO");
    
    } else if (noteKeyCode == 61){
        println("C31 / D3b | DO# / RÉb");
    
    } else if (noteKeyCode == 62){
        println("D3 | RÉ");
    
    } else if (noteKeyCode == 63){
        println("D3# / E3b | RÉ# / MIb");
    
    } else if (noteKeyCode == 64){
        println("E3 | MI");
    
    } else if (noteKeyCode == 65){
        println("F3 | FA");
    
    } else if (noteKeyCode == 66){
        println("F3# / G3b | FA# / SOLb");
    
    } else if (noteKeyCode == 67){
        println("G3 | SOL");
    
    } else if (noteKeyCode == 68){
        println("G3# / A3b | SOL# / LAb");
    
    } else if (noteKeyCode == 69){
        println("A3 | LA");
    
    } else if (noteKeyCode == 70){
        println("A3# / B3b | LA# / SIb");
    
    } else if (noteKeyCode == 71){
        println("B3 | SI");
    
    } else if (noteKeyCode == 72){
        println("C4 | DO");
    
    } else if (noteKeyCode == 73){
        println("C4# / D4b | DO# / RÉb");
    
    } else if (noteKeyCode == 74){
        println("D4 | RÉ");
    
    } else if (noteKeyCode == 75){
        println("D4# / E4b | RÉ# / MIb");
    
    } else if (noteKeyCode == 76){
        println("E4 | MI");
    
    } else if (noteKeyCode == 77){
        println("F4 | FA");
    
    } else if (noteKeyCode == 78){
       println("F4# / G4b | FA# / SOLb");
    
    } else if (noteKeyCode == 79){
        println("G4 | SOL");
    
    } else if (noteKeyCode == 80){
        println("G4# / A4b | SOL# / LAb");
    
    } else if (noteKeyCode == 81){
        println("A4 | LA");
    
    } else if (noteKeyCode == 82){
      println("A4# / B4b | LA# / SIb");
    
    } else if (noteKeyCode == 83){
        println("B4 | SI");
    
    } else if (noteKeyCode == 84){
        println("C5 | DO");
    
    } else if (noteKeyCode == 85){
        println("C5# / D5b | DO# / RÉb");
    
    } else if (noteKeyCode == 86){
        println("D5 | RÉ");
    
    } else if (noteKeyCode == 87){
        println("D5# / E5b | RÉ# / MIb");
    
    } else if (noteKeyCode == 88){
        println("E5 | MI");
    
    } else if (noteKeyCode == 89){
        println("F5 | FA");
    
    } else if (noteKeyCode == 90){
        println("F5# / G5b | FA# / SOLb");
    
    } else if (noteKeyCode == 91){
        println("G5 | SOL");
    
    } else if (noteKeyCode == 92){
        println("G5# / A5b | SOL# / LAb");
    
    } else if (noteKeyCode == 93){
        println("A5 | LA");
    
    } else if (noteKeyCode == 94){
        println("A5# / B5b | LA# / SIb");
    
    } else if (noteKeyCode == 95){
        println("B5 | SI");
    
    } else if (noteKeyCode == 96){
        println("C6 | DO");
    
    } else if (noteKeyCode == 97){
        println("C6# / D6b | DO# / RÉb");
    
    } else if (noteKeyCode == 98){
        println("D6 | RÉ");
    
    } else if (noteKeyCode == 99){
        println("D6# / E6b | RÉ# / MIb");
    
    } else if (noteKeyCode == 100){
        println("E6 | MI");
    
    } else if (noteKeyCode == 101){
        println("F6 | FA");
    
    } else if (noteKeyCode == 102){
        println("F6# / G6b | FA# / SOLb");
    
    } else if (noteKeyCode == 103){
        println("G6 | SOLb");
    
    } else if (noteKeyCode == 104){
        println("G6# / A6b | SOL# / LAb");
    
    } else if (noteKeyCode == 105){
        println("A6 | LA");
    
    } else if (noteKeyCode == 106){
        println("A6# / B6b | LA# / SIb");
    
    } else if (noteKeyCode == 107){
        println("B6 | SI");
    
    } else if (noteKeyCode == 108){
        println("C7 | DO");
    
    } else {
        println("unknown note ?!");
    }
    
    //little WIP test
    //rotateAngle += 0.5 * noteKeyCode;
    rotate(noteKeyCode);

}
