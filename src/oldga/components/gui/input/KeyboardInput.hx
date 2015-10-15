package components.gui.input;
import luxe.Input.Key;
import luxe.Input.KeyEvent;

/**
 * ...
 * @author Carmon
 */
class KeyboardInput extends Input
{
	public function new() 
	{
		super();
	}
	
	override public function onkeyup(event:KeyEvent) 
	{	
		if (_screenType == Input.SCREEN_SELECT) {
			switch(event.keycode) {
				case Key.up:
					_screen_select.moveBack();
				case Key.key_w:
					_screen_select.moveBack();
				case Key.left:
					_screen_select.moveBack();
				case Key.key_a:
					_screen_select.moveBack();
				case Key.down:
					_screen_select.moveNext();
				case Key.key_s:
					_screen_select.moveNext();	
				case Key.right:
					_screen_select.moveNext();	
				case Key.key_d:
					_screen_select.moveNext();		
			}
		}
	}
	
	override public function onkeydown(event:KeyEvent) 
	{
		if (event.keycode == Key.enter || event.keycode == Key.kp_enter) {				
			switch(_screenType) {
				case Input.SCREEN_SELECT:	
					_screen_select.select();
				case Input.SCREEN_READY:
					_screen_ready.back();
			}
		}		
	}
}