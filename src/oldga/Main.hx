
import luxe.Color;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Sprite;
import phoenix.Batcher;
import phoenix.RenderTexture;
import phoenix.Vector;

class Main extends luxe.Game
{
	
	var final_output :RenderTexture;
    var final_batch  :Batcher;
    var final_view 	 :Sprite;
	
	//Main_04_12_04

    override function ready() {
		
        final_output = new RenderTexture(Luxe.resources, Luxe.screen.size);
		
		final_batch = Luxe.renderer.create_batcher( { no_add:true } );
		
		Luxe.renderer.batcher = final_batch;
		
		final_view = new Sprite({
            centered : false,
            pos : new Vector(0,0),
            size : Luxe.screen.size,
            texture : final_output
        });
		
		Luxe.renderer.clear_color.rgb(0x121212);
		
		new Game();
    } //ready
	
	override function onprerender() {
		
        Luxe.renderer.target = final_output;
        Luxe.renderer.clear(new Color(0,0,0,1));
		
    } //onprerender
	
	override function onpostrender() {
		
		Luxe.renderer.target = null;
		
		Luxe.renderer.clear(new Color(1, 0, 0, 1));
		
        final_batch.draw();
		
        //Luxe.renderer.blend_mode(/*BlendMode.src_alpha, BlendMode.zero*/);
		
	} //onpostrender

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

} //Main
