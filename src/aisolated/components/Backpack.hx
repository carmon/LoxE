package components;

import config.Defines;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Carmon
 */
class Backpack extends Component
{
	public var guide(get, null):Vector;
	private function get_guide():Vector
	{
		return new Vector(_sprite.pos.x, _sprite.pos.y - _sprite.size.y * .5 + Defines.CABLE_OFFSET);
	}
	
	private var _sprite:Sprite;
	public var sprite(get, null):Sprite;
	private function get_sprite():Sprite
	{
		return _sprite;
	}

	override public function onadded() 
	{
		var image = Luxe.loadTexture('assets/mochila.png');
		image.filter = FilterType.nearest;
		
		_sprite = new Sprite({
			name: this.name + '_sprite',
			texture: image,
			depth: 1,
            size: new Vector(image.width, image.height)
		});
	}
	
	override public function update(dt:Float) 
	{
		_sprite.pos.x = entity.pos.x;			
		_sprite.pos.y = entity.pos.y - Defines.PLAYER_FRAME_HEIGHT;
	}
}