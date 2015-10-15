package config;
import entities.Player;
import luxe.Entity;
import phoenix.Batcher;
import phoenix.Camera;

/**
 * ...
 * @author Carmon
 */
class GameController extends Entity
{
	public var totalScore:Int;
	public var currentScore:Int;
	
	public var lockScroll:Bool;
	public var ui_batcher:Batcher;
	
	private var _player:Player;
	
	public function new() 
	{
		super( {
			name: "GameController"
		});
		
		ui_batcher = new Batcher(Luxe.renderer, 'ui_batcher');
		ui_batcher.view = new Camera();
		ui_batcher.layer = 2;
		Luxe.renderer.add_batch(ui_batcher);
		
		Luxe.events.listen('player.created', on_player_created);
		
		reset();
	}
	
	private function on_player_created(_)
	{
		_player = cast Luxe.scene.entities.get('player');		
	}
	
	override public function update(dt:Float) 
	{
		if (_player == null) return;
		var player_x:Float = _player.pos.x;
		if (lockScroll){
			var camera_x:Float = Luxe.camera.pos.x;
			if (player_x - camera_x > Defines.CAMERA_LIMIT) {
				Luxe.events.fire('time.reset_scroll');
				Luxe.camera.pos.x = player_x - Defines.CAMERA_LIMIT;
			}
		} else {
			lockScroll = player_x > Defines.CAMERA_LIMIT;
		}
	}
	
	public function reset()
	{
		lockScroll = false;
		currentScore = totalScore = 0;
	}
}