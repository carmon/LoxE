
import haxe.Log;
import luxe.Circle;
import luxe.Color;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Input.MouseEvent;
import luxe.Vector;
import phoenix.geometry.CircleGeometry;
import phoenix.geometry.LineGeometry;
import xamples.ui.Segment;


class Main extends luxe.Game 
{	
	private var _segments:Array<Segment>;
	
	private var _init_point:Vector;
	private var _end_point:Vector;
	
	private var _control_point:Vector;
	
	private var MAX_LENGTH:Float = 300;
	
    override function ready() {
		
		Luxe.renderer.clear_color = new Color().rgb(0xfde100);
		
        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('down', Key.down);
       
		_init_point = new Vector(Luxe.screen.w * .5, Luxe.screen.mid.y);
		_end_point = new Vector(_init_point.x + MAX_LENGTH, Luxe.screen.mid.y);
		_control_point = new Vector(_init_point.x + (MAX_LENGTH * .5), Luxe.screen.mid.y);
		
		_segments = new Array<Segment>();
		
		var num_seg:Int = 2;
		var sub:Float = 1 / num_seg;
		for (i in 0...num_seg) {
			
			var offset:Float = sub * i;
			var init_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			
			offset += sub;
			var end_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			
			_segments.push(new Segment(_segments.length, init_point, end_point));
		}		
		redraw();
		
    } //ready
	
	private function lerpFloat(f0:Float, t:Float, f1:Float):Float
	{
		return (1 - t) * f0 + t * f1;
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
	
	private function redraw()
	{
		_control_point.x = lerpFloat(_init_point.x, .5, _end_point.x);
		_control_point.y = lerpFloat(_init_point.y, .5, _end_point.y);
		
		var x_length:Float = _end_point.x - _control_point.x + _control_point.x - _init_point.x;
		var y_length:Float = MAX_LENGTH - Math.abs(x_length);
		
		var tmp:Float = Math.abs(_end_point.y - _init_point.y);
		y_length -= tmp;		
		_control_point.y += y_length * .5;
		
		var num_seg:Int = 2 + Math.round(16 * (Math.abs(y_length) / MAX_LENGTH));
		var sub:Float = 1 / num_seg;
		for (i in 0...num_seg) {			
			var offset:Float = sub * i;
			var init_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			var init_perp:Vector = getBezierPerp(_init_point, _control_point, offset, _end_point);
			
			offset += sub;
			var end_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			var end_perp:Vector = getBezierPerp(_init_point, _control_point, offset, _end_point);
			
			if (_segments[i] == null) {
				_segments.push(new Segment(_segments.length, init_point, end_point));
				_segments[i].updateVectors(init_point, init_perp, end_point, end_perp);
			} else {
				_segments[i].updateVectors(init_point, init_perp, end_point, end_perp);
			}
			_segments[i].visible = true;
		}		
		for (j in num_seg..._segments.length) {			
			_segments[j].visible = false;
		}
	}
	
	private function getDistanceBetweenVectors(vec1:Vector, vec2:Vector):Float
	{
		var temp:Vector = new Vector(vec1.x - vec2.x, vec1.y - vec2.y);
		return temp.length;
	}
	
    override function onkeyup( e:KeyEvent ) {
		
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    } //onkeyup

	override public function update(dt:Float) 
	{		
		var x_length:Float = _end_point.x - _control_point.x + _control_point.x - _init_point.x;
		var y_length:Float = _end_point.y - _control_point.y + _control_point.y - _init_point.y;
		
		if (Luxe.input.inputdown('left')) {
			if (Math.abs(x_length - 5) + Math.abs(y_length) <= MAX_LENGTH) _end_point.x -= 5;
		} else if (Luxe.input.inputdown('right')) {
			if (Math.abs(x_length + 5) + Math.abs(y_length) <= MAX_LENGTH) _end_point.x += 5;
		}
		
		if (Luxe.input.inputdown('up')) {
			if(Math.abs(x_length) + Math.abs(y_length - 5) <= MAX_LENGTH) _end_point.y -= 5;
		} else if (Luxe.input.inputdown('down')) {
			if(Math.abs(x_length) + Math.abs(y_length + 5) <= MAX_LENGTH) _end_point.y += 5;
		}
		
		redraw();
		super.update(dt);
	}

} //Main
