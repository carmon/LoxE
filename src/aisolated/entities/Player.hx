package entities;

import components.Avatar;
import components.Backpack;
import components.Shadow;
import config.Defines;
import luxe.components.sprite.SpriteAnimation;
import luxe.Entity;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture.FilterType;
import ui.debug.DebugDraw;

/**
 * ...
 * @author Carmon
 */
class Player extends Entity
{
	public static var IDLE:Int = 0;
	public static var WALK:Int = 1;
	public static var JUMP:Int = 2;
	public static var PUT :Int = 3;
	
	private var _state:Int;
	public var state(get, null):Int;
	private function get_state():Int
	{
		return _state;
	}
	
	private var _avatar:Avatar;
	private var _backpack:Backpack;
	private var _shadow:Shadow;
	
	private var _cable:Cable;
	
	private var _top_limit:Float;
	private var _bottom_limit:Float;
	
	private var _move_speed_x:Float = 75;
	private var _move_speed_y:Float = 50;
	private var _jump_speed:Float = 200;
	
	private var _jump_force:Float = 0;
	
	private var _jump_offset_y:Float = 0;
	private var _last_pos_y:Float = 0;
	
	public function get_projection_y():Float
	{
		return _last_pos_y + _jump_offset_y;
	}
	
	public var on_action:Vector->Void;
	
	public function isIdle():Bool
	{
		return _state == IDLE;
	}
	
	public function isWalking():Bool
	{
		return _state == WALK;
	}
	
	public function isJumping():Bool
	{
		return _state == JUMP;
	}
	
	public function isPutting():Bool
	{
		return _state == PUT;
	}

	public function new()
	{
		super({ name: 'player', pos: new Vector(Luxe.screen.mid.x * .25, Luxe.screen.h * .75) });
		
		_state = IDLE;
		
		_cable = null;
		
		_avatar = new Avatar( { name: 'player_avatar_component'	});
		add(_avatar);
		
		_backpack = new Backpack( { name: 'player_backpack' } );
		add(_backpack);
		
		_shadow = new Shadow({name: 'player_shadow' });
		add(_shadow);
		
		_jump_offset_y = 0;
		
		_top_limit = Defines.HORIZON - Defines.PLAYER_FRAME_HEIGHT * .5;
		_bottom_limit = Defines.GAME_HEIGHT - Defines.PLAYER_FRAME_HEIGHT * .75;
		
		Luxe.events.fire('player.created');
	}
	
	public function init_listeners()
	{
		_avatar.sprite.events.listen('jump_start', on_jump_start);
		_avatar.sprite.events.listen('jump_mid', on_jump_mid);
		_avatar.sprite.events.listen('jump_end', on_jump_end);
		
		//events.listen('player.jump_mid', on_jump_mid);
		//events.listen('player.jump_end', on_jump_end);
		
		events.listen('player.action_mid', on_action_mid);
		events.listen('player.action_end', on_action_end);
	}
	
	private var _jumping:Bool = false;
	
	private function on_jump_start(_)
	{
		trace('on_jump_start');
		_jumping = true;
	}
	
	private function on_jump_mid(_)
	{
		trace('on_jump_mid');		
		_jump_speed = -_jump_speed;
	}
	
	private function on_jump_end(_)
	{
		trace('on_jump_end');
		_jumping = false;
		_state = IDLE;
		_jump_speed = Math.abs(_jump_speed);
		_jump_force = 0;
		_jump_offset_y = 0;
	}
	
	private function on_action_mid(_)
	{
		on_action(pos);
	}
	
	private function on_action_end(_)
	{
		_state = IDLE;
	}
	
	public function reset():Void
	{
		pos = new Vector(Luxe.screen.mid.x * .25, Luxe.screen.h * .75);
		_state = IDLE;
	}
	
	public function setCable(c:Cable):Void
	{
		c.setEnd(_backpack.guide);
		_cable = c;
	}
	
	override public function update(delta:Float) 
	{
		//trace("A");
		if (_state != PUT) {
			if (_cable == null) return;
			
			var x_length:Float = _cable.getLengthX();
			var y_length:Float = _cable.getLengthY();
				
			if (_jumping) {				
				/*
				var target = _last_pos_y + _jump_offset_y;
				var offset:Float = _move_speed_y * delta;
				if (Luxe.input.inputdown('up')){
					if(target > _top_limit) {
						pos.y -= offset;
						_jump_offset_y -= offset;
					}
				} 
				if (Luxe.input.inputdown('down')) {
					if(target < _bottom_limit) {
						pos.y += offset;
						_jump_offset_y += offset;	
					}
				}
				*/
				//var speed:Float = _jump_speed - _jump_speed * .2 * _avatar.jump_step;
				_jump_force += _jump_speed * delta;
				pos.y -= _jump_force;
				trace("a:: " + pos.y + "," + _avatar.anim.current.frame_time);				
			} else {
				if (Luxe.input.inputdown('up')) {
					if (Math.abs(x_length) + Math.abs(y_length - _move_speed_y * delta) <= Defines.CABLE_MAX_LENGTH) {
						_state = WALK;
						pos.y -= _move_speed_y * delta;
						if (pos.y < _top_limit) pos.y = _top_limit;
					}					
				} else if (Luxe.input.inputdown('down')) {
					if(Math.abs(x_length) + Math.abs(y_length + _move_speed_y * delta) <= Defines.CABLE_MAX_LENGTH){
						_state = WALK;
						pos.y += _move_speed_y * delta;
						if (pos.y > _bottom_limit) pos.y = _bottom_limit;
					}
				} else if (Luxe.input.inputdown('left') || Luxe.input.inputdown('right')) {
					_state = WALK;
				} else {
					_state = IDLE;
				}
				
				if (Luxe.input.inputdown('jump')) {
					_state = JUMP;
					_last_pos_y = pos.y;
				}
				
				if (Luxe.input.inputdown('action')) {
					_state = PUT;
				}
			}
			
			if (Luxe.input.inputdown('left')) {
				if (Math.abs(x_length - _move_speed_x * delta) + Math.abs(y_length) <= Defines.CABLE_MAX_LENGTH){
					pos.x -= _move_speed_x * delta;
					_avatar.sprite.flipx = _backpack.sprite.flipx = true;
				}
			} else if (Luxe.input.inputdown('right')) {
				if (Math.abs(x_length + _move_speed_x * delta) + Math.abs(y_length) <= Defines.CABLE_MAX_LENGTH){
					pos.x += _move_speed_x * delta;
					_avatar.sprite.flipx = _backpack.sprite.flipx = false;
				}
			}
			
			//trace((_state == JUMP)+" , "+pos);
			
			var g = _backpack.guide;
			_cable.setEnd(g);
			DrawTool.instance.drawGuide(g);
			
			DrawTool.instance.drawGuide(pos);
		}
	}
}