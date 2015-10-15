package managers;
import config.Defines;
import entities.Player;
import phoenix.Vector;
import entities.Cable;
import ui.Pilar;

/**
 * ...
 * @author Carmon
 */
class CableManager
{	
	private var _total_cables:Int = 0;
	private var _total_pilars:Int = 0;
	
	private var _player:Player;
	
	private var _cables:Array<Cable>;
	private var _pilars:Array<Pilar>;

	public function new() 
	{
		_cables = new Array<Cable>();
		_pilars = new Array<Pilar>();
		
		Luxe.events.listen('player.created', on_player_created);
	}
	
	private function on_player_created(_)
	{
		_player = cast Luxe.scene.entities.get('player');
	}
	
	public function reset():Void
	{
		for (i in 0..._cables.length) {
			_cables[i].destroy();
			_cables[i] = null;
		}
		_cables = new Array<Cable>();
		_total_cables = 0;
		
		for (i in 0..._pilars.length) {
			_pilars[i].destroy();
			_pilars[i] = null;
		}
		_pilars = new Array<Pilar>();
		_total_pilars = 0;
	}
	
	public function update():Void
	{
		if (_pilars.length > 0 && _pilars[0].getPivot().x + Defines.PILAR_FRAME_WIDTH < Luxe.camera.pos.x) {
			var c:Cable = _cables.shift();
			c.destroy();
			c = null;
			var p:Pilar = _pilars.shift();
			p.destroy();
			p = null;
		}
		for (i in 0..._cables.length) {
			if (_cables[i].getEnd() != null) {
				if (i == _cables.length - 1) {
					//trace("ulti call");
					_cables[i].draw();
				}
				else {
					if (!_cables[i].quiet) {
						//trace("otro call");
						_cables[i].draw();
					}
				}
			}
		}
	}
	
	public function getNextCable():Cable
	{
		var init:Vector;
		if (_cables.length == 0) {
			init = new Vector(0, Luxe.screen.mid.y + Defines.PLAYER_FRAME_HEIGHT);
		} else {
			init = _cables[_cables.length - 1].getEnd();
		}
		var c:Cable = new Cable('cable_' + _total_cables, init);
		_total_cables++;
		_cables.push(c);
		return c;
	}
	
	public function createPilar(target:Vector):Void
	{
		var p:Pilar = new Pilar( {
			name: 'pilar_' + _total_pilars,
			pos: target
		});
		_total_pilars++;
		_cables[_cables.length - 1].setEnd(p.getPivot());
		_cables[_cables.length - 1].quiet = true;
		_pilars.push(p);
	}
}