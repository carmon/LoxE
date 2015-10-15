package states.don;

import mint.Control;
import mint.Dropdown;
import mint.Image;
import mint.layout.margins.Margins.MarginTarget;
import mint.layout.margins.Margins.MarginType;
import mint.types.Types.MouseEvent;
import mint.types.Types.TextAlign;
import mint.Window;
import phoenix.Color;
import phoenix.Texture;
import states.don.Options.TilesetData;
import states.don.ui.TileSelectorControl;
import ui.mint.MintEntity;

/**
 * ...
 * @author Carmon
 */
class Editor_UI extends MintEntity
{
	//tilesets	
	private var _ts_info:Array<TilesetData>;
	private var _ts_window:Window;	
	private var _ts_selector:TileSelectorControl;
	
	public function new() 
	{
		super( { name: 'don_map_ui' } );
		
		//create_window2();
	}
	
	public function setup_tileset(info:Array<TilesetData>)
	{
		if (info == null || info.length == 0) {
			trace("no tileset found");
			return;
		}
		
		_ts_info = info;
		
		//var text = Luxe.resources.texture(d.img_path);
		//var w_width:Float = text.width + 30;
		
		_ts_window = new Window({
            parent: _canvas, name: 'tilesets_window', title: 'Tilesets',
            closable: false, collapsible: false,
            x: Luxe.screen.w - 300, y:Luxe.screen.mid.y, 
			w: Options.WIN_DEFAULT_WIDTH, h: 131,
            h_max: 131, h_min: 131, w_min: Options.WIN_DEFAULT_WIDTH
        });
		
		var combo:Dropdown = new Dropdown({
			parent: _ts_window, name: 'tilesets_dropdown',
			text: 'Tileset...', x: 15, y: 0, w: Options.WIN_DEFAULT_WIDTH - 15, h: 24,
			options: { color:new Color().rgb(0x343439) }
		});
		
		combo.onselect.listen(function (idx:Int, control:Control, event:MouseEvent)
		{
			var d = _ts_info[idx]; 
			combo.label.text = d.name;
			
			if (_ts_selector != null) {				
				_ts_selector.destroy();
				_ts_selector = null;
			}
				
			_ts_selector = new TileSelectorControl({
				parent: _ts_window, name: 'tilesets_preview_selector',
				path: d.img_path, x: 15, y: 0, w: d.tile_width, h: d.tile_height
			});
				
			//_ts_window.w = t.width + 30;
			//combo.w = t.width;
			
			_layout.margin(_ts_selector, MarginTarget.top, MarginType.fixed, 150);
			_layout.margin(_ts_selector, MarginTarget.right, MarginType.fixed, 15);
		}); 
		
		for (t in _ts_info) {
			combo.add_item(
				new mint.Label({
					parent: combo, text: t.name, 
					name: 'combo_opt_' + t.name,
					w: combo.w - 10, h: 24,
					align: TextAlign.left
				}),	10
			);
		}
		
		
		
		_layout.margin(combo, MarginTarget.top, MarginType.fixed, 30);
        _layout.margin(combo, MarginTarget.right, MarginType.fixed, 15);
	}
	
	private function on_image_mouse_up(event:MouseEvent, control:Control)
	{
		trace(event);
	}
}