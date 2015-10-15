package;
import luxe.States;
import states.DonMap;
import states.F88;
//import states.OrcTelegraph;

/**
 * ...
 * @author Carmon	
 */
class Game
{
	private var _states:States;

	public function new() 
	{
		_states = new States( { name: 'machine' } );
		
		//_states.add(new OrcTelegraph());
		//_states.add(new DonMap());
		_states.add(new F88());
		
		Luxe.on(init, function (_) {
			//_states.set('telegraph');
			//_states.set('don.map');
			_states.set('f88.main');
		}); 
	}
	
	
}