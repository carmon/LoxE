package states;

import haxe.ds.Vector;
import luxe.Log.log;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States.State;
import luxe.Text;
import luxe.Visual;
import phoenix.Color;
import phoenix.Rectangle;
import phoenix.Texture;

/**
 * ...
 * @author Carmon
 */
class Loading extends State
{	
	//private var _text :Text;
	
	public function new(isDebug:Bool = true) 
	{
		super( { name: 'loading' } );
		
		/*
		if (isDebug) {
			_text = new Text({
				bounds : new Rectangle(0, 0, Luxe.screen.size.x, Luxe.screen.size.y),
				bounds_wrap : true,
				align : center,
				align_vertical: bottom,
				color: new Color(1,1,1,1),
                batcher: Luxe.renderer.batcher,
                point_size: 20,
			});
		}
		*/
	}
	
	override public function onenter<T>(ignored:T) 
	{		
		//_text.text = 'onenter_loading';
		log('onenter_loading');
		
		var image:Texture = Luxe.loadTexture("assets/img/logo.png");
		image.onload = on_logo_loaded;
	}
	
	function on_logo_loaded(t:Texture = null )
	{		
		//_text.text = 'on_logo_loaded';
		log('on_logo_loaded');
		
		Luxe.loadJSON('assets/json/parcel.json', function(json_asset) 
		{			
			var preload = new Parcel({silent: false});
			preload.from_json(json_asset.json);
			
			new ParcelProgress( {
				parcel : preload,
				texture : t,
				oncomplete : assets_loaded
			});
			
			preload.load();			
		});			
	}
	
	function assets_loaded(p:Parcel) 
	{		
		//_text.text = 'assets_loaded';
		log('assets_loaded');
		
		machine.set('menu');
	}
	
	override public function onleave<T>(ignored:T) 
	{
		//_text.text = 'onleave_loading';
		log('onleave_loading');
		
		super.destroy();
	}
	
}