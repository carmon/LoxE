package managers;

import entities.game.Tile;
import luxe.Vector;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Carmon
 */
 
class TilesManager
{	
	private static var _instance:TilesManager = null;	
    private static var _internallyCalled:Bool = false;	
	public static function getInstance():TilesManager
	{
		if (_instance == null) {
			_internallyCalled = true;
			_instance = new TilesManager();
		}
		return _instance;
	}	
	
	private var _rows:Int;
	public var rows(get, never):Int;
	function get_rows() return _rows;
	
	private var _cols:Int;
	public var cols(get, never):Int;
	function get_cols() return _cols;
	
	private var _tiles:Array<Tile>;
	
	public function new() 
	{
		if(_internallyCalled){
            _internallyCalled=false;
        }else{
            throw "TilesController es un singleton.";
        }
	}
	
	public function start(columns:Int, rows:Int) 
	{	
		_rows = rows;
		_cols = columns;
		
		var texture = Luxe.resources.textures.get('assets/img/tile_idle.jpg');		
		texture.filter = FilterType.nearest;
		
		var tile_offset:Vector = new Vector(texture.width * .5, texture.height * .5);
		var screen_offset:Vector = new Vector((Luxe.screen.w - (texture.width * _cols)) * .5, (Luxe.screen.h - (texture.height * _rows)) * .5);
		
		_tiles = new Array<Tile>();
		
		for (j in 0..._rows) {
			for (i in 0..._cols) {
				var t = new Tile(j * _cols + i, texture);
				t.setPosition(i * texture.width + tile_offset.x + screen_offset.x, j*texture.height + tile_offset.y + screen_offset.y);
				_tiles.push(t);
			}
		}
	}
	
	public function get_tile_by_pos(i:Int, j:Int):Tile
	{
		return _tiles[j * _cols + i];
	}
}