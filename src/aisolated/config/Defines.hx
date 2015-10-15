package config;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Defines
{	
	public static var HORIZON:Int = 240;
	
	public static var TIMER_SECONDS:Int = 5;
	
	public static var TILE_TYPE_COMMON	:Int = 0;
	public static var TILE_TYPE_UNCOMMON:Int = 1;
	public static var TILE_TYPE_RARE	:Int = 2;
	
	public static var TILE_0_GRAL_PROB:Float = 1;
	public static var TILE_1_GRAL_PROB:Float = .5;
	public static var TILE_2_GRAL_PROB:Float = .25;
	
	public static var TILE_0_TYPE_PROB:Vector = new Vector(.2, .2);
	public static var TILE_1_TYPE_PROB:Vector = new Vector(.4, .6);
	public static var TILE_2_TYPE_PROB:Vector = new Vector(.8, .4);
	
	public static var TILE_SIZE:Int = 40;
	public static var TILES_HEIGHT:Int = 9;
	public static var TILES_WIDTH:Int = 20;
	
	public static var PILAR_FRAME_WIDTH:Int = 24;
	
	public static var GAME_WIDTH:Int = 800;
	public static var GAME_HEIGHT:Int = 600;
	
	public static var DEPTH_TILE:Float = 0;
	public static var DEPTH_SEGMENT:Float = 2.5;
	public static var DEPTH_PLAYER:Float = 1.1;
	public static var DEPTH_PILAR:Float = 0.5;
	
	public static var PLAYER_FRAME_WIDTH:Int = 40;
	public static var PLAYER_FRAME_HEIGHT:Int = 100;
	
	public static var CABLE_OFFSET:Int = 6;
	public static var CABLE_TICKNESS:Int = 2;
	public static var CABLE_SEGMENTS:Int = 12;
	public static var CABLE_MAX_LENGTH:Int = 320;
	
	public static var CAMERA_LIMIT(get, never):Float;
	public static function get_CAMERA_LIMIT():Float
	{
		return Luxe.screen.mid.x;
	}
}