/*
*
*    ByteArrayStreams Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*/

// libs imports // ------ //
import java.io.*;
import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

// class instances & vars  // ------ //

// setup // ------ //
void setup(){
    size(512, 200, P2D);
    smooth();
    
    
    writeContentToFile(); // works
    readContentFromFile(); // ' " 2 + U' ?
    
    
    // fill a byteArrayOutputStream with content from file / buffer
    
    
    // fill a byteArrayInputStream with content from byteArray (byte[])
    
}
// draw // ------ //
void draw(){
    background(0);
}
// main fcns // ------ //
void writeContentToFile(){
  
  try{
        
        // get file /or/ buffer /or/ stuff ?
        String theFakeData = "Hy there, I am fake data! And I fucking like it.";
        
    //byte[] fileBytesArray = {11, 34, 50, 43, 85};
    byte[] fileBytesArray = theFakeData.getBytes();
    OutputStream oSt = new FileOutputStream("testOutputStream.txt");
    for(int i = 0; i < fileBytesArray.length; i++){
        oSt.write(fileBytesArray[i]); // write the bytes to the buffer
    }
    oSt.close();
    
    } catch(IOException e){
        e.printStackTrace();
    }
    
}

void readContentFromFile(){
  
  try{
        
        //get file content
    InputStream iSt = new FileInputStream("testOutputStream.txt");
    int iStCoSize = iSt.available();
    
    //DEBUG > print content to console
    for (int i = 0; i < iStCoSize; i++){
        System.out.println("Char read: " + (char) iSt.read() + "  " );
    }
    iSt.close();
    
    } catch(IOException e){
        e.printStackTrace();
    }
    
}

// other fcns // ------ //
