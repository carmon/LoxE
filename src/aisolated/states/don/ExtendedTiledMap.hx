package states.don;
import luxe.Color;
import luxe.importers.tiled.TiledMap;
import luxe.importers.tiled.TiledTileset;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;
import luxe.Visual;
import phoenix.Batcher;
import phoenix.geometry.RectangleGeometry;
import phoenix.Texture;
import states.don.Options.TilesetData;

/**
 * ...
 * @author Carmon
 */
class ExtendedTiledMap extends TiledMap
{
	private static var PATH:String = 'assets/don/img/';
	
	private var _preview:Preview;

	public function new(source:String) 
	{
		super( {
			asset_path: PATH,
			tiled_file_data: source,
			pos: new Vector(256, 0)
		});
		
		display( { scale: 1, grid: false } );
		
		//loadTilesetsPreviews();
		
	}
	
	public function get_tileset_data():Array<TilesetData>
	{
		var a = new Array<TilesetData>();
		for (tileset in tiledmap_data.tilesets) {
			a.push({
				name: tileset.name,
				img_path: PATH + tileset.texture_name,
				tile_width: tileset.tile_width,
				tile_height: tileset.tile_height
			});
		}
		return a;
	}
	
	private function loadTilesetsPreviews()
	{
		_preview = new Preview();		
		for (_tileset in tiledmap_data.tilesets) {
			_preview.add_tab(_tileset, Luxe.resources.texture(PATH + _tileset.texture_name));
		}
	}
}

class Preview extends Sprite
{
	private var _tabs:Map<String, Tab>;
	
	public function new() 
	{	
		super( { name: 'preview' } ); 
		_tabs = new Map<String, Tab>();
	}
	
	public function add_tab(tileset:TiledTileset, texture:Texture) 
	{
		_tabs.set(tileset.name, new Tab(tileset, texture));
	}
}

class Tab extends Sprite
{
	private var _title:Text;
	private var _img:Visual;
	private var _sel:RectangleGeometry;
	
	public function new(tileset:TiledTileset, texture:Texture)
	{		
		var w:Float = texture.width + 10;
		var h:Float = texture.height + 10;
		
		super( {
			name: tileset.name + "_tab",
			size: new Vector(w, h),
			color: new Color().rgb(0xc2c2c2),
			centered: false,
			pos: new Vector(Luxe.screen.w - w, Luxe.screen.h - h)
		});
		
		_img = new Visual({
			name: tileset.name + "_tab_img",
			texture: texture,
			pos: new Vector(this.pos.x + 5, this.pos.y + 5)
		});
		
		//UI
		var ui_batcher:Batcher = Luxe.renderer.batchers[1];
		
		_title = new Text({
			point_size: 20,
			text: tileset.name,
			pos: new Vector(this.pos.x + 1, this.pos.y - 20),
			color: new Color().rgb(0x000000),
			batcher: ui_batcher
		});
		
		Luxe.draw.rectangle( {
			x: this.pos.x + 1, y: this.pos.y - 20,
			w: _title.geom.text_width,
			h: _title.geom.text_height,
			color: new Color().rgb(0xc2c2c2)
		});
		
		_sel = Luxe.draw.rectangle({
            x : _img.pos.x, y : _img.pos.y,
            w : tileset.tile_width,
            h : tileset.tile_height,
            color : new Color().rgb(0xAA0000),
			batcher: ui_batcher
        });
	}
}