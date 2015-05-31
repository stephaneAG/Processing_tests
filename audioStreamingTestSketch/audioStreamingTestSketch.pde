/*
*
*    Audio Streaming in Processing Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*/

// libs imports // ------ //
import ddf.minim.*; // Minim, the Pr audio lib
import hypermedia.net.*; // the hypermedia UDP lib

// class instances & vars  // ------ //
Minim minim;
AudioSample test;
//AudioSnippet test;

UDP udp;

// setup // ------ //
void setup(){
    size(512, 200, P2D);
    smooth();
    
    minim = new Minim(this);
    // load an mp3 file from the data folder
    test = minim.loadSample("test.mp3", 2048); // load it with a 2048 sample buffer using minim (to test it & play it directly)
    //test = minim.loadSnippet("test.mp3");
    
    udp = new UDP(this, 6000, "127.0.0.1");
    udp.listen(true);
    
    println("isMulticast? " + udp.isMulticast() );
    println("isJoined? " + udp.isJoined() );
    
}
// draw // ------ //
void draw(){
    background(44);
    
    text("on air", 20, 20);
}
// main fcns // ------ //
void sendSound(){
  
    ByteArrayOutputStream baoSt = new ByteArrayOutputStream();
    BufferedOutputStream boSt = new BufferedOutputStream(baoSt);
    
    // turn the sound to bytes
    //AudioInputStream aiSt = AudioSystem.getAudioInputStream(test);
    //byte[] soundData = new byte[aiSt.available()];
    //aiSt.read(SoundData);
    
    //melt those bytes as a byte array for the UDP datagram socket (he needs packets ;p )
    byte[] packet = baoSt.toByteArray();
    
    //send them over the socket
    println("Sending datagram with " + packet.length +" bytes");
    udp.send(packet);
    
}

void receive(byte[] data){
    
    println("Got datagram with " + data.length +" bytes of data");
    
    // read incoming data into a ByteArrayInputStream
    ByteArrayInputStream baiSt = new ByteArrayInputStream(data);
    InputStreamReader isr = new InputStreamReader(baiSt);
    
    //load sound from data > erase the old (playing ? should have finished) sample (?!)
    
  
}

// other fcns // ------ //
void keyPressed(){
    if(key == 'p'){
        //test.stop();
        //test.trigger(); // trigger the sound [> play it]
        //test.play();
    }
    if(key == 's'){
        // call a fcn that take the sound input, convert it as byte array and send it over udp
        sendSound();
    }
    
    
}

void stop(){
    test.close();
    minim.stop();
    super.stop();
}
