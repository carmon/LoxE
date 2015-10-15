package entities.game;

import components.game.weapons.Weapon;
import managers.TilesManager;
import luxe.components.sprite.SpriteAnimation;
import luxe.Log.log;
import luxe.Rectangle;
import luxe.Sound;
import luxe.Sprite;
import options.PlayerOptions;
import phoenix.Texture;
import phoenix.Vector;
/**
 * ...
 * @author Carmon
 */
class Player extends Character
{		
	//public var position:Vector;
	
	public function setMove(step:Vector):Void
	{
		if (_on_move_handler != null) _on_move_handler(this, step);
	}
	
	public function lean(dir:Vector):Void
	{
		_dir = dir;
		if(dir.x == -1 || dir.y == 1) _anim.animation = 'strafe_backward';
		if(dir.x == 1 || dir.y == -1) _anim.animation = 'strafe_forward';
		_anim.restart();
	}
	
	public function idle(dir:Vector):Void
	{
		_dir = dir;
		_anim.animation = 'idle';
		_anim.restart();
	}
	
	private var _teleport_tile:Tile;	
	private var _teleport_tile_pos:Vector;
	
	private var _in_sound:Sound;
	private var _out_sound:Sound;
	
	private var _speed:Float;
	private var _moving:Bool;
	private var _teleporting:Bool;
	private var _target_pos:Vector;
		
	private var _points:Int;
	private var _life:Int;
	
	public function isBusy():Bool
	{
		return _teleporting;
	}

	public function new(options:PlayerOptions) 
	{		
		super(options);
		
		_speed = 250;
		_teleporting = _moving = false;
		
		_points = 0;
	}
	
	override public function init():Void
	{	
		_in_sound = Luxe.audio.create('assets/fx/in.wav', 'teleport_in');
		_out_sound = Luxe.audio.create('assets/fx/out.wav', 'teleport_out');		
	}
	
	override private function jump_in_complete(_)
	{			
		log('jump_in_complete');
		_current_tile.occupied = false;
		_current_tile = _teleport_tile;
		pos.x = _current_tile.pos.x;
		pos.y = _current_tile.pos.y;		
		_current_tile.occupied = true;
		
		position = _teleport_tile_pos;
		
		_bounds.x = pos.x - 16;
		_bounds.y = pos.y - 24;
		
		_anim.animation = 'jump_out';
		_anim.restart();
		_out_sound.play();
	}
	
	override private function jump_out_complete(_)
	{			
		_teleporting = false;
		_anim.animation = 'idle';			
		_anim.restart();
	}
	
	public function callPause():Void
	{
		_on_pause_handler();
	}
	
	public function attack():Void
	{
		//_on_attack_handler(this, cast(get('Weapon'), Weapon).get_target());
	}
	
	public function jump():Void
	{
		if (_dir.length == 0) return;
		setMove(_dir);
	}
	
	public function setPosition(tilePosition:Vector):Void
	{
		position = tilePosition;
		_current_tile = TilesManager.getInstance().get_tile_by_pos(Std.int(position.x), Std.int(position.y));
		pos.x = _current_tile.pos.x;
		pos.y = _current_tile.pos.y;
		_current_tile.occupied = true;
	}
	
	public function teleport(tilePosition:Vector):Void
	{		
		if (_moving) _moving = false;
		_teleporting = true;
		_teleport_tile_pos = tilePosition;
		_teleport_tile = TilesManager.getInstance().get_tile_by_pos(Std.int(tilePosition.x), Std.int(tilePosition.y));		
		_anim.animation = 'jump_in';
		_anim.restart();
		_in_sound.play();
	}
	
	public function setTarget(x:Float, y:Float):Void
	{
		_target_pos = new Vector(x, y);
		_moving = true;
	}
	
	override public function update(dt:Float) 
	{
		if (_moving) {
			var dir:Vector = new Vector(_target_pos.x - pos.x, _target_pos.y - pos.y - 24);			
			if (dir.length < _speed * dt) {
				_moving = false;
			} else {
				dir.normalize();
				pos.x += dir.x * _speed * dt;
				pos.y += dir.y * _speed * dt;
				
				_bounds.x = pos.x - 16;
				_bounds.y = pos.y - 24;
			}
		}
		
		cast(get('Weapon'), Weapon).updatePosition();
	}
	
	public function overlaps(pos:Vector):Bool
	{
		return _bounds.point_inside(pos);
	}
}