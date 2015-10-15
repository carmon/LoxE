package states;

import luxe.Color;
import luxe.Input.MouseEvent;
import luxe.States.State;
import luxe.tilemaps.Isometric;
import luxe.tilemaps.Tilemap.TileOffset;
import mint.Window;
import phoenix.geometry.CircleGeometry;
import phoenix.Vector;
import states.don.Editor_UI;
import states.don.ExtendedTiledMap;

/**
 * ...
 * @author Carmon
 */
class DonMap extends State
{
	var set_window:Window;
	
	var tiled_iso :ExtendedTiledMap;
    var tile_offset_circle : CircleGeometry;

	var editor_ui :Editor_UI;

	public function new() 
	{
		super({ name: 'don.map'});
	}
	
	override public function onenter(_)
	{
		Luxe.renderer.clear_color = new Color().rgb(0xffffff);
		
		load_isometric_tiledmap();
		create_ui();
		
		tile_offset_circle =  Luxe.draw.circle({
            x : 0,
            y : 0,
            r : 3,
            color : new Color(0,1.0,0,1.0),
            depth : 700
        });
	}
	
	private function load_isometric_tiledmap() 
	{
		var res = Luxe.resources.text('assets/don/config/default_map.tmx');
		tiled_iso = new ExtendedTiledMap(res.asset.text);		
    } //load_isometric_tiledmap
	
	private function create_ui()
	{
		editor_ui = new Editor_UI();
		editor_ui.setup_tileset(tiled_iso.get_tileset_data());
	}
	
	override function onmouseup( e:MouseEvent ) 
	{
		/*
            // Get the tile position that the mouse is hovering.
        var mouse_pos = Luxe.camera.screen_point_to_world( e.pos );

		//for the iso map
        var _scale = tiled_iso.visual.options.scale;
        var tile = tiled_iso.tile_at_pos('Tile Layer 1', mouse_pos, _scale );

        if( tile != null ) {
            var oldid = tile.id;
            tile.id = 1+Std.random(8);
            trace('ISO set a new id from $oldid to ${tile.id}!');
        }
		*/
    } //onmouseup

    override function onmousemove( e:MouseEvent ) 
	{
		/*
        if (tiled_iso == null) return;
		
        // Get the tile position that the mouse is hovering.
        var mouse_pos = Luxe.camera.screen_point_to_world( e.pos );
		
		var _scale = tiled_iso.visual.options.scale;
        var tile = tiled_iso.tile_at_pos('Tile Layer 1', mouse_pos, _scale );
        if( tile != null ) {

				//  Translate the mouse position so that it is relative to the tiled map.
            var mouse_pos_relative = new Vector(mouse_pos.x - tiled_iso.pos.x, mouse_pos.y - tiled_iso.pos.y);

				//	Get the position in world coords of the tile that is being hovered.
			var tile_pos = Isometric.tile_coord_to_worldpos(tile.x, tile.y, tiled_iso.tile_width, tiled_iso.tile_height, _scale);

				//	Find position of the mouse relative to the tile that is being hovered.
			mouse_pos_relative.x -= tile_pos.x;
			mouse_pos_relative.y -= tile_pos.y;

			mouse_pos_relative = Isometric.worldpos_to_tile_coord(mouse_pos_relative.x, mouse_pos_relative.y, tiled_iso.tile_width, tiled_iso.tile_height, _scale);

				//  Create the offset depending on which corner is closest to the mouse position.
            var offset_x = TileOffset.right;
            var offset_y = TileOffset.bottom;
            if (mouse_pos_relative.x <= 0.33) {
                offset_x = TileOffset.left;
            }
            else if (mouse_pos_relative.x <= 0.66) {
                offset_x = TileOffset.center;
            }

            if (mouse_pos_relative.y <= 0.33) {
                offset_y = TileOffset.top;
            }
            else if (mouse_pos_relative.y <= 0.66) {
                offset_y = TileOffset.center;
            }

			tile_pos = Isometric.tile_coord_to_worldpos(tile.x, tile.y, tiled_iso.tile_width, tiled_iso.tile_height, _scale, offset_x, offset_y);
			tile_pos.x += tiled_iso.pos.x;
			tile_pos.y += tiled_iso.pos.y;			
			
			tile_offset_circle.transform.pos.x = tile_pos.x;
            tile_offset_circle.transform.pos.y = tile_pos.y;
        }
		*/

    } //onmousemove
}