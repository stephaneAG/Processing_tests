/*
*
*
*
*/


import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;

int def;

void setup(){
    size( 200, 200);
    cp5 = new ControlP5(this);
    //cp5.addSlider("test");
    
    cf = addControlFrame("extra");
    cp5.addSlider("test").plugTo(cf, "abc").setRange(0, 255); // will affect only the "extra" frame (actually, its background color ['int abc']) (..)
}

void draw(){
    
    background(def);  
  
}

ControlFrame addControlFrame(String theName){
    Frame f = new Frame(theName);
    ControlFrame p = new ControlFrame(this, 400, 400);
    f.add(p);
    p.init();
    f.setTitle(theName);
    //f.setSize(p.w, p,h);
    f.setSize(p.w, p.h);
    f.setLocation( 120, 120);
    f.setResizable(false);
    f.setVisible(true);
    return p;
}

public class ControlFrame extends PApplet{
    
    ControlP5 cp5;
    Object parent;
    
    int w, h;
    
    int abc;
    
    private ControlFrame(){
    }
    
    ControlFrame( Object theParent, int theWidth, int theHeight){
        parent = theParent;
        w = theWidth;
        h = theHeight;
    }
    
    public ControlP5 control(){
        return cp5;
    }
    
    public void setup(){
        size(w, h);
        frameRate(25);
        cp5 = new ControlP5(this);
        //cp5.addSlider("abc").plugTo(parent, "def").setRange(0, 255); // will affect itself as well as the parent (..)
        cp5.addSlider("abc").plugTo(parent, "abc").setRange(0, 255); // will affect only itself (..)
    }
    
    public void draw(){
        background(abc);
    }
  
}
