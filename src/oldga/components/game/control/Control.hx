package components.game.control;

import components.game.weapons.Weapon;
import entities.game.Player;
import luxe.Component;
import luxe.options.ComponentOptions;

/**
 * ...
 * @author Carmon
 */
class Control extends Component
{
	public var type:String = "Control";
	
	private var _player:Player;
	private var _weapon:Weapon;

	public function new(?_options:ComponentOptions) 
	{
		super({ name: 'Control' });		
	}
	
	override public function onadded() 
	{
		_player = cast entity;
		_weapon = cast get('Weapon');
	}
}