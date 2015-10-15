package components.game.weapons;

import entities.game.Character;
import managers.TilesManager;
import entities.game.Player;
import entities.game.Tile;
import luxe.Component;
import luxe.Visual;
import luxe.Log.log;
import phoenix.Texture;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Weapon extends Component
{
	public static var UP	:Int = 0;
	public static var DOWN	:Int = 1;
	public static var LEFT	:Int = 2;
	public static var RIGHT	:Int = 3;
	
	public var type:String = "Weapon";
	
	private var _player:Character;	
	private var _offsets:Array<Vector>;
	private var _offsets_visual:Array<Visual>;
	
	private var _locked_dirs:Array<Bool>;
	
	public function new() 
	{
		super({ name: 'Weapon' });
	}
	
	override public function onadded() 
	{
		_player = cast entity;
		
		_offsets = new Array<Vector>();
		_offsets.push(new Vector());
		
		_offsets_visual = new Array<Visual>();
		for (i in 0..._offsets.length) {
			var image:Texture = Luxe.resources.textures.get('assets/img/weapon_tile.png');
			image.filter = FilterType.nearest;
			_offsets_visual.push(new Visual( { 
				texture: image,
				origin: new Vector(image.width*.5, image.height*.5)
				} ));
		}
		
		_locked_dirs = new Array<Bool>();
		for (i in 0...4) _locked_dirs.push(false);
	}
	
	public function updatePosition():Void
	{	
		var start_pos:Vector = _player.position.clone();
		cleanLocks();
		
		if (_player.direction.length > 0) {
			
			for (i in 0..._offsets_visual.length) _offsets_visual[i].visible = true;
			
			if (start_pos.x == 0) {
				_locked_dirs[LEFT] = true;
				if (_player.direction.x == -1) _player.direction.x = 1;
			} else if (start_pos.x == TilesManager.getInstance().cols - 1) {
				_locked_dirs[RIGHT] = true;
				if (_player.direction.x == 1) _player.direction.x = -1;
			}
			if (start_pos.y == 0) {
				_locked_dirs[UP] = true;
				if (_player.direction.y == -1) _player.direction.y = 1;
			} else if (start_pos.y == TilesManager.getInstance().rows - 1) {
				_locked_dirs[DOWN] = true;
				if (_player.direction.y == 1) _player.direction.y = -1;
			}
			start_pos.add(_player.direction);		
			for (i in 0..._offsets.length) {
				var pos:Vector = _offsets[i].clone();
				pos.add(start_pos);
				var visual:Visual = _offsets_visual[i];
				var tile:Tile = TilesManager.getInstance().get_tile_by_pos(Std.int(pos.x), Std.int(pos.y));
				if (tile != null) visual.pos = tile.pos;
				else visual.pos = null;
			}
		} else {
			//Just for debugging
			for (i in 0..._offsets_visual.length) _offsets_visual[i].visible = false;
		}
	}
	
	public function get_target():Tile
	{
		return TilesManager.getInstance().get_tile_by_pos(Std.int(pos.x), Std.int(pos.y));
	}
	
	public function isLocked(dir:Int):Bool
	{
		return _locked_dirs[dir];
	}
	
	private function cleanLocks():Void
	{
		for (i in 0..._locked_dirs.length) _locked_dirs[i] = false;			
	}
}