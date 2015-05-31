/**
*	EpocProtoGrapher v1a
*	Class & Project by Stéphane Adam Garnier - 2012
*
*/

/**
 * 
 *	This file /class is a 'main' designed to be consumed by the command line
 *	It uses the 'EpocProtoGrapherRenderer' class to handle the drawings using Processing (..)
 * 
 */
package stephaneag.epocprotocomp;

public class EpocProtoGrapher {
	public static void main(String args[]){
		
		// -- // BASIC SETUP // -- //
			
			// create an 'EpocProtoGrapherRenderer' object
			EpocProtoGrapherRenderer epgr = new EpocProtoGrapherRenderer(); // final one will take params (..)
			// initialise it & passing the width & height of the output image
			epgr.initialise( 400, 400);
			// actually render out to a file
			epgr.render("test.png");
		
	}
} // class EpocProtoGrapher
