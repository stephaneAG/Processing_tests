public class TefClass
{
  private PApplet pa;
 
  // The constructor: same name as the the class, no return type
  public TefClass(PApplet papp, int otherParam)
  {
    pa = papp;
    // etc.
  }
 
  public void drawStuff(int someParam)
  {
    // Call PApplet's methods
    //pa.line( ... );
    pa.System.println("Hello World");
    // etc.
  }
}
