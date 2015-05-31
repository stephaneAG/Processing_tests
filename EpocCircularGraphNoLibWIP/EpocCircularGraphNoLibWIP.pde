int numValues = 200;
float[] values = new float[numValues];

EpocCircularGraph chart;

void setup()
{
    size( 800, 800 );
    
    for ( int i = 0; i < numValues; i++ ) {
        values[i] = random( 100 );
    }
    
    chart = new EpocCircularGraph( values );
    
    noLoop();
}

void draw()
{
    background( 255 );
    smooth();
    translate( width/2, height/2);

    stroke( 0 );
    strokeWeight( 1.5 );
    strokeCap(SQUARE);
    
    chart.renderLines();
    
    saveFrame("images/circular-bar-chart-"+numValues+".png");
}






public class EpocCircularGraph implements PConstants {
	
	float _minRadius;
	float _maxRadius;
	float _angle;
	
	float[] _values;
	
	// Constructor
	EpocCircularGraph(float[] values){
		_minRadius = 320;
		_maxRadius = 380;
		_values = values;
		_angle = TWO_PI / float ( _values.length ); // _angle = TWO_PI / float( _values.length );
	}
	
	void renderLines(){
		for( int i = 0; i < _values.length; i++ ){
  
                        // change colors depending on 'range' of the value
                        if( _values[i] <= 50 ){
                            stroke(58, 94, 165);
                        } else if( _values[i] >= 50 && _values[i] < 80 ){
                            stroke(178, 56, 56);
                        } else {
                            stroke(206, 204, 204);
                        }
  
			float x1 = cos(i * _angle) * ( _minRadius / 2 );
                        float y1 = sin(i * _angle) * ( _minRadius / 2 );
                        
                        //float r = map(_values[i], 0, 100, _minRadius, _maxRadius);
                         float r = map(_values[i], 0, 100, _minRadius, _maxRadius);
                        
                        float x2 = cos( i * _angle ) * r;
                        float y2 = sin( i * _angle ) * r;
                        
                        line(x1, y1, x2, y2);
		}
	}
	
}
