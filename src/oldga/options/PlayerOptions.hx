package options;
import components.game.control.Control;
import components.game.weapons.Weapon;
import luxe.options.SpriteOptions;

/**
 * @author Carmon
 */

typedef PlayerOptions =
{
	> SpriteOptions,
	
	var id:Int;
	
	@:optional var control:Control;
	@:optional var weapon:Weapon;
}