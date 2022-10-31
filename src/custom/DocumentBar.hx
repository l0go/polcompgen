package custom;

import haxe.ui.containers.Frame;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.macros.ComponentMacros.build("assets/document-bar.xml"))
class DocumentBar extends Frame {
	public var compass: Compass;

	public function new() {
		super();
#if !js
		exportButton.hidden = true;
		addImageButton.percentWidth = 100;
#end
	}

	@:bind(exportButton, MouseEvent.MOUSE_DOWN)
		function export(e: MouseEvent) {
#if js
			Html2Canvas.html2canvas(compass.element).then((canvas: js.html.CanvasElement) -> {
				js.Browser.window.open(canvas.toDataURL());
			});
#end
		}
}
