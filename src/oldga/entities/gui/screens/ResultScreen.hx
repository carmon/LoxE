package entities.gui.screens;

import entities.gui.util.UIAlign;
import luxe.options.SpriteOptions;
import luxe.Sprite;

/**
 * ...
 * @author Carmon
 */
class ResultScreen extends Sprite
{
	private var _align:UIAlign;

	public function new(align:UIAlign, options:SpriteOptions) 
	{
		_align = align;
		super(options);
	}
	
	override public function init() 
	{
		
	}
}