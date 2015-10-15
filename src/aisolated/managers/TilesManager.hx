package managers;

import config.Defines;
import haxe.Log;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture.FilterType;
import ui.Tile;

/**
 * ...
 * @author Carmon
 */
class TilesManager
{	
	private var _ready:Bool;
	private var _offset:Int;
	private var _tile_grid:Array<Array<Tile>>;

	public function new() 
	{
		_ready = false;
		_offset = 0;
		_tile_grid = new Array<Array<Tile>>();
		
		var image = Luxe.loadTexture('assets/tileset.png');
		image.filter = FilterType.nearest;
		
		for (j in 0...Defines.TILES_WIDTH + 1) {
			var col:Array<Tile> = new Array<Tile>();
			for (i in 0...Defines.TILES_HEIGHT) {
				var precedent_x:Int = -1;
				var precedent_y:Int = -1;
				if (j > 0) precedent_x = _tile_grid[j - 1][i].type;
				if (i > 0) precedent_y = col[i - 1].type;
				col.push(
					new Tile(
						"tile_" + (j * Defines.TILES_HEIGHT + i), image, 
						new Vector((j * Defines.TILE_SIZE), Defines.HORIZON + (i * Defines.TILE_SIZE)),
						precedent_x, precedent_y
					)
				);				
			}
			_tile_grid.push(col);
		}
		
		_ready = true;
	}
	
	public function reset():Void
	{
		for (j in 0..._tile_grid.length) {
			var col:Array<Tile> = _tile_grid[j];
			for (i in 0...col.length) {
				var precedent_x:Int = -1;
				var precedent_y:Int = -1;
				if (j > 0) precedent_x = _tile_grid[j - 1][i].type;
				if (i > 0) precedent_y = col[i - 1].type;
				col[i].pos.x = j * Defines.TILE_SIZE;
				col[i].resetType(precedent_x, precedent_y);
			}
		}		
	}
	
	public function update():Void
	{
		//if (_ready) {			
			var col:Array<Tile> = _tile_grid[0];			
			if (_tile_grid[0][0].pos.x + Defines.TILE_SIZE < Luxe.camera.pos.x) {				
				//_ready = false;
				for (i in 0...col.length) {				
					var precedent_x:Int = _tile_grid[_tile_grid.length - 1][i].type;
					var precedent_y:Int = -1;
					if (i > 0) precedent_y = col[i - 1].type;					
					col[i].pos.x += Defines.GAME_WIDTH + Defines.TILE_SIZE;
					col[i].resetType(precedent_x, precedent_y);
				}
				_tile_grid.push(_tile_grid.shift());
				_offset++;
				//_ready = true;
			}
		//}
	}
	
	public function checkPutting(target:Vector):Bool
	{
		var offset:Int = _offset * Defines.TILE_SIZE;
		var coord_x:Int = Math.floor((target.x - (Luxe.camera.pos.x - offset)) / Defines.TILE_SIZE);
		var coord_y:Int = Math.floor((target.y - Defines.HORIZON) / Defines.TILE_SIZE);
		return _tile_grid[coord_x-_offset][coord_y].type != Defines.TILE_TYPE_RARE;
	}
}