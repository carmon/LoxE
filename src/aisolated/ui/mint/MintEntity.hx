package ui.mint;

import luxe.Entity;
import luxe.Input.KeyEvent;
import luxe.Input.MouseEvent;
import luxe.Input.TextEvent;
import luxe.Input.TouchEvent;
import luxe.options.EntityOptions;
import mint.Canvas;
import mint.layout.margins.Margins;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import phoenix.Color;

typedef MintEntityOptions = {
	> EntityOptions,
	var render:LuxeMintRender;
};

/**
 * ...
 * @author Carmon
 */
class MintEntity extends Entity
{
	private var _canvas:Canvas;
	private var _layout:Margins;
	private var _render:LuxeMintRender;

	public function new(options:MintEntityOptions) 
	{	
		super( {
			name: (options.name != null) ? options.name : 'default_mint_entity'
		});
		
		if(options.render != null) _render = options.render;
		else {
			_render = new LuxeMintRender({});
		}
		
		_canvas = new Canvas({
			name: this.name + '_canvas',
			rendering: _render,
			options: { color:new Color(1, 1, 1, 0.0) },
			x: 0, y: 0, w: Luxe.screen.w, h: Luxe.screen.h
		});
		
		_layout = new Margins();
	}
	
	override public function update(dt:Float) 
	{
		_canvas.update(dt);
	}
	
	override public function onmousemove(event:MouseEvent) 
	{
		_canvas.mousemove( Convert.mouse_event(event) );
	}
	
	override public function onmousewheel(event:MouseEvent) 
	{
		_canvas.mousewheel( Convert.mouse_event(event) );
	}
	
	override public function onmouseup(event:MouseEvent) 
	{
		_canvas.mouseup( Convert.mouse_event(event) );
	}
	
	override public function onmousedown(event:MouseEvent) 
	{
		_canvas.mousedown( Convert.mouse_event(event) );
	}
	
	override public function onkeydown(event:KeyEvent) 
	{
		_canvas.keydown( Convert.key_event(event) );
	}
	
	override public function ontextinput(event:TextEvent) 
	{
		_canvas.textinput( Convert.text_event(event) );
	}
	
	override public function onkeyup(event:KeyEvent) 
	{
		_canvas.keyup( Convert.key_event(event) );
	}
}