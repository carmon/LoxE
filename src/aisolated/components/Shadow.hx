package components;

import config.Defines;
import entities.Player;
import luxe.Component;
import luxe.Entity;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import phoenix.Texture.FilterType;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Shadow extends Component
{
	private var _holder:Player;	
	private var _sprite:Sprite;

	public function new(?_options:ComponentOptions) 
	{
		super(_options);
	}
	
	override public function onadded() 
	{
		var image = Luxe.loadTexture('assets/player_shadow.png');
		image.filter = FilterType.nearest;
		_sprite = new Sprite({
			name: this.name + '_sprite',
			texture: image,
			depth: Defines.DEPTH_PLAYER,
            size: new Vector(image.width, image.height)	
		});
		
		_holder = cast entity;
	}
	
	override public function update(dt:Float) 
	{
		if(_holder.state != Player.JUMP){
			_sprite.pos = _holder.pos;
		} else {
			_sprite.pos.x = _holder.pos.x;
			_sprite.pos.y = _holder.get_projection_y();
		}
	}
}