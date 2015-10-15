package components.game.control;

import components.game.weapons.Weapon;
import luxe.Input.GamepadEvent;
import luxe.Vector;
import luxe.Log.log;

/**
 * ...
 * @author Carmon
 */
class GamepadControl extends Control
{
	public var gamepad_id(get, never):Int;
	private function get_gamepad_id():Int
	{
		return _gamepad_id;
	}
	
	private var _gamepad_id:Int;
	private var _current_lean_axis:Int;

	public function new(gamepad_id:Int) 
	{
		super();
		_gamepad_id = gamepad_id;
	}
	
	override public function ongamepadaxis(event:GamepadEvent) 
	{				
		log('axis; device: '+event.gamepad+', axis: '+event.axis+', value: '+event.value+' timestamp: '+event.timestamp);
		if (event.gamepad == _gamepad_id) {
			if (Math.abs(event.value) > 0.2) {
				if (_player != null && _player.isBusy()) return;
				var dir:Vector = new Vector();
				switch(event.axis) {
					case 0:
						if (event.value == -1) dir.x = -1;
						else if (event.value == 1) dir.x = 1;
					case 1:
						if (event.value <= -0.9) dir.y = -1;
						else if (event.value == 1) dir.y = 1;
				}
				if (dir.length > 0) {
					_current_lean_axis = event.axis;
					_player.lean(dir);
				}
				
				//TO KNOW:		
				//Stick 1:
				//x: -1 a 1 axis 0 
				//y: -0.99 a 1 axis 1 
				
				//Stick 2:
				//x: -1 a 1 axis 2
				//y: -0.99 a 1 axis 3
			}		
		}
	}
	
	override public function update(dt:Float) 
	{
		if (_player!=null && _player.isBusy()) return;
		var current_axis_value:Float = Luxe.input.gamepadaxis(_gamepad_id, _current_lean_axis);
		if (Math.abs(current_axis_value) < 0.2) _player.idle(new Vector());
	}
	
	override public function ongamepaddown(event:GamepadEvent) 
	{
		log("ongamepaddown "+event.axis+" "+event.value+" "+event.timestamp);
	}
	
	override public function ongamepadup(event:GamepadEvent) 
	{
		if (event.gamepad == _gamepad_id) {
			if (_player!=null && _player.isBusy()) return;
			var dir:Vector = new Vector();            
			switch(event.button) {
				case 0:
					_player.attack();
				case 1:
					_player.jump();
                case 6:
                    _player.callPause();
            }
			_player.idle(dir);
		}
		log("ongamepadup "+event.axis+" "+event.value+" "+event.button);
	}
	
	override public function ongamepaddevice(event:GamepadEvent) 
	{
		//log("ongamepaddevice "+event.axis+" "+event.value+" "+event.timestamp);
	}	
}