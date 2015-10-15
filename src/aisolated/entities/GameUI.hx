package entities;

import config.GameController;
import luxe.Entity;
import phoenix.Color;
import phoenix.geometry.TextGeometry;
import phoenix.Vector;
import ui.ActionArrow;
import ui.NextArrow;

/**
 * ...
 * @author Carmon
 */
class GameUI extends Entity
{
	private var _next_arrow:NextArrow;
	private var _action_arrow:ActionArrow;
	private var _game_controller:GameController;

	public function new() 
	{
		super( {
			name: "GameUI"
		});
		
		_next_arrow = new NextArrow();
		_action_arrow = new ActionArrow();
		
		_game_controller = cast Luxe.scene.entities.get("GameController");
		
		Luxe.events.listen('ui.next_arrow', on_next_arrow);
		Luxe.events.listen('ui.action_arrow', on_action_arrow);
	}
	
	override public function update(dt:Float) 
	{
		var geom:TextGeometry = Luxe.draw.text( {
			batcher : _game_controller.ui_batcher,
            immediate : true,
            pos: this.pos,
            color:new Color().rgb(0xff4b03),
			point_size: 30,
            text : 'Score:: ' + _game_controller.totalScore
		});
		Luxe.draw.text( {
			batcher : _game_controller.ui_batcher,
            immediate : true,
            pos: new Vector(this.pos.x + geom.text_width, this.pos.y),
            color:new Color().rgb(0x035cff),
			point_size: 30,
            text : '+' + _game_controller.currentScore
		});
		/*
		Luxe.draw.text( {
			batcher : VisualManager.instance.hud_batcher,
            immediate : true,
            pos: new Vector(this.pos.x, this.pos.y + 20),
            color:new Color().rgb(0xff4b03),
			point_size: 20,
            text : 'Time:: Session: ' + TimeManager.instance.sesionTime + ' Scroll: ' + TimeManager.instance.scrollTime + ' Action: ' + TimeManager.instance.actionTime
		});
		*/
		Luxe.draw.text( {
			batcher : _game_controller.ui_batcher,
            immediate : true,
            pos: new Vector(0, Luxe.screen.h - 35),
            color:new Color().rgb(0xff4b03),
			point_size: 35,
            text : ""+Math.round(1 / dt)
		});
	}
	
	private function on_next_arrow(_)
	{
		if(_next_arrow.isReady()) _next_arrow.call();
	}
	
	private function on_action_arrow(_)
	{
		if (_action_arrow.isReady()) _action_arrow.call();
	}
}