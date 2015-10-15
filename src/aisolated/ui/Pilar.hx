package ui;
import config.Defines;
import luxe.Color;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Vector;
import phoenix.geometry.CircleGeometry;
import phoenix.Texture.FilterType;
import ui.debug.DebugDraw;

/**
 * ...
 * @author Carmon
 */
class Pilar extends Sprite
{
	private var _guia:Vector;

  	public function new(options:SpriteOptions) 
	{
		var image = Luxe.loadTexture('assets/poste.png');
		image.filter = FilterType.nearest;
		
		super({
            name: options.name,
            texture: image,
			pos: new Vector(options.pos.x, options.pos.y - image.height * .5),
			depth: 2,
            size: new Vector( image.width, image.height )
        });
		
		_guia = new Vector(options.pos.x, options.pos.y - image.height);
		DrawTool.instance.drawGuide(_guia, false);
	}
	
	public function getPivot():Vector
	{
		return _guia;
	}
}