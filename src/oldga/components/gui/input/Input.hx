package components.gui.input;
import entities.gui.screens.ReadyScreen;
import entities.gui.screens.SelectScreen;
import luxe.Component;
import luxe.options.ComponentOptions;

/**
 * ...
 * @author Carmon
 */
class Input extends Component
{
	private var _screenType:Int;
	
	private static inline var SCREEN_SELECT	:Int = 1;
	private static inline var SCREEN_READY	:Int = 2;
	
	private var _screen_select	:SelectScreen;
	private var _screen_ready	:ReadyScreen;

	public function new(?_options:ComponentOptions) 
	{		
		super({ name: 'Input' });		
	}
	
	override public function onadded() 
	{
		switch(Type.getClass(entity)) {			
			case SelectScreen:
				_screenType 	= SCREEN_SELECT;
				_screen_select 	= cast(entity, SelectScreen);
			case ReadyScreen:
				_screenType 	= SCREEN_READY;
				_screen_ready 	= cast(entity, ReadyScreen);
		}
	}
}