package components.game.control;

import components.game.weapons.Weapon;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class KeyboardControl extends Control
{

	public function new() 
	{
		super();
	}
	
	override public function onkeyup(event:KeyEvent) 
	{	
		if (_player!=null && _player.isBusy()) return;
		var dir:Vector = new Vector();
		switch(event.keycode) {
			case Key.enter:
				_player.callPause();
		}
		_player.idle(dir);
	}
	
	override public function onkeydown(event:KeyEvent) 
	{
		if (_player!=null && _player.isBusy()) return;
		var dir:Vector = new Vector();
		switch(event.keycode) {
			case Key.up:
				dir.y = -1;
			case Key.down:
				dir.y = 1;
			case Key.left:
				dir.x = -1;
			case Key.right:
				dir.x = 1;
			case Key.key_z:
				_player.attack();
			case Key.key_x:
				_player.jump();
		}
		if (dir.length > 0) {
			_player.lean(dir);
		}
	}
}