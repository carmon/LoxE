package entities.gui.screens;
import entities.gui.util.UIAlign;
import luxe.Color;
import luxe.Log.log;
import luxe.options.SpriteOptions;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;
import phoenix.BitmapFont;

/**
 * ...
 * @author Carmon
 */
class IdleScreen extends Sprite
{
	private var _align:UIAlign;
	
	private var _text:Text;
	private var _font:BitmapFont;
	
	private var _startTime:Float;
	private var _currentTime:Float;

	public function new(align:UIAlign, options:SpriteOptions) 
	{
		_align = align;
		super(options);
	}
	
	override public function init() 
	{
		_font = Luxe.resources.find_font("assets/font/Gagarin.fnt");
		var text_size = Math.min( Math.round(Luxe.screen.h / 12), 48);				
		_text = new Text({
            point_size : text_size,
            bounds : new Rectangle(pos.x, pos.y, size.x, size.y),
            bounds_wrap : true,
			size : size,
            depth : 3,
            align : _align.h,
			align_vertical: _align.v,
            font : _font,
            text : "Press Start or Enter",
            color : new Color(0,0,0,1).rgb(0xffffff)
        });	
		
		_startTime = Luxe.current_time;
	}
	
	override public function update(dt:Float) 
	{
		_currentTime = Luxe.current_time;
		
		var diff:Float = _currentTime-_startTime;
		if (diff >= .25) {
			_text.visible = !_text.visible;
			_startTime = _currentTime;
		}
		
		super.update(dt);
	}
	
	override public function destroy(?_from_parent:Bool = false) 
	{
		_text.destroy(true);
		_text = null;
		_font = null;
		return super.destroy(_from_parent);
	}
}