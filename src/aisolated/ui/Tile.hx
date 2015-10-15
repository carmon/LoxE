package ui;
import config.Defines;
import luxe.components.sprite.SpriteAnimation;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Carmon
 */
class Tile
{
	private var _type:Int;
	public var type(get, null):Int;
	private function get_type():Int
	{
		return _type;
	}
	
	private var _tile:Sprite;
	private var _anim:SpriteAnimation;
	
	public var pos(get, set):Vector;
	private function get_pos():Vector
	{
		return _tile.pos;
	}
	private function set_pos(value:Vector):Vector
	{
		_tile.pos = value;
		return _tile.pos;
	}

	public function new(name:String, texture:Texture, pos:Vector, precedent_x:Int, precedent_y:Int) 
	{		
		if (texture == null) {
			texture = Luxe.loadTexture('assets/tileset.png');
			texture.filter = FilterType.nearest;
		}
		
		_tile = new Sprite({
            name: name,
            texture: texture,
			depth: Defines.DEPTH_TILE,
			centered: false,
            pos : pos,
            size: new Vector(Defines.TILE_SIZE, Defines.TILE_SIZE)
        });
		
		var anim_object = Luxe.resources.find_json('assets/tileset_anim.json');
		_anim = _tile.add( new SpriteAnimation( { name:'tileset_anim' } ) );
		_anim.add_from_json_object( anim_object.json );
        _anim.animation = 'common';
        _anim.play();
		
		resetType(precedent_x, precedent_y);
	}
	
	public function resetType(precedent_x:Int, precedent_y:Int)
	{		
		var r:Float = Math.random();
		var p:Float = 0;
		var t:Int = -1;
		if (precedent_x != -1) {
			switch(precedent_x) {
				case Defines.TILE_TYPE_COMMON:
					p = Defines.TILE_0_TYPE_PROB.x;
				case Defines.TILE_TYPE_UNCOMMON:
					p = Defines.TILE_1_TYPE_PROB.x;
				case Defines.TILE_TYPE_RARE:
					p = Defines.TILE_2_TYPE_PROB.x;
			}
			if (r < p) t = precedent_x;
		}
		if (t != -1) {
			setType(t); 
			return;
		}
		if (precedent_y != -1) {
			switch(precedent_y) {
				case Defines.TILE_TYPE_COMMON:
					p = Defines.TILE_0_TYPE_PROB.y;
				case Defines.TILE_TYPE_UNCOMMON:
					p = Defines.TILE_1_TYPE_PROB.y;
				case Defines.TILE_TYPE_RARE:
					p = Defines.TILE_2_TYPE_PROB.y;
			}
			if (r < p) t = precedent_y;
		}
		if (t != -1) {
			setType(t); 
			return;
		}
		if (r <= Defines.TILE_2_GRAL_PROB) {
			t = Defines.TILE_TYPE_RARE;
		} else if (r <= Defines.TILE_1_GRAL_PROB) {
			t = Defines.TILE_TYPE_UNCOMMON;
		} else {
			t = Defines.TILE_TYPE_COMMON;
		}
		setType(t);
	}
	
	private function setType(value:Int)
	{
		_type = value;
		switch(_type) {
			case Defines.TILE_TYPE_COMMON:
				_anim.animation = 'common';
			case Defines.TILE_TYPE_UNCOMMON:
				_anim.animation = 'uncommon';
			case Defines.TILE_TYPE_RARE:
				_anim.animation = 'stone';
		}
	}
}