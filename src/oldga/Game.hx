package;
import luxe.States;
import options.GameOptions;
import states.Loading;
import states.Menu;
import states.Playing;

/**
 * ...
 * @author Carmon
 */
class Game
{
	private inline static var TYPE_FIRST_OF	:Int = 1;
	private inline static var TYPE_MOST_WINS:Int = 2;
	
	public var states:States;
	
	private var _gameOptions:GameOptions;

	public function new() 
	{
		_gameOptions = {
			rounds_needed: 3,
			game_type: TYPE_FIRST_OF
		};
		
		states = new States( { name:'machine' } );
		
		states.add(new Loading());
		states.add(new Menu());
		states.add(new Playing());		
		
		Luxe.on(init, function (_) {
			states.set('loading');
		}); 
	}
	
	
	
}