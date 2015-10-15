package states.don.ui;

import mint.Control;
import mint.Control.ControlOptions;

typedef TileSelectorControlOptions = {
	> ControlOptions,
	path:String
};

/**
 * ...
 * @author Carmon
 */
@:allow(mint.render.Renderer)
class TileSelectorControl extends Control
{
	public var options:TileSelectorControlOptions;
	
	public function new(_options:TileSelectorControlOptions) 
	{
		options = _options;
		
		super(_options);
		
        renderer = rendering.get( TileSelectorControl, this );
		
		trace('new::: ' + renderer);
		
		oncreate.emit();
	}
}