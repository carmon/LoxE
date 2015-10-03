
import luxe.Circle;
import luxe.Color;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Input.MouseEvent;
import luxe.Vector;
import phoenix.geometry.CircleGeometry;
import phoenix.geometry.LineGeometry;


class Main_Bezier_Quad extends luxe.Game {


    public var mouse    : Vector;
	
	private var _segments:Array<LineGeometry>;
	
	private var _init_point:Vector;
	private var _end_point:Vector;
	
	private var _control_point:Vector;
	
	private var _circle_geom:CircleGeometry;
	
	private var _dragging:Bool;
	private var _control_circle:Circle;

    override function ready() {

        mouse = new Vector();
       
		_init_point = new Vector(Luxe.screen.w * .25, Luxe.screen.mid.y);
		_end_point = new Vector(Luxe.screen.w * .75, Luxe.screen.mid.y);
		_control_point = new Vector(Luxe.screen.w * .5, Luxe.screen.h * .25);
		
		_dragging = false;
		
		_control_circle = new Circle(_control_point.x, _control_point.y, 5);
		
		_circle_geom = Luxe.draw.circle( {
			x: _control_circle.x,
			y: _control_circle.y,
			rx: _control_circle.r,
			ry: _control_circle.r
		});
		
		_segments = new Array<LineGeometry>();
		
		var num_seg:Int = 16;
		var sub:Float = 1 / num_seg;
		for (i in 0...num_seg) {
			
			var offset:Float = sub * i;
			var init_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			
			offset += sub;
			var end_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
			
			_segments.push(Luxe.draw.line( {
				p0 : init_point,
				p1 : end_point,
				color : new Color(Math.random(), Math.random(), Math.random(), 1)
			}));
		}
		
    } //ready
	
	private function lerpPoint(p0:Vector, t:Float, p1:Vector):Vector
	{
		return new Vector((1 - t) * p0.x + t * p1.x, (1 - t) * p0.y + t * p1.y);
	}
	
	private function getBeizerPoint(p0:Vector, g0:Vector, t:Float, p1:Vector):Vector
	{
		return new Vector(Math.pow((1 - t), 2) * p0.x + Math.pow(t, 2) * p1.x + 2 * (1 - t)* t * g0.x,
		Math.pow((1 - t), 2) * p0.y + Math.pow(t, 2) * p1.y + 2 * (1 - t)* t * g0.y);
	}
	
    override function onmousemove( e:MouseEvent ) 
	{		
		if (_dragging) {
			_control_point.x = _control_circle.x = e.x;
			_control_point.y = _control_circle.y = e.y;
			
			_circle_geom.set(_control_circle.x, _control_circle.y, _control_circle.r, _control_circle.r, 1);			
			
			var sub:Float = 1 / _segments.length;
			for (i in 0..._segments.length) {
				
				var offset:Float = sub * i;
				var init_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
				
				offset += sub;
				var end_point:Vector = getBeizerPoint(_init_point, _control_point, offset, _end_point);
				
				_segments[i].set_p0(init_point);
				_segments[i].set_p1(end_point);
			}
		}
    } //onmousemove

    override function onmousedown( e:MouseEvent ) {
        
		_dragging = _control_circle.point_inside(e.pos);
		
    } //onmousedown

    override function onmouseup( e:MouseEvent ) {
		_dragging = false;
    } //onmouseup

    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    } //onkeyup

	override public function update(dt:Float) 
	{		
		super.update(dt);
	}

} //Main
