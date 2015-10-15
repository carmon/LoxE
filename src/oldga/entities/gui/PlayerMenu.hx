package entities.gui;

import components.game.control.Control;
import components.game.control.GamepadControl;
import components.game.control.KeyboardControl;
import components.game.weapons.Weapon;
import components.gui.input.GamepadInput;
import components.gui.input.Input;
import components.gui.input.KeyboardInput;
import entities.gui.screens.IdleScreen;
import entities.gui.screens.PlayingScreen;
import entities.gui.screens.ReadyScreen;
import entities.gui.util.UIAlign;
import entities.gui.screens.SelectScreen;
import luxe.Log;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import options.PlayerOptions;
import phoenix.BitmapFont.TextAlign;

/**
 * ...
 * @author Carmon
 */
enum State {
	Press;
	Select;
	Ready;
	Playing;
	Result;
}
	
class PlayerMenu extends Sprite
{
	private var _id:Int;
	private var _state:State;
	private var _screen:Sprite;
	private var _input:Input;
	
	private var _config:PlayerOptions;
	public var config(get, never):PlayerOptions;
	private function get_config():PlayerOptions
	{
		return _config;
	}
	
	public var isReady(get, never):Bool;
	private function get_isReady():Bool
	{
		return _state == State.Ready;
	}

	public function new(id:Int, options:SpriteOptions) 
	{
		_id = id;
		super(options);
	}
	
	override public function init() 
	{			
		set_state(State.Press);
	}
		
	public function add_control(c:Control)
	{
		_config = {
			id: _id,
			control: c
		};
		switch(Type.getClass(c)) {
			case KeyboardControl:
				_input = new KeyboardInput();
			case GamepadControl:
				_input = new GamepadInput(cast(c, GamepadControl).gamepad_id);
		}
		set_state(State.Select);
	}
	
	private function handle_class_selected(w:Weapon)
	{
		_config.weapon = w;
		set_state(State.Ready);
	}
	
	private function handle_ready_back()
	{
		_config.weapon = null;		
		set_state(State.Select);
	}
	
	private function set_state(s:State)
	{
		_state = s;
		var align:UIAlign = return_align();
		switch(_state) {
			case Press:
				_screen = new IdleScreen(align, {
					name: 'IdleScreen_' + _id,
					size: size,
					pos: pos
				});
			case Select:
				_screen.destroy(true);
				_screen = null;
				_screen = new SelectScreen(align, {
					name: 'SelectScreen_' + _id,
					size: size,
					pos: pos
				});
				cast(_screen, SelectScreen).on_selected = handle_class_selected;
				_screen.add(_input);
			case Ready:
				_screen.remove(_input.name);
				_screen.destroy(true);
				_screen = null;
				_screen = new ReadyScreen(align, {
					name: 'ReadyScreen_' + _id,
					size: size,
					pos: pos
				});
				cast(_screen, ReadyScreen).on_back = handle_ready_back;
				_screen.add(_input);
			case Playing:
				_screen.destroy(true);
				_screen = null;
				_screen = new PlayingScreen(align, {
					name: 'ReadyScreen_' + _id,
					size: size,
					pos: pos
				});				
			case Result:
				return;
		}
	}
	
	override public function destroy(?_from_parent:Bool = false) 
	{
		_screen.destroy(true);
		_screen = null;
		
		super.destroy(_from_parent);
	}
	
	private function return_align():UIAlign
	{
		switch(_id) {
			case 0:
				return {h: TextAlign.left, v: TextAlign.center};
			case 1:
				return {h: TextAlign.right, v: TextAlign.center};
		}
		return {h: TextAlign.left, v: TextAlign.center};
	}
}