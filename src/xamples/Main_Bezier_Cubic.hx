
import luxe.Circle;
import luxe.Color;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Input.MouseEvent;
import luxe.Vector;
import phoenix.geometry.CircleGeometry;
import phoenix.geometry.LineGeometry;


class Main extends luxe.Game {


    public var mouse    : Vector;
	
	private var _segments:Array<LineGeometry>;
	
	private var _init_point:Vector;
	private var _end_point:Vector;
	
	private var _control_point_1:Vector;
	private var _control_point_2:Vector;
	
	private var _circle_geom_1:CircleGeometry;
	private var _circle_geom_2:CircleGeometry;
	
	private var _drag:Circle;
	private var _control_circle_1:Circle;
	private var _control_circle_2:Circle;

    override function ready() {

        mouse = new Vector();
       
		_init_point = new Vector(Luxe.screen.w * .25, Luxe.screen.mid.y);
		_end_point = new Vector(Luxe.screen.w * .75, Luxe.screen.mid.y);
		_control_point_1 = new Vector(Luxe.screen.w * .3, Luxe.screen.h * .25);
		_control_point_2 = new Vector(Luxe.screen.w * .7, Luxe.screen.h * .25);
		
		
		_control_circle_1 = new Circle(_control_point_1.x, _control_point_1.y, 5);
		_control_circle_2 = new Circle(_control_point_2.x, _control_point_2.y, 5);
		
		_circle_geom_1 = Luxe.draw.circle( {
			x: _control_circle_1.x,
			y: _control_circle_1.y,
			rx: _control_circle_1.r,
			ry: _control_circle_1.r
		});
		
		_circle_geom_2 = Luxe.draw.circle( {
			x: _control_circle_2.x,
			y: _control_circle_2.y,
			rx: _control_circle_2.r,
			ry: _control_circle_2.r
		});
		
		_segments = new Array<LineGeometry>();
		
		var num_seg:Int = 16;
		var sub:Float = 1 / num_seg;
		for (i in 0...num_seg) {
			
			var offset:Float = sub * i;
			var init_point:Vector = getBeizerPoint(_init_point, _control_point_1, offset, _control_point_2, _end_point);
			
			offset += sub;
			var end_point:Vector = getBeizerPoint(_init_point, _control_point_1, offset, _control_point_2, _end_point);
			
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
	
	private function getBeizerPoint(p0:Vector, g0:Vector, t:Float, g1:Vector, p1:Vector):Vector
	{
		return new Vector(Math.pow((1 - t), 3) * p0.x + Math.pow(t, 3) * p1.x + 3 * Math.pow(t, 2) * (1 - t) * g1.x + 3 * Math.pow((1 - t), 2) * t * g0.x,
		Math.pow((1 - t), 3) * p0.y + Math.pow(t, 3) * p1.y + 3 * Math.pow(t, 2) * (1 - t) * g1.y + 3 * Math.pow((1 - t), 2) * t * g0.y);
	}
	
    override function onmousemove( e:MouseEvent ) 
	{		
		if (_drag != null) {
			_drag.x = e.x;
			_drag.y = e.y;
			
			_circle_geom_1.set(_control_circle_1.x, _control_circle_1.y, _control_circle_1.r, _control_circle_1.r, 1);
			_circle_geom_2.set(_control_circle_2.x, _control_circle_2.y, _control_circle_2.r, _control_circle_2.r, 1);
			
			_control_point_1.x = _control_circle_1.x;
			_control_point_1.y = _control_circle_1.y;
			
			_control_point_2.x = _control_circle_2.x;
			_control_point_2.y = _control_circle_2.y;
			
			var sub:Float = 1 / _segments.length;
			for (i in 0..._segments.length) {
				
				var offset:Float = sub * i;
				var init_point:Vector = getBeizerPoint(_init_point, _control_point_1, offset, _control_point_2, _end_point);
				
				offset += sub;
				var end_point:Vector = getBeizerPoint(_init_point, _control_point_1, offset, _control_point_2, _end_point);
				
				_segments[i].set_p0(init_point);
				_segments[i].set_p1(end_point);
			}
		}
    } //onmousemove

    override function onmousedown( e:MouseEvent ) {
        
		if (_control_circle_1.point_inside(e.pos)) {
			_drag = _control_circle_1;
		} else if (_control_circle_2.point_inside(e.pos)) {
			_drag = _control_circle_2;
		} else {
			_drag = null;
		}
		
    } //onmousedown

    override function onmouseup( e:MouseEvent ) {
		_drag = null;
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
