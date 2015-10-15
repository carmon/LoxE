package states.don.ui;
import luxe.Log.*;
import mint.Control;
import mint.render.luxe.LuxeMintRender;

/**
 * ...
 * @author Carmon
 */
class CustomMintRender extends LuxeMintRender
{
    public function new( ?_options:luxe.options.RenderProperties ) {

        super(_options);
    } //new

    override function get<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case mint.Canvas:       new mint.render.luxe.Canvas(cast this, cast control);
            case mint.Label:        new mint.render.luxe.Label(cast this, cast control);
            case mint.Button:       new mint.render.luxe.Button(cast this, cast control);
            case mint.Image:        new mint.render.luxe.Image(cast this, cast control);
            case mint.List:         new mint.render.luxe.List(cast this, cast control);
            case mint.Scroll:       new mint.render.luxe.Scroll(cast this, cast control);
            case mint.Panel:        new mint.render.luxe.Panel(cast this, cast control);
            case mint.Checkbox:     new mint.render.luxe.Checkbox(cast this, cast control);
            case mint.Window:       new mint.render.luxe.Window(cast this, cast control);
            case mint.TextEdit:     new mint.render.luxe.TextEdit(cast this, cast control);
            case mint.Dropdown:     new mint.render.luxe.Dropdown(cast this, cast control);
            case mint.Slider:       new mint.render.luxe.Slider(cast this, cast control);
            case mint.Progress:     new mint.render.luxe.Progress(cast this, cast control);
			case TileSelectorControl: new TileSelectorRender(cast this, cast control);			
            case _:                 null;
        }
    } //render

} //LuxeMintRender