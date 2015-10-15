package managers;
import config.Defines;
import luxe.Sprite;
import phoenix.Texture.FilterType;
import phoenix.Vector;
import entities.Player;

/**
 * ...
 * @author Carmon
 */
class TimeManager
{
	private static var _instance:TimeManager = null;
	public static var instance(get, never):TimeManager;
	private static function get_instance():TimeManager
	{
		if (_instance == null) _instance = new TimeManager();
		return _instance;
	}
	
	public var _arrow_action:Sprite;
	
	private var _scrollTime:Float;
	public var scrollTime(get, never):Float;
	private function get_scrollTime():Float
	{
		return Math.round(_scrollTime);
	}
	
	private var _actionTime:Float;
	public var actionTime(get, never):Float;
	private function get_actionTime():Float
	{
		return Math.round(_actionTime);
	}
	
	private var _sesionTime:Float;
	public var sesionTime(get, never):Float;
	private function get_sesionTime():Float
	{
		return Math.round(_sesionTime);
	}
	
	public function new()
	{
		Luxe.events.listen('time.reset_scroll', on_reset_scroll);
		
		reset();
	}
	
	public function reset()
	{
		_sesionTime = _scrollTime = _actionTime = 0;
	}
	
	private function on_reset_scroll(_)
	{
		_scrollTime = 0;
	}
	
	public function resetAction()
	{
		_actionTime = 0;
	}
	
	public function update() 
	{
		var dt:Float = Luxe.dt;
		_sesionTime += dt;
		_scrollTime += dt;
		_actionTime += dt;
		
		if (_scrollTime > Defines.TIMER_SECONDS) {
			Luxe.events.fire('ui.next_arrow');
		}
		if (_actionTime > Defines.TIMER_SECONDS) {
			Luxe.events.fire('ui.action_arrow');
		}
	}	
}