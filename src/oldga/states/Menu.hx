package states;
import components.game.control.Control;
import entities.gui.PausePopup;
import entities.gui.PlayerMenu;
import luxe.Log.log;
import luxe.States.State;
import luxe.Visual;
import managers.InputManager;
import options.PlayerOptions;
import phoenix.Texture;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Menu extends State
{
	private static var TOTAL_PLAYERS:Int = 2;
	
	private var _logo:Visual;
	private var _inputManager:InputManager;
	
	private var _currentPlayers:Int;
	private var _GUIs:Array<PlayerMenu>;
	
	public function new() 
	{
		super({name: 'menu'});
	}
	
	override public function onenter<T>(ignored:T)
	{		
		var image:Texture = Luxe.resources.textures.get('assets/img/logo.png');
		image.filter = FilterType.nearest;
		_logo = new Visual( {
			texture: image,
			pos: new Vector(Luxe.screen.mid.x - image.width*.5, Luxe.screen.mid.y - image.height*.5)
		} );
		
		_currentPlayers = 0;		
		_GUIs = new Array<PlayerMenu>();
		for (i in 0...TOTAL_PLAYERS) {
			var gui:PlayerMenu = new PlayerMenu(i, {
				name: 'PlayerConfigGUI_' + i,
				size: new Vector(Luxe.screen.w / TOTAL_PLAYERS, Luxe.screen.h),
				pos: new Vector((Luxe.screen.w / TOTAL_PLAYERS) * i, 0)
			});
			_GUIs.push(gui);
		}
		
		_inputManager = new InputManager(TOTAL_PLAYERS);
		_inputManager.on_input_enter = input_enter_handler;
	}
	
	private function input_enter_handler(c:Control)
	{
		_GUIs[_currentPlayers].add_control(c);
		_currentPlayers++;
	}
	
	override public function update(dt:Float) 
	{
		super.update(dt);
		
		var temp:Array<PlayerMenu> = new Array<PlayerMenu>();
		for (i in 0..._GUIs.length) {
			if (_GUIs[i].isReady) temp.push(_GUIs[i]);
		}
		if (temp.length == TOTAL_PLAYERS) {
			machine.set('playing', temp);
		}
	}
	
	override public function onleave<T>(ignored:T) 
	{
		//log('onleave menu');
		_logo.destroy();
		_logo = null;
		
		for (i in 0..._GUIs.length) {
			_GUIs[i].destroy();
			_GUIs[i] = null;
		}
		_GUIs = null;
		
		_inputManager.destroy();
		_inputManager.on_input_enter = null;
		_inputManager = null;
	}
}