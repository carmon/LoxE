package managers;

import components.game.control.Control;
import components.game.control.GamepadControl;
import components.game.control.KeyboardControl;
import luxe.Entity;
import luxe.Entity;
import luxe.Input.GamepadEvent;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Log.log;

/**
 * ...
 * @author Carmon
 */
class InputManager extends Entity
{
	private var _slotsFilled:Array<Int>;
	
	private var _availableSlots	:Int;
	
	private static var _slot:Int = 0;
	
	private var _on_input_enter:Control->Void;
	public var on_input_enter(never, set):Control -> Void;
	private function set_on_input_enter(value:Control->Void)
	{
		_on_input_enter = value;
		return value;
	}
		
	public function new(availableSlots:Int) 
	{
		super( { name: 'InputManager' } );
		
		_slotsFilled = new Array<Int>();
		_availableSlots = availableSlots;
	}
	
	override public function onkeyup(event:KeyEvent) 
	{	
		//log("key:: " + event.keycode);
		if (event.keycode == 13 && Lambda.indexOf(_slotsFilled, event.keycode) == -1) {
			_slotsFilled.push(event.keycode);
			_on_input_enter(new KeyboardControl());
			_slot++;
		}
	}
	
	override public function ongamepadup(event:GamepadEvent) 
	{		
		if (event.button == 0 && Lambda.indexOf(_slotsFilled, event.gamepad) == -1) {
			_slotsFilled.push(event.gamepad);
			_on_input_enter(new GamepadControl(event.gamepad));
			_slot++;
		}
	}
		
	override public function destroy(?_from_parent:Bool=false) 
	{
		_on_input_enter = null;
		super.destroy(_from_parent);
	}
}