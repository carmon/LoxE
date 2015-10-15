package entities.gui.screens;

import components.game.weapons.Bow;
import components.game.weapons.Spear;
import components.game.weapons.Sword;
import components.game.weapons.Weapon;
import entities.gui.util.UIAlign;
import luxe.options.SpriteOptions;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.Text;
import phoenix.BitmapFont;
import phoenix.Color;

/**
 * ...
 * @author Carmon
 */
 
class SelectScreen extends Sprite
{
	private var _align:UIAlign;
	private var _text:Text;
	private var _font:BitmapFont;
	
	private var _currentText:Int;
	private var _classTexts:Array<Text>;
	
	private var _on_selected:Weapon->Void;
	public var on_selected(never, set):Weapon -> Void;
	private function set_on_selected(value:Weapon->Void)
	{
		_on_selected = value;
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
			size : size,
            depth : 3,
            align : _align.h,
            font : _font,
            text : "Select your character",
            color : new Color(0,0,0,1).rgb(0xffffff)
        });	
		
		//TODO: Config de clases
		_classTexts = new Array<Text>();
		var text:Text = new Text({
            point_size : text_size,
            bounds : new Rectangle(pos.x, pos.y + size.y * .5 - text_size * 2, size.x, text_size),
            bounds_wrap : true,
            depth : 3,
            align : _align.h,
            align_vertical : _align.v,
            font : _font,
            text : "Swordman",
            color : new Color(0,0,0,1).rgb(0xffffff)
        });
		_classTexts.push(text);
		
		text = new Text({
            point_size : text_size,
            bounds : new Rectangle(pos.x, pos.y + size.y * .5 - text_size, size.x, text_size),
            bounds_wrap : true,
            depth : 3,
            align : _align.h,
            align_vertical : _align.v,
            font : _font,
            text : "Spearman",
            color : new Color(0,0,0,1).rgb(0xffffff)
        });
		_classTexts.push(text);
		text = new Text({
            point_size : text_size,
            bounds : new Rectangle(pos.x, pos.y + size.y * .5, size.x, text_size),
            bounds_wrap : true,
            depth : 3,
            align : _align.h,
            align_vertical : _align.v,
            font : _font,
            text : "Bowman",
            color : new Color(0,0,0,1).rgb(0xffffff)
        });
		_classTexts.push(text);
		
		_currentText = 0;
		updateSelection();
	}
	
	public function moveNext():Void
	{
		cleanSelection();
		_currentText++;
		if (_currentText == _classTexts.length) _currentText = 0;
		updateSelection();
	}
	
	public function moveBack():Void
	{
		cleanSelection();
		_currentText--;
		if (_currentText == -1) _currentText += _classTexts.length;
		updateSelection();		
	}
	
	public function select():Void
	{
		switch(_currentText) {
			case 0:	_on_selected(new Sword());
			case 1:	_on_selected(new Spear());
			case 2:	_on_selected(new Bow());
		}
	}
	
	private function cleanSelection():Void
	{
		_classTexts[_currentText].color = new Color(0, 0, 0, 1).rgb(0xffffff);
	}
	
	private function updateSelection():Void
	{
		_classTexts[_currentText].color = new Color(0, 0, 0, 1).rgb(0xba1b1d);		
	}
	
	override public function destroy(?_from_parent:Bool = false) 
	{
		for (i in 0..._classTexts.length) {
			_classTexts[i].destroy(true);
			_classTexts[i] = null;
		}
		_classTexts = null;
		
		_text.destroy(true);
		_text = null;
		_font = null;
		
		_on_selected = null;
		
		super.destroy(_from_parent);
	}
}