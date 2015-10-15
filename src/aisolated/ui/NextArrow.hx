package ui;
import luxe.Sound;
import luxe.Sprite;
import phoenix.Texture.FilterType;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class NextArrow extends Sprite
{
	private var _count:Int;
	private var _ready:Bool;

	private var _fx:Sound;
	
	public function new() 
	{
		var image = Luxe.loadTexture('assets/arrow_next.png');
		image.filter = FilterType.nearest;
		
		_count = 0;
		
		super( {
			name: "next_arrow",
            texture: image,
			centered: false,
			pos: new Vector(Luxe.screen.size.x - image.width - 20, 150),
			size: new Vector(image.width, image.height),
			batcher: cast Luxe.scene.entities.get('ui_batcher'),
			visible: false
		});
		
		_fx = Luxe.audio.create('assets/sounds/arrow_next_bip.wav', 'next_arrow_bip');
		
		_ready = true;
	}
	
	public function isReady():Bool
	{
		return _ready;
	}
	
	public function call()
	{
		_ready = false;
		show();
	}
	
	private function show()
	{		
		visible = true;
		_fx.play();
		Luxe.timer.schedule(1, hide);
	}
	
	private function hide()
	{
		visible = false;
		_count++;
		if (_count == 3) Luxe.timer.schedule(1, end);
		else Luxe.timer.schedule(1, show);
	}
	
	private function end()
	{
		_ready = true;
	}
}