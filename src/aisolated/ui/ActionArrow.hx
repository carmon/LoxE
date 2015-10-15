package ui;
import config.GameController;
import entities.Player;
import luxe.Sprite;
import phoenix.Texture.FilterType;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class ActionArrow extends Sprite
{
	private var _game_controller:GameController;
	private var _player:Player;
	
	private var _count:Int;
	private var _ready:Bool;

	public function new() 
	{
		var image = Luxe.loadTexture('assets/arrow_action.png');
		image.filter = FilterType.nearest;
		
		_count = 0;
		
		_game_controller = cast Luxe.scene.entities.get('GameController');
		
		super( {
			name: 'arrow_action',
            texture: image,
			size: new Vector(image.width, image.height),
			batcher: _game_controller.ui_batcher,
			visible: false
		});
		
		_player = cast Luxe.scene.entities.get('player');
		
		//_ready = true;
	}
	
	public function call()
	{
		_ready = false;
		var player_pos:Vector = _player.pos;
		if (_game_controller.lockScroll) {
			pos = new Vector(player_pos.x - Luxe.camera.pos.x, player_pos.y + size.y * 3);
		} else pos = new Vector(player_pos.x, player_pos.y + size.y * 3);
		show();		
	}
	
	private function show()
	{
		visible = true;
		Luxe.timer.schedule(1, hide);
	}
	
	private function hide()
	{
		visible = false;
		_count++;
		if (_count == 3) Luxe.timer.schedule(1, end);
		else Luxe.timer.schedule(1, show);
	}
	
	private function end()
	{
		_ready = true;
	}
	
	public function isReady():Bool
	{
		return _ready;
	}
}