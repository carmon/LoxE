package entities;
import config.Defines;
import graphics.Segment;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import phoenix.Vector;

/**
 * ...
 * @author Carmon
 */
class Cable
{
	private var _id:String;
	private var _segments:Array<Segment>;
	
	private var _init_point:Vector;
	private var _control_point:Vector;
	private var _end_point:Vector;
	
	private var _quiet:Bool;
	public var quiet(get, set):Bool;
	private function get_quiet():Bool
	{
		return _quiet;
	}
	private function set_quiet(value:Bool):Bool
	{
		_quiet = value;
		draw(true);
		return _quiet;
	}
	
	public function new(id:String, init:Vector) 
	{		
		_id = id;
		_init_point = init;
		
		_quiet = false;
		
		_segments = new Array<Segment>();
	}
	
	public function setEnd(end:Vector):Void
	{
		_control_point = lerpPoint(_init_point, .5, end);
		_end_point = end;
	}
	
	public function getEnd():Vector
	{
		return _end_point;
	}
	
	public function getLengthX():Float
	{
		return _end_point.x - _control_point.x + _control_point.x - _init_point.x;
	}
	
	public function getLengthY():Float
	{
		return _end_point.y - _control_point.y + _control_point.y - _init_point.y;
	}
	
	private function lerpPoint(p0:Vector, t:Float, p1:Vector):Vector
	{
		return new Vector((1 - t) * p0.x + t * p1.x, (1 - t) * p0.y + t * p1.y);
	}
	
	private function getBeizerPoint(p0:Vector, g0:Vector, t:Float, p1:Vector):Vector
	{				
		return new Vector(Math.pow((1 - t), 2) * p0.x + 2 * (1 - t) * t * g0.x + Math.pow(t, 2) * p1.x, Math.pow((1 - t), 2) * p0.y + 2 * (1 - t) * t * g0.y + Math.pow(t, 2) * p1.y);
	}
	
	private function getBezierPerp(p0:Vector, g0:Vector, t:Float, p1:Vector):Vector
	{
		var temp = new Vector (2 * (1 - t) * (g0.x - p0.x) + 2 * t * (p1.x - g0.x), 2 * (1 - t) * (g0.y - p0.y) + 2 * t * (p1.y - g0.y));
		temp.normalize();
		return new Vector(-temp.y, temp.x);
	}
	
	public function draw(?last:Bool = false):Void
	{
		_control_point = lerpPoint(_init_point, .5, _end_point);
		
		var x_length:Float = _end_point.x - _control_point.x + _control_point.x - _init_point.x;
		var y_length:Float = Defines.CABLE_MAX_LENGTH - Math.abs(x_length);
		
		var tmp:Float = Math.abs(_end_point.y - _init_point.y);
		y_length -= tmp;		
		_control_point.y += y_length * .5;
		
		var num_seg:Int = 2 + Math.round(Defines.CABLE_SEGMENTS * (Math.abs(y_length) / Defines.CABLE_MAX_LENGTH));
		var sub:Float = 1 / num_seg;
		for (i in 0...num_seg) {
			var offset:Float = sub * i;
			var init_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			var init_perp:Vector = getBezierPerp(_init_point, _control_point, offset, _end_point);
			
			offset += sub;
			var end_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			var end_perp:Vector = getBezierPerp(_init_point, _control_point, offset, _end_point);
			
			if (_segments[i] == null) {
				_segments.push(new Segment(_id + '_segment_' + _segments.length, init_point, end_point));
			}
			_segments[i].updateVectors(init_point, init_perp, end_point, end_perp, last);			
		}
	}
	
	public function destroy() 
	{
		for (i in 0..._segments.length) {
			_segments[i].destroy();
			_segments[i] = null;
		}
		_init_point = _control_point = _end_point = null;
	}
}