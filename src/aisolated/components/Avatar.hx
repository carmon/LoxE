package components;

import config.Defines;
import entities.Player;
import luxe.Component;
import luxe.components.sprite.SpriteAnimation;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import phoenix.Texture.FilterType;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Avatar extends Component
{
	private var _holder:Player;	
	private var _offset:Vector;
	
	private var _sprite:Sprite;
	public var sprite(get, null):Sprite;
	private function get_sprite():Sprite
	{
		return _sprite;
	}
	
	private var _key_action:Int;
	
	private var _last_key:Int;
	private var _key_it:Int;
	private var _key_anim:Int;
	public var jump_step(get, null):Int;
	private function get_jump_step():Int
	{
		return _key_anim - 1;
	}
	
	private var _anim:SpriteAnimation;
	public var anim(get, null):SpriteAnimation;
	private function get_anim():SpriteAnimation
	{
		return _anim;
	}	
	
	public function new(?_options:ComponentOptions) 
	{
		super(_options);
		
		_offset = new Vector(-Defines.PLAYER_FRAME_WIDTH*.5, -Defines.PLAYER_FRAME_HEIGHT);
	}
	
	override public function onadded() 
	{
		var image = Luxe.loadTexture('assets/player.png');
		image.filter = FilterType.nearest;
		
		_sprite = new Sprite({
            name: 'avatar_sprite',
            texture: image,
			depth: Defines.DEPTH_PLAYER,
			centered: false,
            size: new Vector(Defines.PLAYER_FRAME_WIDTH, Defines.PLAYER_FRAME_HEIGHT),
			pos: _offset
        });
		
		var anim_object = Luxe.resources.find_json('assets/player_anim.json');
		_anim = _sprite.add( new SpriteAnimation( { name:'player_anim' } ) );
		_anim.add_from_json_object( anim_object.json );
        _anim.animation = 'idle';
        _anim.play();
		
		_key_action = 0;
		
		_key_it = 1;
		_last_key = _key_anim = 0;
		
		_holder = cast entity;
		_holder.init_listeners();
	}
	
	override public function update(dt:Float) 
	{
		//trace("B");
		_sprite.pos.x = _holder.pos.x + _offset.x;
		_sprite.pos.y = _holder.pos.y + _offset.y;
		
		switch(_holder.state) {
			case Player.IDLE:
				if (_anim.animation != 'idle') {
					_anim.animation = 'idle';
					_anim.restart();
				}
			case Player.WALK:
				if (_anim.animation != 'walk') {
					_anim.animation = 'walk';
					_anim.restart();
				}
			case Player.JUMP:
				if (_anim.animation != 'jump') {
					_anim.animation = 'jump';
					_anim.restart();
				} else {
					/*
					if (_last_key != _anim.current_frame.image_frame) {
						_last_key = _anim.current_frame.image_frame;
						_key_anim += _key_it;
					}
					//trace(_anim.current_frame.image_frame+' , '+_key_anim);
					if (_anim.current_frame.image_frame == 21 && _key_it == 1) {
						_key_action++;
						if (_key_action == 4) {
							_key_action = 0;
							_key_it = -_key_it;
							entity.events.fire('player.jump_mid');
						}
					}			
					if (_anim.current_frame.image_frame == 24) {
						_key_action++;
						if (_key_action == 4) {
							_key_action = 0;
							_last_key = _key_anim = 0;
							_key_it = 1;
							entity.events.fire('player.jump_end');
						}
					}
					*/
				}
			case Player.PUT:
				if (_anim.animation != 'action') {
					_anim.animation = 'action';
					_anim.restart();
				} else {
					if (_anim.current_frame.image_frame == 29) {
						_key_action++;
						if (_key_action == 4) {
							_key_action = 0;
							entity.events.fire('player.action_mid');
						}
					}			
					if (_anim.current_frame.image_frame == 32) {
						_key_action++;
						if (_key_action == 8) {
							_key_action = 0;
							entity.events.fire('player.action_end');
						}
					}
				}
		}
	}
}