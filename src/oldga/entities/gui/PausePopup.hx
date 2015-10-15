package entities.gui;

import components.gui.input.KeyboardInput;
import luxe.Color;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Text;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class PausePopup extends Sprite
{
	private var _text:Text;
	
	public function new() 
	{		
		super( {
            name: 'PausePopup',
            depth : 4,
			pos: Luxe.screen.mid,
			size: Luxe.screen.size,
			color : new Color(0, 0, 0, .75).rgb(0xba1b1d)
        });		
		
		_text = new Text({
            point_size : Math.min( Math.round(Luxe.screen.h / 12), 48),
            pos : Luxe.screen.mid,
			size : size,
            depth : 4,
            align : TextAlign.center,
            align_vertical : TextAlign.center,
            font : Luxe.resources.find_font("assets/font/Gagarin.fnt"),
            text : "Paused",
            color : new Color(0, 0, 0, 1).rgb(0xffffff),
			visible: false
        });	
	}
	
	public function show():Void
	{
		visible = _text.visible = true;		
	}
	
	public function hide():Void
	{
		visible = _text.visible = false;
	}
}