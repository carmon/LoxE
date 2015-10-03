package xamples.ui;
import haxe.Log;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Batcher.PrimitiveType;
import phoenix.geometry.Geometry;
import phoenix.geometry.Vertex;

/**
 * ...
 * @author Carmon
 */
class Segment extends Sprite
{	
	public function new(id:Int, init:Vector, end:Vector) 
	{
		var dif:Vector = new Vector(end.x - init.x, end.y - init.y);
		var ang:Float = Math.atan2(dif.y, dif.x);
		
		super( {
			name: 'line_segment_' + id,
			origin: new Vector(0, 8),
			pos: init,
			rotation_z: (ang * 180) / Math.PI,
			size: new Vector(dif.length, 16),
			color : new Color(0, 0, 0, 1),
			depth: 0
		});		
	}
	
	public function updateVectors(init:Vector, perp_init:Vector, end:Vector, perp_end:Vector)
	{				
		var dif:Vector = new Vector(end.x - init.x, end.y - init.y);
		var ang:Float = Math.atan2(dif.y,dif.x);
		
		this.pos = init;
		this.size = new Vector(dif.length, 16);
		this.rotation_z = (ang * 180) / Math.PI;
		
		var geom:Geometry = new Geometry( {
			pos: new Vector(),
			primitive_type: PrimitiveType.triangle_fan,
			color: new Color().rgb(0xFF00CC),
			depth: 0.1,
			batcher : Luxe.renderer.batcher,
			immediate: true
		});
		
		var h:Int = 8;
		perp_init.length = h;
		perp_end.length = h;
		
		var corners = [new Vector(init.x + perp_init.x, init.y + perp_init.y), new Vector(end.x + perp_end.x, end.y + perp_end.y), new Vector(end.x - perp_end.x, end.y - perp_end.y), new Vector(init.x - perp_init.x, init.y - perp_init.y)];
		
		geom.add(new Vertex(corners[3], geom.color));
		geom.add(new Vertex(corners[0], geom.color));
		geom.add(new Vertex(corners[1], geom.color));
		
		geom.add(new Vertex(corners[3], geom.color));		
		geom.add(new Vertex(corners[2], geom.color));
		geom.add(new Vertex(corners[1], geom.color));	
	}
}