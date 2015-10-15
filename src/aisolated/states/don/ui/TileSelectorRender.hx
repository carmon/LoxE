package states.don.ui;

import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Visual;
import mint.render.luxe.LuxeMintRender;
import mint.render.Render;
import phoenix.Batcher;
import phoenix.Color;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class TileSelectorRender extends Render
{
	private var _selector:Selector;
	private var _image:Visual;

	public function new(_render:LuxeMintRender, _control:TileSelectorControl) 
	{
		super(_render, _control);
		
		_selector = new Selector( {
			id: _control.name+'.selector',
			color: new Color().rgb(0xFF3737),
			tickness: 2,
			batcher: _render.options.batcher,
            depth: _render.options.depth + _control.depth
		});
		
		
		
		_selector.create(_control.x, _control.y, _control.w, _control.h);
	}
	
}

typedef SelectorOptions = {
	id:String,
	color:Color,
	tickness:Float,
	depth:Float,
	batcher:Batcher
}

class Selector
{
	private var _opt:SelectorOptions;
	
	private var _t:Sprite;
	private var _r:Sprite;
	private var _b:Sprite;
	private var _l:Sprite;
	
	private var _created:Bool;
	
	public function new(opt:SelectorOptions)
	{
		_opt = opt;
		_created = false;
	}
	
	public function create(x:Float, y:Float, w:Float, h:Float)
	{
		if (_created) {
			_t.destroy();
			_r.destroy();
			_b.destroy();
			_l.destroy();
		}
		
		_t = new Sprite( {
			name: _opt.id + '.top',
			centered: false,
			color: _opt.color,
			depth: _opt.depth,
			batcher: _opt.batcher,
			pos: new Vector(x, y),
			size: new Vector(w, _opt.tickness)
		});
		_r = new Sprite( {
			name: _opt.id + '.right',
			centered: false,
			color: _opt.color,
			depth: _opt.depth,
			batcher: _opt.batcher,
			pos: new Vector(x + w - _opt.tickness, y),
			size: new Vector(_opt.tickness, h)
		});
		_b = new Sprite( {
			name: _opt.id + '.bottom',
			centered: false,
			color: _opt.color,
			depth: _opt.depth,
			batcher: _opt.batcher,
			pos: new Vector(x, y + h - _opt.tickness),
			size: new Vector(w, _opt.tickness)
		});
		_l = new Sprite( {
			name: _opt.id + '.left',
			centered: false,
			color: _opt.color,
			depth: _opt.depth,
			batcher: _opt.batcher,
			pos: new Vector(x, y),
			size: new Vector(_opt.tickness, h)
		});
		_created = true;
	}
}