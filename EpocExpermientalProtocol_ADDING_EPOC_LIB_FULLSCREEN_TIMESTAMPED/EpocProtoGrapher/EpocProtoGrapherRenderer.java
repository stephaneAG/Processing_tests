package stephaneag.epocprotocomp;

import processing.core.*; // import the Processing 'core' .jar ( requires 'right-click > BUILD PATH --> ADD TO BUILD PATH' )

public class EpocProtoGrapherRenderer {
	// the headless Processing Applet to wich we will be drawing to
	private PApplet _prApplet = null;
	// the graphic context of the Pr Applet ( all drawings will be performed on this obj ( a PGraphic ) )
	private PGraphics _context = null;
	
	// the [blank] constructor
	EpocProtoGrapherRenderer(){
		// intentionally left blank (..)
	} // end constructor
	
	void initialise(int width, int height){
		// create a Processing Applet & retrieve its graphic context
		_prApplet = new PApplet();
		_context = _prApplet.createGraphics(width, height, PApplet.P3D);
		_prApplet.g = _context; // 'g' stands for 'GraphicContext'
	} // initialise
	
	// fcn that performs the drawing operations & save the results to an image
	void render(String filename){
		if( _prApplet == null || _context == null ){
			System.out.println("Error: EpocProtoGrapherRenderer::render() >> call 'initialise()' before 'render()' .");
			return;
		}
		
		// DRAWING OPERATIONS PART //
			
			// tell the context that we're starting to draw
			_context.beginDraw();
			
			// perform the drawing using normal Pr mthds
			_context.background(0);
			_context.noStroke();
			_context.beginShape();
				_context.vertex( 100, 100);
				_context.vertex( 300, 100);
				_context.fill(0);
				_context.vertex( 300, 300);
				_context.vertex( 100, 300);
			_context.endShape();
			
			// tell the conyexy that we're finished drawing
			_context.endDraw();
			
			// save the contents of the rendering context to a file
			_context.save(filename);
	} // render
} // class EpocProtoGrapherRenderer
