/*
*
*    Java Microphone sound capture Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*/

// libs imports // ------ //
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import java.awt.*;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.TargetDataLine;

// class instances & vars  // ------ //

// setup // ------ //
void setup(){
    size(512, 200, P2D);
    smooth();
    
    // test the class
    
    MicrophoneRecorder mr = new MicrophoneRecorder(AudioUtil.getDefaultFormat() );
    mr.start();
    Thread.sleep(2000);
    mr.stop();
    
    
}
// draw // ------ //
void draw(){
    background(0);
}
// main fcns // ------ //


// other fcns // ------ //

// CLASSES // ------ //

// read data from the input channel & writes it to the output stream
public class MicrophoneRecorder implements Runnable {
  
    //record mike' and generates stream / byte array
    private AudioInputStream audioInputStream;
    private AudioFormat format;
    private TargetDataLine line;
    public Thread thread;
    public double duration;
    
    // constructor
    public MicrophoneRecorder(AudioFormat format){
        super(); // ?
        this.format = format;
    }
    
    public void start(){
        thread = new Thread(this);
        thread.setName("Capture");
        thread.start();
    }
    
    public void stop(){
        thread = null;
    }
    
    //@override // ?
    public void run(){
        duration = 0;
        line = getTargetDataLineForRecord();
        final ByteArrayOutputStream out = new ByteArrayOutputStream();
        final int frameSizeInBytes = format.getFrameSize(); // ?
        final int bufferLengthInFrames = line.getBufferSize() / 8; // ?
        final int bufferLengthInBytes = bufferLengthInFrames * frameSizeInBytes;
        
        final byte[] data = new byte[bufferLengthInBytes];
        
        int numBytesRead;
        
        line.start();
        
        while (thread != null){
            if ( (numBytesRead = line.read(data, 0, bufferLengthInBytes) ) == -1 ){
                break;
            }
            out.write(data, 0, numBytesRead);
        }
        
        // we reached the end of the stream, stop & close the line
        line.stop();
        line.close();
        line = null;
        
        // stop & close the output stream
        try {
            out.flush();
            out.close();
        } catch(IOException ex){
            ex.printStackTrace();
        }
        
        // load bytes into the audio input stream for playback
        final byte audioByte[] = out.toByteArray();
        final ByteArrayInputStream bais = new ByteArrayInputStream(audioByte);
        audioInputStream = new AudioInputStream( bais, format, audioByte.length / frameSizeInBytes);
        
        final long milliseconds = (long) ( ( audioInputStream.getFrameLength() * 1000 ) / format.getFrameRate() );
        
        duration = milliseconds / 1000.0;
        
        System.out.println(duration);
        
        try {
            audioInputStream.reset();
            System.out.println("resetting ...");
        } catch (IOException ex){
            ex.printStackTrace();
            return;
        }
        
    }
    
    private TargetDataLine getTargetDataLineForRecord(){
        TargetDataLine line;
        
        final DataLine.Info info = new DataLine.Info(TargetDataLine.class, format);
        if( !AudioSystem.isLineSupported(info) ){
            return null;
        }
        
        // get & open th target data line for capture
        try {
            line = (TargetDataLine) AudioSystem.getLine(info);
            line.open(format, line.getBufferSize() );
        } catch(final Exception ex){
            return null;
        }
        
        return line;
        
    }
    
    public AudioInputStream getAudioInputStream(){
        return audioInputStream;
    }
    
    public AudioFormat getFormat(){
        return format;
    }
    
    public void setFormat(AudioFormat format){
        this.format = format;
    }
    
    public Thread getThread(){
        return thread;
    }
    
    public double getDuration(){
        return duration;
    }
    
}
