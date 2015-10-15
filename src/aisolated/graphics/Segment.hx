package graphics;
import config.Defines;
import haxe.Log;
import luxe.Color;
import luxe.Entity;
import luxe.Sprite;
import luxe.Vector;
import luxe.Visual;
import phoenix.Batcher.PrimitiveType;
import phoenix.geometry.Geometry;
import phoenix.geometry.Vertex;

/**
 * ...
 * @author Carmon
 */
class Segment extends Visual
{	
	public function new(id:String, init:Vector, end:Vector) 
	{
		var dif:Vector = new Vector(end.x - init.x, end.y - init.y);
		var ang:Float = Math.atan2(dif.y, dif.x);
		
		super( {
			name: id,
			visible: false
		});
	}
	
	public function updateVectors(init:Vector, perp_init:Vector, end:Vector, perp_end:Vector, ?last:Bool = false)
	{				
		var dif:Vector = new Vector(end.x - init.x, end.y - init.y);
		var ang:Float = Math.atan2(dif.y, dif.x);
		
		perp_init.length = perp_end.length = Defines.CABLE_TICKNESS;
		
		var geom:Geometry = new Geometry( {
			pos: new Vector(),
			primitive_type: PrimitiveType.triangle_fan,
			color: new Color().rgb(0x000000),
			depth: Defines.DEPTH_SEGMENT,
			batcher : Luxe.renderer.batcher,
			immediate: !last
		});
		
		var corners = [new Vector(init.x + perp_init.x, init.y + perp_init.y), new Vector(end.x + perp_end.x, end.y + perp_end.y), new Vector(end.x - perp_end.x, end.y - perp_end.y), new Vector(init.x - perp_init.x, init.y - perp_init.y)];
		
		geom.add(new Vertex(corners[3], geom.color));
		geom.add(new Vertex(corners[0], geom.color));
		geom.add(new Vertex(corners[1], geom.color));
		
		geom.add(new Vertex(corners[3], geom.color));		
		geom.add(new Vertex(corners[2], geom.color));
		geom.add(new Vertex(corners[1], geom.color));	
	}
}