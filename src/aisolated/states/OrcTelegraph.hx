package states;

import config.GameController;
import entities.Cable;
import entities.GameUI;
import entities.Player;
import luxe.Input.Key;
import luxe.options.StateOptions;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States.State;
import managers.CableManager;
import managers.TilesManager;
import managers.TimeManager;
import phoenix.Color;
import phoenix.Vector;
import ui.debug.DebugDraw;

/**
 * ...
 * @author Carmon
 */
class OrcTelegraph extends State
{
	//Prototipo para indies-vs-gamers: runner hombro telegrafo
	
	var isReady:Bool;
	var isPaused:Bool;
	
	var game_controller:GameController;
	
	var game_ui:GameUI;
	
    var player 	:Player;
	var cable	:Cable;
	
	var cableManager:CableManager;
	var tiles:TilesManager;

	public function new() 
	{
		super( { name: 'telegraph' } );
	}
	
	override public function onenter(_) 
	{
		isReady = false;
		
		Luxe.loadJSON('assets/parcel.json', function(json_asset) {
			
            var preload = new Parcel();
                preload.from_json(json_asset.json);
				
            new ParcelProgress({
                parcel      : preload,
                background  : new Color(1,1,1,0.85),
                oncomplete  : assets_loaded
            });
			
            preload.load();
        });
	}
	
	function assets_loaded(_) 
	{		
		create_controllers();
        connect_input();
    } //assets_loaded
	
	function create_controllers() 
	{
		isPaused = true;
		
		game_controller = new GameController();
		
		cableManager = new CableManager();
		player = new Player();
		cable = cableManager.getNextCable();
		player.setCable(cable);
		player.on_action = on_player_action_handler;
		
		game_ui = new GameUI();
		
		tiles = new TilesManager();		
		
		DebugDraw.getInstance();
		
		isPaused = false;
		isReady = true;
		
	} //create_assets
	
	function on_player_action_handler(target:Vector)
	{
		if (tiles.checkPutting(target)) {
			cableManager.createPilar(target);
			game_controller.totalScore += Math.round(cable.getLengthX());
			cable = cableManager.getNextCable();
			player.setCable(cable);
			TimeManager.instance.resetAction();
		}
	}
	
    function connect_input() {
		
        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('down', Key.down);
		
		Luxe.input.bind_key('action', Key.key_z);		
		Luxe.input.bind_key('jump', Key.key_x);
		
		Luxe.input.bind_key('reset', Key.key_r);
		
	} //connect_input
	
    override function update( delta:Float ) 
	{		
		if (!isReady) return;
		
		if (!isPaused) {
			TimeManager.instance.update();
			
			game_controller.currentScore = Math.round(cable.getLengthX());
			
			tiles.update();
			cableManager.update();
		}
		
		if (Luxe.input.inputdown('reset')) {
			isPaused = true;
			Luxe.camera.pos.x = 0;
			TimeManager.instance.reset();
			tiles.reset();
			player.reset();
			cableManager.reset();
			cable = cableManager.getNextCable();
			player.setCable(cable);
			isPaused = false;
		}
		
    } //update
}