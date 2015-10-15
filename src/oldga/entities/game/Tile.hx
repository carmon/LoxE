package entities.game;

import luxe.Input.MouseEvent;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Rectangle;
import phoenix.Texture;
/**
 * ...
 * @author Carmon
 */
class Tile extends Sprite
{
	private var _id:Int;
	private var _bounds:Rectangle;
	//TODO: cambiar bounds para utilizar tiles animadas
	
	private var _image:Texture;
	
	public var width(get, never):Float;
	private function get_width():Float
	{
		return _bounds.w;
	}
	
	public var height(get, never):Float;
	private function get_height():Float
	{
		return _bounds.h;
	}
	
	public var occupied:Bool;

	public function new(id:Int, ?texture:Texture=null) 
	{
		_id = id;
		_image = texture;
		if (_image != null) {
			create(null);
		}
		
		super( {
			name: 'Tile '+Std.string(id),
			texture: _image,
			pos: new Vector(),
			size: new Vector(_image.width, _image.height),
			depth: 0,
			batcher : Luxe.renderer.batcher
		});		
		
		occupied = false;
	}
	
	override public function init() 
	{
		if(_image == null){
			_image = Luxe.loadTexture('assets/img/tile_idle.jpg');
			_image.onload = create;
		}
	}
	
	private function create(_)
	{
		_image.filter = FilterType.nearest;
				
		_bounds = new Rectangle();
		_bounds.x = _bounds.y = 0;
		_bounds.w = _image.width;
		_bounds.h = _image.height;
	}
	
	public function setPosition(x:Float, y:Float)
	{
		pos.x = x;
		pos.y = y;
	}
}