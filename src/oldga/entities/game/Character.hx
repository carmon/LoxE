package entities.game;

import components.game.weapons.Weapon;
import luxe.components.sprite.SpriteAnimation;
import luxe.options.SpriteOptions;
import luxe.Rectangle;
import luxe.Sprite;
import managers.TilesManager;
import options.PlayerOptions;
import phoenix.Texture;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Character extends Sprite
{
	public static var STATE_IDLE	:Int = 0;
	public static var STATE_LEAN	:Int = 1;
	public static var STATE_JUMP	:Int = 2;
	public static var STATE_ATTACK	:Int = 3;
	public static var STATE_DIE		:Int = 4;
	
	public var grid_position	:Vector;
	public var target_position	:Vector; //No es necesario que sea público
	
	private var _deads			:Int;
	private var _active			:Bool;
		
	private var _current_state	:Int;
	private var _current_tile	:Tile;
	private var _current_dir	:Vector;
	
	private var _sheet			:Texture;
	private var _anim			:SpriteAnimation;
	private var _bounds			:Rectangle;
	
	private var _target_tile	:Tile;
	
	private var _dir:Vector;
	public var direction(get, never):Vector;
	private function get_direction():Vector
	{
		return _dir;
	}
	
	public var position:Vector;

	public function new(options:PlayerOptions)
	{
		_dir = new Vector();
		
		_current_state = STATE_IDLE;
		_current_dir = new Vector();
		
		_deads = 0;
		_active = false;
		
		_sheet = Luxe.resources.textures.get('assets/img/player_sheet.png');		
		_sheet.filter = FilterType.nearest;		
		
		super({
			name: 'Character ' + options.id,
			texture: _sheet,
			pos: new Vector(Luxe.screen.mid.x, Luxe.screen.h - 32),
			size: new Vector(32, 48),
			depth: 1
		});
		
		add(options.weapon);
		add(options.control);
		
		options = null;
		
		create();
	}
	
	public function set_grid_position(grid_pos:Vector):Void
	{
		grid_position = grid_pos;
		_current_tile = TilesManager.getInstance().get_tile_by_pos(Std.int(grid_position.x), Std.int(grid_position.y));
		pos.x = _current_tile.pos.x;
		pos.y = _current_tile.pos.y;
		_current_tile.occupied = true;
	}
	
	public function set_target_position(target_pos:Vector):Void
	{
		_active = true;
		target_position = target_pos;
		_target_tile = TilesManager.getInstance().get_tile_by_pos(Std.int(target_position.x), Std.int(target_position.y));
		_anim.animation = 'jump_in';
		_anim.restart();
	}
	
	public function set_state(state:Int, dir:Vector):Void
	{
		if (dir != null) 
			_current_dir = dir;
		
		_current_state = state;
	}
	
	private function create():Void
	{
		_bounds = new Rectangle();
		_bounds.x = pos.x - 16;
		_bounds.y = pos.y - 24;
		_bounds.w = 32;
		_bounds.h = 48;
		
		create_animations();
	}
	
	private function create_animations():Void
	{
		var anim_object= Luxe.loadJSON("assets/json/player_anim.json");
		
		_anim = add(new SpriteAnimation( { name:'player_anim' } ));
		_anim.add_from_json_object( anim_object.json );
		_anim.animation = 'idle';
		_anim.play();
				
		events.listen('jump_in_complete', jump_in_complete);
		events.listen('jump_out_complete', jump_out_complete);
		
		events.listen('attack_in_complete', attack_in_complete);
		events.listen('attack_out_complete', attack_out_complete);
		
		events.listen('dead_complete', dead_complete);
	}

	override public function update(dt:Float) 
	{
		switch(_current_state) {
			case Character.STATE_IDLE:
				if (_anim.current.name != 'idle') {
					_anim.animation = 'idle';
					_anim.restart();
				}
			case Character.STATE_LEAN:
				if (_anim.current.name.indexOf('lean') != -1) {					
					if(_dir.x == -1 || _dir.y == 1) _anim.animation = 'strafe_backward';
					if(_dir.x == 1 || _dir.y == -1) _anim.animation = 'strafe_forward';
					_anim.restart();
				}
			case Character.STATE_JUMP:
				if (_anim.current.name.indexOf('jump') != -1) {
					_active = true;
					_anim.animation = 'jump_in';
					_anim.restart();
				}
			case Character.STATE_ATTACK:
				if (_anim.current.name.indexOf('attack') != -1) {
					_active = true;
					_anim.animation = 'attack_in';
					_anim.restart();
				}
			case Character.STATE_DIE:
				if (_anim.current.name != 'dead') {
					_anim.animation = 'dead';
					_anim.restart();
				}
		}
		
		cast(get('Weapon'), Weapon).updatePosition();
	}
	
	private function jump_in_complete(_):Void
	{
		
	}
	
	private function jump_out_complete(_):Void
	{
		
	}
	
	private function attack_in_complete(_):Void
	{
		
	}
	
	private function attack_out_complete(_):Void
	{
		
	}
	
	private function dead_complete(_):Void
	{
		
	}
	
	/**** Begin Callbacks *********************************************/
	private var _on_pause_handler:Void->Void;
	public var on_pause(never, set):Void->Void;
	private function set_on_pause(value:Void->Void)
	{
		_on_pause_handler = value;
		return value;
	}
	
	private var _on_attack_handler:Character->Tile->Void;
	public var on_attack(never, set):Character->Tile-> Void;
	private function set_on_attack(value:Character->Tile-> Void)
	{
		_on_attack_handler = value;
		return value;
	}
	
	private var _on_move_handler:Character->Vector->Void;
	public var on_move(never, set):Character->Vector->Void;
	private function set_on_move(value:Character->Vector->Void)
	{
		_on_move_handler = value;
		return value;
	}
	/**** End Callbacks *********************************************/
}