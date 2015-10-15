package entities.gui.screens;

import entities.gui.util.UIAlign;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Text;
import luxe.Log.log;
import phoenix.BitmapFont;
import phoenix.Color;
import phoenix.Rectangle;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class ReadyScreen extends Sprite
{
	private var _align:UIAlign;
	
	private var _text:Text;
	private var _font:BitmapFont;
	
	private var _on_back:Void->Void;
	public var on_back(never, set):Void -> Void;
	private function set_on_back(value:Void->Void)
	{
		_on_back = value;
		return value;
	}

	public function new(align:UIAlign, options:SpriteOptions) 
	{
		_align = align;
		super(options);
	}
	
	override public function init() 
	{
		_font = Luxe.resources.find_font("assets/font/Gagarin.fnt");
		var text_size = Math.min( Math.round(Luxe.screen.h/12), 48);
		_text = new Text({
            point_size : text_size,
            bounds : new Rectangle(pos.x, pos.y, size.x, size.y),
            bounds_wrap : true,
            depth : 3,
            align : _align.h,
			align_vertical: TextAlign.bottom,
            font : _font,
            text : "Ready",
            color : new Color(0,0,0,1).rgb(0xffffff)
        });		
	}
	
	public function back()
	{
		_on_back();
	}
	
	override public function destroy(?_from_parent:Bool = false) 
	{
		_text.destroy(true);
		_text = null;
		_font = null;
		
		_on_back = null;		
		
		super.destroy(_from_parent);
	}
}