package components.gui.input;

import luxe.Input.GamepadEvent;
import luxe.options.ComponentOptions;

/**
 * ...
 * @author Carmon
 */
class GamepadInput extends Input
{
	private var _gamepad_id:Int;
	
	public function new(gamepad_id:Int) 
	{
		super();
		_gamepad_id = gamepad_id;		
	}
	
	override public function ongamepadaxis(event:GamepadEvent) 
	{
		if (event.gamepad == _gamepad_id) {
			if (Math.abs(event.value) > 0.2) {				
				switch(event.axis) {
					case 0:
						if (event.value == -1) _screen_select.moveBack();
						else if (event.value == 1) _screen_select.moveNext();
					case 1:
						if (event.value <= -0.9) _screen_select.moveBack();
						else if (event.value == 1) _screen_select.moveNext();
					case 2:					
						if (event.value == -1) _screen_select.moveBack();
						else if (event.value == 1) _screen_select.moveNext();
					case 3:
						if (event.value <= -0.9) _screen_select.moveBack();
						else if (event.value == 1) _screen_select.moveNext();						
				}
			}
		}
	}
	
	override public function ongamepadup(event:GamepadEvent) 
	{
		if (event.gamepad == _gamepad_id) {
			if (event.button == 0) {			
				switch(_screenType) {
					case Input.SCREEN_SELECT:
						_screen_select.select();
					case Input.SCREEN_READY:
						_screen_ready.back();
				}
			} else if (event.button == 1) {
				if (_screenType == Input.SCREEN_READY)
					_screen_ready.back();
			}
		}		
	}
}