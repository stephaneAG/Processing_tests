/*
*
*    Java Sound API Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*/

// libs imports // ------ //
import java.awt.*;
import java.io.*;
import javax.sound.sampled.*;

// class instances & vars  // ------ //
byte[] bytesRecorded;

// setup // ------ //
void setup(){
    size(512, 200, P2D);
    smooth();
    
    getMixerInfos();
    
    recordAudio();
    playbackAudio();
    
}
// draw // ------ //
void draw(){
    background(0);
}
// main fcns // ------ //
void recordAudio(){
    
    // 1 > create an audio format
    float sampleRate = 8000;
    int sampleSizeInBits = 8;
    int channels = 1;
    boolean signed = true;
    boolean bigEndian = true;
    AudioFormat format = new AudioFormat(sampleRate, sampleSizeInBits, channels, signed, bigEndian);
    
    // 2 > get a DataLine
    DataLine.Info info = new DataLine.Info(TargetDataLine.class, format);
    //TargetDataLine line = (TargetDataLine) AudioSystem.getLine(info); // throws a 'LineUnavailableException'
    //TargetDataLine line = AudioSystem.getTargetDataLine(format); // should get OS's default
    TargetDataLine line;
    
    if( !AudioSystem.isLineSupported(info) ){
        // handle error ...
        System.out.println("Audio System Line is not supported..");
    }
   
   try{
       //line = (TargetDataLine) AudioSystem.getLine(info); // simple version
       line = (TargetDataLine) AudioSystem.getLine(info);
       // 3 > as we now have an input source for the audio, we just need to open it & start it
       line.open(format);
       line.start();
       
       // 4 > our data line is now ready, so we can start recording
         // we 'll save the captue audio stream to a byte array for later playing
         // Remember to stop the line OUTSIDE of the read-loop construct (..)
   int bufferSize = (int) format.getSampleRate() * format.getFrameSize();
   byte buffer[] = new byte[bufferSize];
   ByteArrayOutputStream out = new ByteArrayOutputStream();
   //actually read from line & write to bytearray
   int count = line.read(buffer, 0, buffer.length);
   if( count > 0 ){
       out.write(buffer, 0, count);
   }
   
   // WIP/debug > capture for some time an not just 1 'draw()' loop duration (..)
   //delay(1000);
   
   out.close();
   
   // 5 > write the content of the ByteArrayOutputStream to the local (> sketch's) byteArray 'bytesRecorded'
   bytesRecorded = out.toByteArray();
   System.out.println("Recording finished, wrote " + bytesRecorded.length + " bytes to the byteArray 'bytesRecorded'.");
   System.out.println("bytesRecorded content looks like this: " + (String)(bytesRecorded + " ") );
       
   }catch(LineUnavailableException e){
       e.printStackTrace();
   }catch(IOException ioe){
       ioe.printStackTrace();
   }
   
   
   
}

void playbackAudio(){
  
    // REDUNDANT //
    // 0 > create an audio format
    float sampleRate = 8000;
    int sampleSizeInBits = 8;
    int channels = 1;
    boolean signed = true;
    boolean bigEndian = true;
    AudioFormat format = new AudioFormat(sampleRate, sampleSizeInBits, channels, signed, bigEndian);
    
    // 1 > create an AudioInputStream from the byteArray containing previous recording
    byte[] audioBytes = bytesRecorded; // should work ?
    InputStream input = new ByteArrayInputStream(audioBytes);
    AudioInputStream ais = new AudioInputStream( input, format, audioBytes.length / format.getFrameSize() );
    
    // 2 > fetch a 'SourceDataLine'
    DataLine.Info info = new DataLine.Info(SourceDataLine.class, format);
    SourceDataLine line;
    
    
    try{
        line = (SourceDataLine) AudioSystem.getLine(info);
        // 3 > we now need to open it & start it
        line.open(format);
        line.start();
        
        // 4 > our data line is now ready, so we can start playing
        int bufferSize = (int) format.getSampleRate() * format.getFrameSize();
        byte buffer[] = new byte[bufferSize];
        
        int count;
        while( (count = ais.read(buffer, 0, buffer.length) ) != -1 ){
            if( count > 0 ){
                line.write(buffer, 0, count);
            }
        }
        
        line.drain(); // nearly like 'flush()'
        line.close();
        
       
   }catch(LineUnavailableException e){
       e.printStackTrace();
   }catch(IOException ioe){
       ioe.printStackTrace();
   }
  
}
// other fcns // ------ //

void getMixerInfos(){
    
    try{
        Mixer.Info[] mixerInfos = AudioSystem.getMixerInfo();
    for( Mixer.Info info : mixerInfos ){
        Mixer m = AudioSystem.getMixer(info);
        Line.Info[] lineInfos = m.getSourceLineInfo();
        for( Line.Info lineInfo:lineInfos ){
            System.out.println(info.getName() + "---" + lineInfo);
            Line line = m.getLine(lineInfo);
            System.out.println("\t-----" + line);
        }
        lineInfos = m.getTargetLineInfo();
        for( Line.Info lineInfo:lineInfos ){
            System.out.println(m+ "---" + lineInfo);
            Line line = m.getLine(lineInfo);
            System.out.println("\t-----"+ line);
        }
    }
    }catch(LineUnavailableException lue){
        lue.printStackTrace();
    }
  
}
