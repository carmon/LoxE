package states;

import entities.game.Character;
import entities.gui.PausePopup;
import entities.gui.PlayerMenu;
import managers.TilesManager;
import entities.game.Player;
import entities.game.Tile;
import luxe.Log.log;
import luxe.States.State;
import options.PlayerOptions;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Playing extends State
{
	private var _paused	:Bool;
	private var _pausePopup:PausePopup;
	
	private var _guis	:Array<PlayerMenu>;
	private var _chars	:Array<Character>;
	private var _tiles	:Array<Vector>;

	public function new()
	{
		super( { name: 'playing' } );
	}
	
	override public function onenter<T>(guis:T) 
	{
		//log('onenter playing:: '/*+$type(configs)*/);		
		_pausePopup = new PausePopup();
		_pausePopup.hide();
		_paused = false;
		
		var t:Dynamic = guis;
		_guis = t;
		
		create_tiles();
		create_players();
		create_guis();
	}
	
	override public function update(dt:Float) 
	{
		
	}
	
	function create_tiles()
	{
		TilesManager.getInstance().start(6, 3);
		
		_tiles = new Array<Vector>();
		_tiles.push(new Vector(1, 1));
		_tiles.push(new Vector(4, 1));
	}
	
	function create_players()
	{
		_chars = new Array<Character>();
		for (i in 0..._guis.length) {
			var char:Character = new Character(_guis[i].config);
			char.set_grid_position(_tiles[i]);
			char.on_move = on_character_move;
			char.on_pause = on_character_pause;
			char.on_attack = on_character_attack;
			_chars.push(char);
		}
	}
	
	function create_guis()
	{
		
	}
	
	function on_character_move(char:Character, dir:Vector)
	{
		if (_paused) return;
		
		var p:Vector = char.grid_position.clone();
		p.add(dir);
		if (p.x < 0 || p.x >= TilesManager.getInstance().cols) return;
		if (p.y < 0 || p.y >= TilesManager.getInstance().rows) return;
		if (TilesManager.getInstance().get_tile_by_pos(Std.int(p.x), Std.int(p.y)).occupied) return;
		char.set_target_position(p);
	}
	
	function on_character_attack(char:Character, target:Tile)
	{
		for (i in 0..._chars.length) {
			log(char != _chars[i]);			
		}
	}
	
	function on_character_pause()
	{
		_paused = !_paused;
		if (_paused) _pausePopup.show();
		else _pausePopup.hide();
	}
}